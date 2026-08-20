# Development Guide

## Scope

SEF is an experimental simfphys extension framework. Keep changes small and
data-driven: vehicle files describe a model, while framework modules implement
the reusable behavior.

## Loading and realms

`lua/autorun/sef_init.lua` is the single loader manifest.

- Add shared modules to `SharedFiles`.
- Add server-only modules to `ServerFiles`.
- Add client-only modules to `ClientFiles`.
- Add built-in vehicle registrations to `VehicleConfigFiles`.

The server sends shared, client-only, and vehicle configuration files to
clients. Server-only files remain server-side. Client rendering belongs in
client-only modules. Feature key handling, execution, and animation ticking
belong on the server.

## Add a dashboard

Create `lua/sef/vehicles/<vehicle>.lua`, add it to `VehicleConfigFiles`, and
register its complete configuration once.

```lua
local Formatters = SimfphysExtraFeatures.Formatters

SimfphysExtraFeatures.Registry.Register("models/example/car.mdl", {
    indicators = {},
    text_indicators = {
        {
            getter = Formatters.GetSpeedInUnits,
            pos = Vector(),
            ang = Angle(),
            scale = 0.01,
            font = "DashboardFont",
        },
    },
    features = {},
})
```

Use existing indicator types, conditions, and formatters before introducing a
new one. Do not add per-vehicle rendering code.

## Add a feature

Register a reusable definition in `features/definitions.lua` or a dedicated
shared feature module:

```lua
Features.RegisterDefinition("feature_id", {
    name = "Feature name",
    condition = function(veh, ply, config)
        return true
    end,
    action = function(veh, ply, config)
    end,
})
```

Enable it in the relevant vehicle registry entry:

```lua
features = {
    feature_id = {},
}
```

Air-suspension features use one `air_suspension` entry. The built-in controls
pass a raise or lower direction to the same feature. Configure discrete height
offsets in low-to-high order; the array must contain `0.0`, which preserves the
vehicle's spawned suspension height and is the default starting level.

```lua
features = {
    air_suspension = {
        levels = { -0.4, -0.2, 0.0, 0.1, 0.5 },
    },
}
```

Do not execute a feature from client code. The server maps key presses to
feature IDs in `features/sv_input.lua`, validates them, and executes the action.

## Verify changes

Before committing:

1. Test in singleplayer and multiplayer.
2. Test the affected vehicle and an unsupported vehicle.
3. Test with optional integrations absent.
4. Check the console for Lua errors and repeated warnings.
5. Confirm client-only APIs are not included or called on the server.

Run the dependency-free static validator before opening a pull request:

```powershell
python .\scripts\validate.py
python -m unittest discover -s tests -v
```

It checks the loader manifest and realm list placement, literal vehicle model
registrations, Workshop metadata, dashboard materials, and dashboard font
definitions. It does not replace compiling GLua or testing the game in both
realms.

### GMod-native server checks

The `GMod runtime` workflow runs only from trusted `main` pushes, release tags,
or a maintainer's manual dispatch. It intentionally never runs on pull requests,
because a self-hosted runner executes repository code.

Set up a dedicated self-hosted Windows runner with the custom
`gmod-windows` label and a Garry's Mod dedicated server installation. Install
the dedicated server through SteamCMD as app `4020`, then set the repository
Actions variables `GMOD_SERVER_DIRECTORY` to that installation's absolute path
and `GMOD_RUNTIME_ENABLED` to `true`. Until that second variable is set, the
runtime job is skipped rather than waiting for an unavailable self-hosted
runner.

Run the same check locally with:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\run-gmod-tests.ps1 `
    -ServerDirectory "D:\gmod-dedicated-server"
```

The runner copies the branch's SEF Lua files into a temporary `sef-ci` addon,
compiles every file through GMod's `CompileFile`, loads the server bootstrap,
checks registry synchronization and server-authoritative feature requests, then
removes that temporary addon. It does not validate client dashboard rendering or
test against a particular installed simfphys fork.

### Workshop releases

Create the Workshop item manually once, with its required 512x512 JPEG icon.
The publisher runner's Steam account must own that item. Do not store Steam
credentials in GitHub; `gmpublish.exe` uses the runner's existing Steam session.

Configure a dedicated self-hosted Windows runner with the
`gmod-publisher-windows` label and a Garry's Mod client installation. Create a
protected GitHub environment named `workshop-production` with a required
reviewer, then set these repository Actions variables:

| Variable | Value |
| --- | --- |
| `GMOD_DIRECTORY` | Absolute Garry's Mod client directory containing `bin/gmad.exe` and `bin/gmpublish.exe` |
| `WORKSHOP_ITEM_ID` | Existing Workshop item ID owned by the publisher account |
| `WORKSHOP_PUBLISH_ENABLED` | `true` only after the runner and environment protection are ready |

Pushing a `vMAJOR.MINOR.PATCH` tag pointing to `main` triggers the workflow. It
reruns static validation, builds the GMA, uploads the GMA and checksum as a
GitHub artifact, waits for the `workshop-production` approval, then updates the
existing item with the ASCII change note `Release vMAJOR.MINOR.PATCH`.

The configuration API is not stable yet, so update this document and
`ARCHITECTURE.md` when its contract changes.

## Build a Workshop package

The committed `addon.json` defines the Workshop metadata. Packaging stages only
the addon folders (`lua`, `materials`, and `resource`), so development files
cannot enter the `.gma`.

From PowerShell, run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\package.ps1 `
    -GmodDirectory "D:\Games\steamapps\common\GarrysMod"
```

The script invokes that installation's `bin\gmad.exe` and writes the package
and its SHA-256 checksum to `artifacts/`. It does not publish to the Workshop.
Publishing and its required 512x512 JPEG icon are intentionally handled by the
separate release workflow.
