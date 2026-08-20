import importlib.util
import shutil
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("validate", ROOT / "scripts" / "validate.py")
VALIDATE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(VALIDATE)


class ValidateTests(unittest.TestCase):
    def make_fixture(self) -> tempfile.TemporaryDirectory:
        temporary_directory = tempfile.TemporaryDirectory()
        fixture = Path(temporary_directory.name)

        for name in ("lua", "materials", "resource"):
            shutil.copytree(ROOT / name, fixture / name)
        shutil.copy2(ROOT / "addon.json", fixture / "addon.json")

        return temporary_directory

    def test_current_repository_passes(self) -> None:
        self.assertEqual([], VALIDATE.validate(ROOT))

    def test_unlisted_loader_module_fails(self) -> None:
        with self.make_fixture() as temporary_directory:
            fixture = Path(temporary_directory)
            loader = fixture / "lua" / "autorun" / "sef_init.lua"
            loader.write_text(
                loader.read_text(encoding="utf-8").replace('    "sef/registry.lua",\n', "", 1),
                encoding="utf-8",
            )

            errors = VALIDATE.validate(fixture)

        self.assertTrue(any("SEF Lua module is not listed by the loader" in error for error in errors))

    def test_client_module_in_shared_list_fails(self) -> None:
        with self.make_fixture() as temporary_directory:
            fixture = Path(temporary_directory)
            loader = fixture / "lua" / "autorun" / "sef_init.lua"
            loader.write_text(
                loader.read_text(encoding="utf-8").replace(
                    "local SharedFiles = {\n",
                    'local SharedFiles = {\n    "sef/dashboard/cl_renderer.lua",\n',
                    1,
                ),
                encoding="utf-8",
            )

            errors = VALIDATE.validate(fixture)

        self.assertTrue(any("loader lists 'sef/dashboard/cl_renderer.lua' more than once" in error for error in errors))
        self.assertTrue(any("shared loader entry has a realm-specific prefix" in error for error in errors))

    def test_invalid_vehicle_model_fails(self) -> None:
        with self.make_fixture() as temporary_directory:
            fixture = Path(temporary_directory)
            vehicle = fixture / "lua" / "sef" / "vehicles" / "audi_q7.lua"
            vehicle.write_text(
                vehicle.read_text(encoding="utf-8").replace(
                    '"models/dk_cars/audi/q7/ak_47.mdl"',
                    '"models/invalid.txt"',
                    1,
                ),
                encoding="utf-8",
            )

            errors = VALIDATE.validate(fixture)

        self.assertTrue(any("vehicle config has an invalid model path" in error for error in errors))

    def test_missing_material_fails(self) -> None:
        with self.make_fixture() as temporary_directory:
            fixture = Path(temporary_directory)
            vehicle = fixture / "lua" / "sef" / "vehicles" / "audi_q7.lua"
            vehicle.write_text(
                vehicle.read_text(encoding="utf-8").replace(
                    'sprite = "husky_dashboard/turn_signal"',
                    'sprite = "husky_dashboard/not_present"',
                    1,
                ),
                encoding="utf-8",
            )

            errors = VALIDATE.validate(fixture)

        self.assertTrue(any("missing literal dashboard material" in error for error in errors))
