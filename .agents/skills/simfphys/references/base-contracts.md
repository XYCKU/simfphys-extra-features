# simfphys base contracts

Source snapshot: `SpaxscE/simfphys_base` commit
`8d4b1ad11f0330e750aa59d73c008f07ab145e38`, dated 2026-05-05.

## Player and seat relationships

- [`Player:GetSimfphys()`](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/simfphys/base_functions.lua#L84-L110)
  returns `NULL` outside a valid simfphys seat. It checks the seat's direct
  parent with `simfphys.IsCar`, then caches the base entity on the seat as
  `SPHYSBaseEnt`.
- [`Player:IsDrivingSimfphys()`](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/simfphys/base_functions.lua#L74-L82)
  additionally verifies that the occupied pod is `veh:GetDriverSeat()`.
- The [driver seat](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/entities/gmod_sent_vehicle_fphysics_base/spawn.lua#L167-L188)
  and [passenger seats](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/entities/gmod_sent_vehicle_fphysics_base/spawn.lua#L221-L233)
  are parented directly to the base vehicle.

Do not add arbitrary parent-chain traversal around `GetSimfphys()`. It is less
strict than the base helper and can accidentally accept unrelated parented
entities.

## Vehicle identity and loading

- [`simfphys.IsCar(ent)`](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/simfphys/base_functions.lua#L65-L71)
  validates the exact lowercase class name
  `gmod_sent_vehicle_fphysics_base`.
- [`simfphys/init.lua`](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/simfphys/init.lua)
  includes `base_functions.lua` on both server and client, so the player helper
  methods are shared after simfphys initialization.

## Input and authority

The base's [seat control handler](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/simfphys/server/seatcontrols.lua#L23-L72)
uses `PlayerButtonDown` on the server and resolves the vehicle through
`ply:GetSimfphys()`. Follow the same pattern for authoritative feature actions.

The default client control configuration uses `KEY_H` for horn. A custom `H`
feature can execute at the same time as the horn, so choose or expose a separate
binding when that conflict is undesirable.

## Networked vehicle state

The base entity defines shared datatable accessors in
[`SetupDataTables`](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/entities/gmod_sent_vehicle_fphysics_base/shared.lua#L16-L78),
including driver, gear, lights, handbrake, cruise mode, and front/rear suspension
height. Read these through their generated getters. Perform gameplay mutations
through server-side setters.

Fuel and health getters such as `GetFuel`, `GetMaxFuel`, `GetCurHealth`, and
`GetMaxHealth` are defined in the same shared entity source below the datatable
setup.

`signal_left`, `signal_right`, and `flashnum` are client-side implementation
fields maintained by the pinned base's lighting and entity code. They are usable
for client dashboard rendering against this version, but they are not networked
datatable accessors and should not be read server-side.

## Suspension

- Front and rear height are float datatable variables with editor bounds
  `-1..1`.
- Server-side change notifications update the physical spring lengths in
  [`OnFrontSuspensionHeightChanged`](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/entities/gmod_sent_vehicle_fphysics_base/init.lua#L1167-L1203)
  and
  [`OnRearSuspensionHeightChanged`](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/entities/gmod_sent_vehicle_fphysics_base/init.lua#L1205-L1241).
- Positive values are forced back to zero when `CustomWheels` is false.
- `HasAirSuspension` does not occur in this base source. If a vehicle addon
  defines it, it is an addon-specific extension rather than a portable feature
  check.

## Visual animation performance

`Entity:ManipulateBoneAngles` can network server-side changes, but repeated
server calls generate network traffic. For continuously animated visual-only
features, prefer networking compact authoritative state and interpolating on
clients. Keep server-side per-tick manipulation only when its bandwidth and
visibility behavior have been deliberately accepted.

Bodygroups, skins, pose parameters, raw fields such as `hood`, and bone names
are model or vehicle-addon contracts. Validate them against the specific vehicle
source or configuration rather than the simfphys base.
