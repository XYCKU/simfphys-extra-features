# Development Guide

## Overview

This document describes the current development workflow for Simfphys Extra Features.

The project is currently under active development. The architecture and APIs may change. This file describes the intended way to work with the codebase, not a final public API contract.

## Development Goals

The main goals of development are:

* Keep the core system independent from individual vehicle addons.
* Allow third-party vehicle addons to register their own dashboard configurations.
* Provide reusable systems for:

  * dashboard indicators
  * text displays
  * vehicle features
  * conditions
  * formatters
  * external integrations

The project should provide infrastructure, while vehicle-specific content should remain declarative.

## Development Principles

### Prefer data-driven configuration

Vehicle dashboards should be described using registry data instead of hardcoded rendering logic.

Preferred:

```lua
SimfphysExtraFeatures.Registry.Register("models/example/car.mdl", {
    indicators = {},
    text_indicators = {}
})
```

Avoid:

```lua
if model == "models/example/car.mdl" then
    drawSomething()
end
```

The rendering system should know how to process generic definitions.

## Code Organization

Expected structure:

```text
lua/
├── sef/
│   ├── init.lua
│   ├── registry/
│   ├── dashboard/
│   ├── features/
│   ├── conditions/
│   ├── formatters/
│   └── integrations/
```

### Registry

Responsible for storing external definitions.

Examples:

* vehicle dashboard layouts
* feature definitions
* providers

The registry should not contain rendering logic.

### Dashboard

Responsible for:

* rendering sprites
* rendering text indicators
* updating cached values
* handling delays

Dashboard code should consume registry data.

### Conditions

Reusable predicates used to decide whether something should be displayed.

Examples:

```lua
Conditions.IsHandbrakeEnabled
Conditions.IsLowFuel
Conditions.Gears.IsDrive
```

Conditions should be small and composable.

Example:

```lua
local function And(...)
    local conditions = {...}

    return function(...)
        for _, condition in ipairs(conditions) do
            if not condition(...) then
                return false
            end
        end

        return true
    end
end
```

## Formatters

Formatters convert vehicle state into display values.

Examples:

```lua
Formatters.GetSpeedInUnits
Formatters.GetSpeedUnits
Formatters.GetAutomaticGearText
Formatters.GetOutsideTemperature
```

A formatter should:

* accept a vehicle
* return displayable data
* avoid drawing logic

Bad:

```lua
function DrawSpeedometer(vehicle)
end
```

Good:

```lua
function Formatters.GetSpeedInUnits(vehicle)
    return speed
end
```

## Adding a New Dashboard

A new vehicle dashboard should be added by creating a registration file.

Example:

```lua
local Formatters = SimfphysExtraFeatures.Formatters

local data = {
    indicators = {},
    text_indicators = {}
}

SimfphysExtraFeatures.Registry.Register(
    "models/example/car.mdl",
    data
)
```

The dashboard definition should only describe:

* position
* rotation
* scale
* sprite
* formatter
* condition

Do not add custom rendering code unless the generic renderer cannot support the required behavior.

## Adding a New Indicator Type

Before adding a new type, check if an existing system can represent it.

Preferred approach:

1. Add a reusable condition.
2. Add a reusable sprite type.
3. Add configuration entries.

Avoid creating vehicle-specific code.

Example:

Instead of:

```lua
if vehicle:GetSomethingSpecial() then
    DrawCustomIcon()
end
```

Create:

```lua
Conditions.IsSomethingSpecial
```

and use it in configuration.

## Adding Vehicle Features

Features are actions available to the player.

Examples:

* open trunk
* open hood
* raise suspension
* lower suspension

A feature should define:

```lua
Features.RegisterDefinition("feature_id", {
    name = "Feature name",

    condition = function(vehicle, player)
        return true
    end,

    action = function(vehicle, player)
    end
})
```

Enable a definition in the vehicle's registry entry:

```lua
SimfphysExtraFeatures.Registry.Register("models/example/car.mdl", {
    features = {
        feature_id = {}
    }
})
```

The feature system should handle:

* input binding
* permission checks
* execution

The feature itself should only implement the action.

## External Integrations

External addons should be detected through providers.

Example:

```lua
Weather.GetProvider()
```

The caller should not directly check:

```lua
if StormFox then
end
```

Instead:

```lua
local provider = Weather.GetProvider()
provider.GetTemperature()
```

This keeps integrations isolated.

## Testing Changes

Before committing changes:

1. Test in singleplayer.
2. Test in multiplayer.
3. Test with missing optional addons.
4. Test with multiple vehicles.
5. Check console for errors.

Important cases:

* missing registry entry
* missing formatter
* invalid vehicle entity
* missing external dependency

## Current Development Status

The project is still WIP.

Not implemented or not finalized:

* public third-party addon API
* final documentation for external developers
* compatibility guarantees
* stable configuration format

Internal APIs may change during development.
