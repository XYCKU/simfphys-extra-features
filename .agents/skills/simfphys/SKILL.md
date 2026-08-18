---
name: simfphys
description: Develop and review legacy simfphys vehicle integrations for Simfphys Extra Features, using verified base contracts for state, controls, vehicle definitions, lifecycle hooks, and client dashboards. Use only for gmod_sent_vehicle_fphysics_base, not LVS.
---

# Legacy simfphys integration

Use this skill for the legacy `gmod_sent_vehicle_fphysics_base` vehicle base.
It is not applicable to LVS or another simfphys fork until their source has
been compared. Pair it with a GLua skill when engine API signatures or realm
rules are needed.

The source reference is
[`SpaxscE/simfphys_base`](https://github.com/SpaxscE/simfphys_base) at commit
`8d4b1ad11f0330e750aa59d73c008f07ab145e38` (`simfphys.VERSION = 500`).
Validate an installed server's fork and revision before relying on a
source-pinned detail.

## Workflow

1. Confirm the target is a valid legacy simfphys base vehicle with
   `simfphys.IsCar` or `ply:GetSimfphys()`.
2. Read the reference that matches the change:
   - [base contracts](references/base-contracts.md) for occupied vehicles,
     networked state, controls, lights, suspension, fuel, health, or gears.
   - [vehicle definitions](references/vehicle-definitions.md) when porting or
     registering a simfphys vehicle or checking model-level capabilities.
   - [extension points](references/extension-points.md) for lifecycle hooks,
     input conflicts, dashboards, or new SEF features.
   - [source map](references/source-map.md) when the relevant subsystem is not
     covered above.
3. Use generated getters and setters or documented helpers. Treat raw fields as
   implementation details unless the relevant reference explicitly scopes them
   to a realm and source revision.
4. Keep actions, permission checks, and physical mutations on the server.
   Keep SEF dashboard rendering and client-only signal state on the client.
5. For a vehicle-specific capability, verify the vehicle addon's definition or
   model before enabling it in `Registry.Register`; a field existing on one
   vehicle is not a simfphys base API.

## SEF integration boundaries

- Resolve the target once through `ply:GetSimfphys()` in server-side feature
  execution. For driver-only features, compare `veh:GetDriver()` with the
  player or use `ply:IsDrivingSimfphys()`.
- Put reusable behavior in SEF feature definitions and model capabilities in
  the vehicle registry. Do not fork simfphys base entity code for a model-only
  feature.
- Base bindings already own horn (`H` by default), lights (`F`), fog lights
  (`V`), cruise (`R`), and engine start (`I`). Avoid or deliberately document
  collisions with feature bindings.
- Vehicle fields such as `trunk`, `hood`, custom bone names, bodygroups, skins,
  and pose parameters are vehicle-addon contracts. Require an explicit
  per-model configuration or guarded condition before using them.
- Continuous visual animation has a networking cost when changed server-side.
  Prefer compact authoritative state with client interpolation unless physical
  state must be synchronized every update.
