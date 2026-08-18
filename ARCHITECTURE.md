# Architecture

## Overview

Simfphys Extra Features (SEF) extends simfphys vehicles through per-model data
registered with `SimfphysExtraFeatures.Registry`. The framework owns rendering,
state checks, feature execution, and external providers; vehicle files describe
only the model-specific configuration.

## Runtime and realms

`lua/autorun/sef_init.lua` is the entry point. It keeps manifests for shared,
server-only, and client-only modules, plus vehicle configuration files.

- Shared modules are sent to clients and included in both realms.
- Server-only modules handle authoritative feature input.
- Dashboard fonts, the vehicle cache, and rendering are client-only.
- The server handles feature key presses, resolves the player's simfphys
  vehicle, executes the action, and advances active feature animations.

The server and client have separate Lua states. Configuration is loaded in both
states, but feature state and execution are server-authoritative.

## Module layout

```text
lua/
|-- autorun/sef_init.lua
`-- sef/
    |-- registry.lua
    |-- vehicle_conditions.lua
    |-- helpers.lua
    |-- formatters.lua
    |-- dashboard/
    |   |-- indicator_types.lua
    |   |-- cl_fonts.lua
    |   |-- cl_vehicle_cache.lua
    |   `-- cl_renderer.lua
    |-- features/
    |   |-- core.lua
    |   |-- definitions.lua
    |   `-- sv_input.lua
    |-- providers/
    |   |-- environment.lua
    |   `-- speed.lua
    `-- vehicles/
        `-- <vehicle>.lua
```

## Vehicle registry

`Registry.Register(model, data)` is the only public registration path for a
vehicle. It stores dashboard data and forwards feature configuration to the
feature system.

```lua
SimfphysExtraFeatures.Registry.Register("models/example/car.mdl", {
    indicators = {},
    text_indicators = {},
    features = {},
})
```

The registry synchronizes feature configuration after the feature module loads,
so a vehicle registration is retained if it occurs early.

## Dashboard system

The client renderer retrieves a vehicle's registry entry by model and renders
its `indicators` and `text_indicators` while the vehicle is within the configured
render distance.

Indicator entries contain a material path, position, angle, scale, a predefined
`type`, and optionally a custom `condition`. When both are present, the renderer
requires both checks to pass.

```lua
{
    sprite = "husky_dashboard/check",
    type = "check_engine",
    pos = Vector(),
    ang = Angle(),
    scale = 0.005,
}
```

Text entries contain a getter and drawing settings. Getters reuse the formatter
and provider APIs instead of performing rendering themselves.

## Conditions, formatters, and providers

`vehicle_conditions.lua` supplies reusable simfphys checks such as
`Conditions.LowFuel`, `Conditions.CheckEngine`, and the `Conditions.Gears`
helpers. `helpers.lua` composes conditions with `And`, `Or`, and `Not`.

`formatters.lua` turns vehicle and environment state into displayable values.
Environment values come from
`SimfphysExtraFeatures.Providers.Environment.GetProvider()`, which selects the
StormFox provider when available and otherwise uses a default provider.

## Feature system

Reusable actions are registered once:

```lua
Features.RegisterDefinition("trunk", {
    name = "Toggle Trunk",
    condition = function(veh, ply)
        return veh:GetDriver() == ply
    end,
    action = function(veh, ply, config)
    end,
})
```

Vehicles enable and configure those definitions in their registry entry:

```lua
features = {
    trunk = {
        type = "animated",
        duration = 1.25,
        modifiers = {},
    },
}
```

The server maps button codes to feature IDs and applies the definition's
condition against the server-side vehicle before performing the action.

## Boundaries

Vehicle configuration files should contain model registration, dashboard layout,
and feature configuration. They should not contain rendering loops, input hooks,
or server authority checks.

The public API is still unstable. Third-party integrations should register
vehicles through `Registry.Register` and avoid modifying SEF internal tables.
