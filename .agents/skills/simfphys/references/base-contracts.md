# simfphys base contracts

Source snapshot: [`SpaxscE/simfphys_base` commit
`8d4b1ad`](https://github.com/SpaxscE/simfphys_base/tree/8d4b1ad11f0330e750aa59d73c008f07ab145e38),
dated 2026-05-05. The base version is `500`.

## Vehicle and occupant identity

- [`simfphys.IsCar(ent)`](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/simfphys/base_functions.lua#L65-L71)
  accepts only the exact `gmod_sent_vehicle_fphysics_base` class.
- [`Player:GetSimfphys()`](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/simfphys/base_functions.lua#L84-L112)
  returns `NULL` outside a valid simfphys seat. It checks the seat's direct
  parent, then caches the base entity as `SPHYSBaseEnt` on the seat.
- [`Player:IsDrivingSimfphys()`](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/simfphys/base_functions.lua#L74-L82)
  additionally verifies the occupied seat is `veh:GetDriverSeat()`.
- `veh:GetDriver()` is a networked entity accessor. It may be `NULL`; always
  use `IsValid` when the presence of a driver matters.

Do not walk arbitrary parent chains to find a vehicle. That is broader than
the base helper and can accept unrelated parented entities.

## Networked state

[`SetupDataTables`](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/entities/gmod_sent_vehicle_fphysics_base/shared.lua#L20-L85)
generates getters and setters in both realms. Read generated getters on either
side; make gameplay changes through the server-side setters.

| Area | Generated accessors relevant to SEF |
| --- | --- |
| Occupancy and activity | `GetDriver`, `GetDriverSeat`, `GetActive` |
| Powertrain | `GetFlyWheelRPM`, `GetThrottle`, `GetGear`, `GetClutch`, `GetIsCruiseModeOn` |
| Lighting and braking | `GetLightsEnabled`, `GetLampsEnabled`, `GetFogLightsEnabled`, `GetEMSEnabled`, `GetIsBraking`, `GetHandBrakeEnabled` |
| Suspension | `GetFrontSuspensionHeight`, `SetFrontSuspensionHeight`, `GetRearSuspensionHeight`, `SetRearSuspensionHeight` |
| Vehicle tuning | `GetLimitRPM`, `GetIdleRPM`, `GetPowerBandStart`, `GetPowerBandEnd`, `GetMaxTorque`, `GetDifferentialGear` |

Fuel and damage use shared NW values rather than datatables. The base exposes
`GetFuel`, `GetMaxFuel`, `GetFuelUse`, `GetFuelType`, `GetCurHealth`, and
`GetMaxHealth`; their server setters are implemented by the base entity.

`GetGear()` values in this base are `1` for reverse, `2` for neutral, and `3+`
for forward ratios. “Park” is an addon-level interpretation of neutral plus
handbrake, not a base gear value.

## Controls and authority

The base attaches `numpad` handlers for the active driver in
[`SetupControls`](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/entities/gmod_sent_vehicle_fphysics_base/init.lua#L591-L711).
Those handlers drive engine, gear, horn, lights, cruise, fog lights, lock, and
vehicle movement. Their bindings are client ConVars, not fixed server keys.

`PlayerButtonDown` is already handled server-side for lock and seat switching
in [`server/seatcontrols.lua`](https://github.com/SpaxscE/simfphys_base/blob/8d4b1ad11f0330e750aa59d73c008f07ab145e38/lua/simfphys/server/seatcontrols.lua#L23-L74).
A server hook is therefore a valid path for an authoritative SEF action, but
it must still validate the player, the resolved vehicle, and any driver-only
requirement.

Default bindings are horn `H`, lights `F`, fog lights `V`, cruise `R`, and
engine toggle `I`. A custom feature using one of these keys can run alongside
the base handler.

## Lighting, turn signals, and dashboards

The lighting booleans above are the portable state for dashboards. The
base applies them server-side through its numpad handlers.

Turn signal direction and its blink phase are different:

- The server stores the requested mode in raw `TSMode` through
  `SetTSInternal`; it broadcasts `simfphys_turnsignal` after validating the
  driver and vehicle.
- The client receiver maintains `ent.signal_left` and `ent.signal_right`.
- The client entity calculates `ent.flashnum`, exposed by `GetFlasher()`.

Therefore `signal_left`, `signal_right`, `flashnum`, and `GetFlasher()` are
valid only for client dashboard rendering against this pinned base. They are
not server-authoritative accessors and must not control server gameplay.

## Suspension and engine state

Front and rear height are float datatable variables with editor limits `-1..1`.
The base's server-side change callbacks rebuild spring lengths. Clamp each
value independently and only write when it changes. For non-custom wheels,
positive height is forced back to zero by the base; `HasAirSuspension` is not
a base field.

`EngineActive()` and `GetEngineRPM()` are server-side entity helpers.
`GetRPM()` is implemented in both realms, so client dashboards should use it
or the networked `GetFlyWheelRPM()` after confirming the target is a valid base
vehicle. Starting an engine is constrained by fuel, health, water, and the
cancellable `simfphysOnEngine` hook, so call `StartEngine` and `StopEngine`
rather than editing engine internals.
