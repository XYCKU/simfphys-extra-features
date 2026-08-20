#!/usr/bin/env python3
"""Validate SEF's static loader, registry, and asset contracts.

This intentionally checks only literal declarations. GLua compilation and game
runtime behavior belong to the GMod runner jobs added later.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from collections import Counter
from pathlib import Path


MANIFEST_LISTS = (
    "SharedFiles",
    "ServerFiles",
    "ClientFiles",
    "DevelopmentClientFiles",
    "VehicleConfigFiles",
)
ALLOWED_ADDON_TYPES = {
    "ServerContent",
    "gamemode",
    "map",
    "weapon",
    "vehicle",
    "npc",
    "tool",
    "effects",
    "model",
    "entity",
}
ALLOWED_WORKSHOP_TAGS = {
    "fun",
    "roleplay",
    "scenic",
    "movie",
    "realism",
    "cartoon",
    "water",
    "comic",
    "build",
}


def add_error(errors: list[str], message: str) -> None:
    errors.append(message)


def read_text(path: Path, errors: list[str]) -> str | None:
    try:
        return path.read_text(encoding="utf-8")
    except FileNotFoundError:
        add_error(errors, f"missing file: {path.as_posix()}")
    except UnicodeDecodeError:
        add_error(errors, f"file is not UTF-8: {path.as_posix()}")

    return None


def extract_manifest_list(text: str, name: str, errors: list[str]) -> list[str]:
    pattern = re.compile(
        rf"^local\s+{name}\s*=\s*\{{(?P<body>.*?)^\s*\}}",
        re.MULTILINE | re.DOTALL,
    )
    match = pattern.search(text)
    if not match:
        add_error(errors, f"loader is missing the {name} list")
        return []

    return re.findall(r'^\s*"([^"\r\n]+)"\s*,?\s*$', match.group("body"), re.MULTILINE)


def find_in_order(text: str, patterns: list[str]) -> bool:
    offset = 0
    for pattern in patterns:
        match = re.search(pattern, text[offset:], re.MULTILINE | re.DOTALL)
        if not match:
            return False
        offset += match.end()
    return True


def validate_loader(root: Path, errors: list[str]) -> dict[str, list[str]]:
    bootstrap = root / "lua" / "autorun" / "sef_init.lua"
    text = read_text(bootstrap, errors)
    if text is None:
        return {name: [] for name in MANIFEST_LISTS}

    manifests = {
        name: extract_manifest_list(text, name, errors)
        for name in MANIFEST_LISTS
    }
    all_entries = [entry for entries in manifests.values() for entry in entries]
    duplicates = sorted(entry for entry, count in Counter(all_entries).items() if count > 1)
    for entry in duplicates:
        add_error(errors, f"loader lists '{entry}' more than once")

    lua_root = root / "lua"
    for entry in all_entries:
        if not entry.endswith(".lua"):
            add_error(errors, f"loader entry is not a Lua file: {entry}")
        if not (lua_root / entry).is_file():
            add_error(errors, f"loader entry does not exist: lua/{entry}")

    for name in ("ServerFiles", "ClientFiles", "DevelopmentClientFiles"):
        prefix = "sv_" if name == "ServerFiles" else "cl_"
        for entry in manifests[name]:
            if not Path(entry).name.startswith(prefix):
                add_error(errors, f"{name} entry must start with '{prefix}': {entry}")

    for entry in manifests["SharedFiles"]:
        if Path(entry).name.startswith(("sv_", "cl_")):
            add_error(errors, f"shared loader entry has a realm-specific prefix: {entry}")

    for entry in manifests["VehicleConfigFiles"]:
        if not entry.startswith("sef/vehicles/"):
            add_error(errors, f"vehicle config is outside sef/vehicles: {entry}")

    tracked_modules = {
        path.relative_to(lua_root).as_posix()
        for path in (lua_root / "sef").rglob("*.lua")
    }
    unlisted_modules = sorted(tracked_modules - set(all_entries))
    for entry in unlisted_modules:
        add_error(errors, f"SEF Lua module is not listed by the loader: {entry}")

    server_marker = text.find("if SERVER then")
    client_marker = text.find("if CLIENT then")
    if server_marker == -1 or client_marker == -1 or server_marker >= client_marker:
        add_error(errors, "loader must contain ordered SERVER and CLIENT blocks")
        return manifests

    server_block = text[server_marker:client_marker]
    client_block = text[client_marker:]
    send_pattern = (
        r"for\s+_,\s*files\s+in\s+ipairs\s*\(\s*\{\s*"
        r"SharedFiles\s*,\s*ClientFiles\s*,\s*VehicleConfigFiles\s*\}\s*\)\s*do"
    )
    if not re.search(send_pattern, server_block, re.MULTILINE | re.DOTALL):
        add_error(errors, "server loader must send shared, client, and vehicle files")

    server_order = [
        r"IncludeAll\s*\(\s*SharedFiles\s*\)",
        r"IncludeAll\s*\(\s*ServerFiles\s*\)",
        r"Registry\.SyncFeatures\s*\(\s*\)",
        r"IncludeAll\s*\(\s*VehicleConfigFiles\s*\)",
    ]
    if not find_in_order(server_block, server_order):
        add_error(errors, "server loader include order no longer matches the SEF contract")

    client_order = [
        r"IncludeAll\s*\(\s*SharedFiles\s*\)",
        r"Registry\.SyncFeatures\s*\(\s*\)",
        r"IncludeAll\s*\(\s*ClientFiles\s*\)",
        r"IncludeAll\s*\(\s*VehicleConfigFiles\s*\)",
    ]
    if not find_in_order(client_block, client_order):
        add_error(errors, "client loader include order no longer matches the SEF contract")

    return manifests


def validate_addon_metadata(root: Path, errors: list[str]) -> None:
    path = root / "addon.json"
    text = read_text(path, errors)
    if text is None:
        return

    try:
        metadata = json.loads(text)
    except json.JSONDecodeError as error:
        add_error(errors, f"addon.json is invalid JSON: {error.msg}")
        return

    if not isinstance(metadata.get("title"), str) or not metadata["title"].strip():
        add_error(errors, "addon.json must contain a non-empty title")
    if metadata.get("type") not in ALLOWED_ADDON_TYPES:
        add_error(errors, "addon.json contains an unsupported Workshop type")

    tags = metadata.get("tags")
    if not isinstance(tags, list) or not 1 <= len(tags) <= 2:
        add_error(errors, "addon.json must contain one or two Workshop tags")
    elif any(not isinstance(tag, str) or tag not in ALLOWED_WORKSHOP_TAGS for tag in tags):
        add_error(errors, "addon.json contains an unsupported Workshop tag")

    ignore = metadata.get("ignore")
    if not isinstance(ignore, list) or any(not isinstance(pattern, str) for pattern in ignore):
        add_error(errors, "addon.json ignore must be a list of strings")


def validate_vehicle_configs(
    root: Path,
    vehicle_entries: list[str],
    errors: list[str],
) -> None:
    models: dict[str, str] = {}
    sprite_paths: set[str] = set()
    font_names: set[str] = set()
    registration_pattern = re.compile(
        r"\bRegistry\.Register\s*\(\s*(?P<argument>\"[^\"\r\n]+\"|[A-Za-z_]\w*)\s*,\s*(?P<data>\{|[A-Za-z_]\w*)",
        re.MULTILINE,
    )
    model_assignment = re.compile(r'\blocal\s+(\w+)\s*=\s*"([^"\r\n]+)"')
    sprite_assignment = re.compile(r'\bsprite\s*=\s*"([^"\r\n]+)"')
    font_assignment = re.compile(r'\bfont\s*=\s*"([^"\r\n]+)"')

    for entry in vehicle_entries:
        path = root / "lua" / entry
        text = read_text(path, errors)
        if text is None:
            continue

        registrations = list(registration_pattern.finditer(text))
        all_registrations = re.findall(r"\bRegistry\.Register\s*\(", text)
        if not registrations:
            add_error(errors, f"vehicle config has no supported Registry.Register call: {entry}")
            continue
        if len(registrations) != len(all_registrations):
            add_error(errors, f"vehicle config registration must use a literal model or local alias: {entry}")

        if not re.search(r"\b(indicators|text_indicators|features)\s*=", text):
            add_error(errors, f"vehicle config declares no dashboard or feature data: {entry}")

        local_models = dict(model_assignment.findall(text))
        for registration in registrations:
            argument = registration.group("argument")
            model = argument[1:-1] if argument.startswith('"') else local_models.get(argument)
            if model is None:
                add_error(errors, f"vehicle config model alias is not a local string: {entry}")
                continue
            if not model.startswith("models/") or not model.endswith(".mdl"):
                add_error(errors, f"vehicle config has an invalid model path: {entry}: {model}")
                continue
            if model in models:
                add_error(errors, f"vehicle model is registered twice: {model} ({models[model]}, {entry})")
            else:
                models[model] = entry

        sprite_paths.update(sprite_assignment.findall(text))
        font_names.update(font_assignment.findall(text))

    for sprite in sorted(sprite_paths):
        if sprite.startswith("/") or ".." in Path(sprite).parts:
            add_error(errors, f"dashboard sprite path is unsafe: {sprite}")
            continue
        material = root / "materials" / f"{sprite}.vmt"
        if not material.is_file():
            add_error(errors, f"missing literal dashboard material: materials/{sprite}.vmt")

    fonts_path = root / "lua" / "sef" / "dashboard" / "cl_fonts.lua"
    fonts_text = read_text(fonts_path, errors)
    if fonts_text is not None:
        defined_fonts = set(re.findall(r'\bsurface\.CreateFont\s*\(\s*"([^"\r\n]+)"', fonts_text))
        for font in sorted(font_names - defined_fonts):
            add_error(errors, f"vehicle config references an undefined dashboard font: {font}")

    packaged_fonts = list((root / "resource" / "fonts").glob("*.ttf"))
    if not packaged_fonts or any(font.stat().st_size == 0 for font in packaged_fonts):
        add_error(errors, "resource/fonts must contain non-empty TTF files")


def validate(root: Path) -> list[str]:
    errors: list[str] = []
    manifests = validate_loader(root, errors)
    validate_addon_metadata(root, errors)
    validate_vehicle_configs(root, manifests["VehicleConfigFiles"], errors)
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--root",
        type=Path,
        default=Path(__file__).resolve().parents[1],
        help="repository root to validate",
    )
    arguments = parser.parse_args()
    root = arguments.root.resolve()
    errors = validate(root)

    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1

    print("Static validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
