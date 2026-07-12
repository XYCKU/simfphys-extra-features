# Architecture

## Overview

`SimfphysExtraFeatures` (SEF) is a modular Garry's Mod addon designed to provide reusable vehicle features and dashboard systems for `simfphys` vehicles.

The main goal is to separate:

* vehicle-specific configuration
* rendering logic
* state detection
* reusable formatters
* interactive vehicle features

The addon should allow other vehicle addons to register their own dashboards and features without modifying SEF source code.

---

## Core Concepts

### Registry-Based Architecture

SEF uses registries as the main extension mechanism.

External code does not directly modify internal tables. Instead, it registers data through public APIs.

Example:

```lua
SimfphysExtraFeatures.Registry.Register(
    "models/example/car.mdl",
    dashboardData
)
```

The registry stores:

* dashboard indicators
* text indicators
* vehicle feature definitions

---

## Module Structure

Current structure:

```lua
lua/
└── sef/
    ├── init.lua
    │
    ├── registry/
    │   └── dashboard.lua
    │
    ├── dashboard/
    │   ├── cl_render.lua
    │   ├── indicators.lua
    │   └── text.lua
    │
    ├── conditions/
    │   ├── gears.lua
    │   └── vehicle.lua
    │
    ├── formatters/
    │   ├── speed.lua
    │   ├── gears.lua
    │   ├── temperature.lua
    │   └── time.lua
    │
    ├── features/
    │   ├── registry.lua
    │   ├── execution.lua
    │   └── input.lua
    │
    └── weather/
        ├── provider.lua
        ├── stormfox.lua
        └── default.lua
```

---

## Dashboard System

### Purpose

The dashboard system renders vehicle instrument clusters.

A dashboard consists of:

* sprite indicators
* text indicators

Example:

```lua
{
    indicators = {},
    text_indicators = {}
}
```

---

## Indicators

Indicators represent visual icons:

Examples:

* turn signals
* headlights
* handbrake
* engine warning
* fuel warning

Each indicator contains:

```lua
{
    sprite = "husky_dashboard/check",
    type = "check_engine",
    pos = Vector(),
    ang = Angle(),
    scale = 0.005
}
```

The renderer decides when an indicator is visible based on its type.

Custom conditions should only be used for vehicle-specific behavior.

---

## Text Indicators

Text indicators render dynamic text.

Example:

```lua
{
    getter = Formatters.GetSpeedInUnits,
    pos = Vector(),
    ang = Angle(),
    font = "DashboardFont",
    scale = 0.01
}
```

The getter is responsible only for calculating the displayed value.

Examples:

* current speed
* gear
* temperature
* time

Vehicle files should reuse existing getters whenever possible.

---

## Conditions

Conditions are reusable state checks.

Examples:

```lua
Conditions.Gears.IsDrive
Conditions.Gears.IsReverse
Conditions.Vehicle.HasFuel
```

Conditions are used when the same logic is required in multiple places.

Example:

```lua
condition = Conditions.Gears.IsDrive
```

Complex conditions are composed using helpers:

```lua
And()
Or()
Not()
```

Example:

```lua
condition = And(
    Conditions.Gears.IsNeutral,
    Not(Conditions.Gears.IsParking)
)
```

---

## Formatters

Formatters convert vehicle state into display values.

They should not contain rendering code.

Example:

```lua
Formatters.GetSpeedInUnits(vehicle)
```

returns:

```text
120
```

while:

```lua
Formatters.GetSpeedUnits(vehicle)
```

returns:

```text
km/h
```

---

## Weather System

Weather-dependent values are abstracted through providers.

The dashboard should not directly depend on specific weather addons.

Example:

```lua
Weather.GetProvider()
```

returns a provider implementing:

```lua
provider.GetTemperature()
provider.GetTime()
```

Available providers:

```text
StormFoxProvider
DefaultProvider
```

Fallback behavior:

* use weather addon values if available
* otherwise use default values

---

## Features System

Features are interactive vehicle actions.

Examples:

* open trunk
* open hood
* raise suspension
* lower suspension

A feature consists of:

```lua
{
    name = "Toggle Trunk",

    condition = function(veh, ply)
        return true
    end,

    action = function(veh, ply)

    end
}
```

---

## Feature Registration

Reusable feature definitions are registered globally:

```lua
Features.RegisterDefinition("trunk", {
    name = "Toggle Trunk",
    action = function(veh)
        veh.trunk = math.abs(1 - veh.trunk)
    end
})
```

The vehicle registry enables and configures the definitions it supports:

```lua
SimfphysExtraFeatures.Registry.Register("models/example/car.mdl", {
    features = {
        trunk = {
            type = "animated",
            modifiers = {}
        }
    }
})
```

---

## Input System

Input handling is separated from feature logic.

Flow:

```text
Keyboard Input
      |
      v
Client Input Manager
      |
      v
Server Feature Request Validation
      |
      v
Feature Registry
      |
      v
Feature Execution
      |
      v
Vehicle Action
```

This allows:

* customizable key bindings
* menu configuration
* different control schemes

---

## Vehicle Configuration

Vehicle-specific files should only describe data.

Example:

```text
vehicles/
├── bmw_m8.lua
├── chevrolet_zr2.lua
└── audi_q7.lua
```

A vehicle file should contain:

* model registration
* dashboard positions
* enabled features

It should not contain:

* rendering logic
* input handling
* state calculations

---

## Design Principles

### Data Over Code

Prefer configuration:

```lua
{
    type = "handbrake"
}
```

over custom logic:

```lua
if vehicle:GetHandBrakeEnabled() then
```

---

### Reuse Existing Logic

Before creating a new:

* getter
* condition
* formatter

check whether existing functionality can be reused.

---

### Keep Modules Independent

Dashboard rendering should not know about:

* key bindings
* weather implementation
* vehicle addons

Features should not know about:

* dashboard rendering
* fonts
* sprites

---

## Current Development Goals

Priority order:

1. Finish dashboard architecture
2. Stabilize indicator types
3. Stabilize formatter API
4. Finish feature system
5. Add key binding menu
6. Prepare external addon integration

---

## Current Non-Goals

Not implemented yet:

* third-party addon documentation
* public API stability guarantees
* workshop-facing SDK
* automatic dashboard discovery

These should be designed only after the internal architecture becomes stable.
