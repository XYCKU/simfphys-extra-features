# Vehicle definition contracts

Use this reference when porting a legacy vehicle, checking whether a model
supports an SEF feature, or adding a vehicle to the simfphys spawn list.

## Registration shape

The base's examples register a vehicle through:

```lua
list.Set("simfphys_vehicles", "unique_spawn_id", {
    Name = "Display name",
    Model = "models/example.mdl",
    Class = "gmod_sent_vehicle_fphysics_base",
    Category = "Category",
    Members = {
        -- model and driving configuration
    },
})
```

[`simfphys.SpawnVehicle`](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/simfphys/base_functions.lua#L239-L379)
always creates `gmod_sent_vehicle_fphysics_base`, then merges `Members` onto
the entity before initialization. The `Class` value in a vehicle list entry is
not a mechanism for selecting a custom entity subclass.

When SEF only adds features or dashboards, do not register or mutate the
vehicle list. Use the base vehicle's model path as the key for
`Registry.Register` and keep the model-specific capability in its SEF config.

## Members are configuration, not a portable API

The base relies on `Members` for physical and model data such as:

- mass, engine RPM/torque values, gearing, grip, brakes, and wheel power bias;
- `LightsTable`, sounds, fuel position/type/tank size, health, and exhausts;
- driver view, passenger seats, attachments, bodygroups, and model color;
- wheel attachment layout or complete `CustomWheels` configuration.

Use an existing upstream vehicle definition as a template when adding a
vehicle. Required model assets and attachment names are validated at spawn;
guessed fields can yield a vehicle that spawns incorrectly or removes itself.

For standard wheels, the model must provide the expected wheel attachments
(`wheel_fl`, `wheel_fr`, `wheel_rl`, `wheel_rr`) and pose parameters. For
`CustomWheels`, the wheel model, four position vectors, suspension values, and
wheel sizing must be complete; the base builds the wheel entities and
constraints from those values.

## Lifecycle callbacks supplied by Members

Vehicle `Members` may supply these server-side callbacks, which replace the
empty entity defaults:

- `OnSpawn(ent)` after wheel and suspension setup;
- `OnTick(ent)` before each base simulation tick;
- `OnDelete(ent)` during removal;
- `OnDestroyed(ent)` when the vehicle is destroyed;
- `OnRepaired(ent)` when repaired.

Use them only for behavior owned by that vehicle definition. They should not
contain SEF-wide input routing, dashboard rendering, or repeated expensive
work. A vehicle list entry cannot add new datatables after the base entity's
`SetupDataTables` phase; use SEF-owned state or a dedicated entity design when
new replicated state is required.

## Model-specific SEF features

Fields such as `hood`, `trunk`, custom bodygroup indices, bone names, and pose
parameter names are normally added by a vehicle addon, not by simfphys. Before
enabling an SEF feature that reads or writes one:

1. inspect the vehicle's `Members` or its own entity code;
2. confirm the field exists at runtime and in the correct realm;
3. record the requirement in that model's SEF registry entry;
4. keep the feature unavailable for models that do not provide it.

Do not introduce a generic “supports feature” flag unless the vehicle source
actually exposes one. Capability is evidence from the model/addon, not an
inference from the simfphys base class.
