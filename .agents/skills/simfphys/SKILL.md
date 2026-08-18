---
name: simfphys
description: Develop and review integrations with the legacy simfphys vehicle base, including player vehicle resolution, seats, controls, datatable state, suspension, and vehicle-specific extensions. Use for legacy gmod_sent_vehicle_fphysics_base code; do not assume the same API for LVS vehicles.
---

# Legacy simfphys integration

Use this skill with the `glua` skill. The GLua references define engine APIs and
realms; this skill defines simfphys-specific contracts.

The project reference is
[`SpaxscE/simfphys_base`](https://github.com/SpaxscE/simfphys_base) at commit
`8d4b1ad11f0330e750aa59d73c008f07ab145e38` (`simfphys.VERSION = 500`). If the
installed server uses another fork or version, verify changed behavior against
that source before relying on this reference.

## Workflow

1. Decide the realm using the GLua references.
2. Read [references/base-contracts.md](references/base-contracts.md) for the
   simfphys subsystem being changed.
3. Prefer public simfphys helpers and datatable accessors over reconstructing
   entity relationships or reading internal fields.
4. Treat fields absent from the base source as vehicle-addon extensions. Guard
   them or define an explicit per-vehicle adapter; do not present them as base
   APIs.
5. Keep physical state and permission checks server-authoritative. Consider the
   bandwidth cost before calling networked visual setters every server tick.

## Essential rules

- Resolve an occupied legacy simfphys vehicle with `ply:GetSimfphys()` and
  validate the result. The helper already checks and caches the seat's parent.
- Use `ply:IsDrivingSimfphys()` or compare `veh:GetDriver()` with the player
  when driver-only behavior is required.
- The base entity class is `gmod_sent_vehicle_fphysics_base`.
- simfphys itself handles `PlayerButtonDown` server-side, so a server hook is a
  valid input path. Avoid a client net relay when the server hook supplies the
  same button event.
- Suspension height setters are server-authoritative datatable setters. Clamp
  front and rear values independently and do not rely on `HasAirSuspension`;
  that field is not part of the base.
- `hood` and other model- or addon-specific raw fields are not simfphys base
  contracts unless the source map says otherwise.
