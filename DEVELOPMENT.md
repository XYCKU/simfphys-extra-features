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

Do not execute a feature from client code. The server maps key presses to
feature IDs in `features/sv_input.lua`, validates them, and executes the action.

## Verify changes

Before committing:

1. Test in singleplayer and multiplayer.
2. Test the affected vehicle and an unsupported vehicle.
3. Test with optional integrations absent.
4. Check the console for Lua errors and repeated warnings.
5. Confirm client-only APIs are not included or called on the server.

The configuration API is not stable yet, so update this document and
`ARCHITECTURE.md` when its contract changes.
