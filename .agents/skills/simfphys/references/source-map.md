# simfphys source map

Pinned source: [`SpaxscE/simfphys_base` at `8d4b1ad`](https://github.com/SpaxscE/simfphys_base/tree/8d4b1ad11f0330e750aa59d73c008f07ab145e38).
The snapshot contains 45 Lua modules and seven Sandbox tool modules.

| Area | Primary source | Use it for |
| --- | --- | --- |
| Loading and public helpers | `lua/autorun/simfphys_init.lua`, `lua/simfphys/init.lua`, `lua/simfphys/base_functions.lua` | Realm loading, `simfphys.IsCar`, player helpers, spawn helpers, base network messages |
| Vehicle registry templates | `lua/simfphys/base_vehicles.lua`, `lua/autorun/simfphys_extra.lua`, `lua/autorun/simfphys_prewar.lua` | Canonical vehicle and light-table declarations |
| Base public state | `lua/entities/gmod_sent_vehicle_fphysics_base/shared.lua` | NetworkVar accessors, fuel/health helpers, passenger discovery |
| Spawn and construction | `.../spawn.lua` | Seat creation, member initialization, wheel constraints, model attachment requirements |
| Runtime simulation | `.../init.lua`, `.../simfunc.lua`, `.../numpads.lua` | Driver lifecycle, input bindings, engine/transmission, suspension callbacks, lights, Wire integration |
| Client vehicle behavior | `.../cl_init.lua`, `lua/simfphys/client/lighting.lua` | Client RPM/effects/sounds, blink phase, signal fields, light sprites |
| Damage and repair | `.../damage.lua`, `lua/simfphys/server/damage.lua`, `lua/weapons/weapon_simrepair.lua` | Health, destruction, repair, damage hooks |
| Player UX | `lua/simfphys/view.lua`, `lua/simfphys/anim.lua`, `lua/simfphys/client/hud.lua`, `lua/simfphys/client/seatcontrols.lua` | Camera, seat animations, HUD, menu blocking, client controls |
| Optional systems | `lua/entities/gmod_sent_vehicle_fphysics_gaspump*.lua`, `gmod_sent_vehicle_fphysics_wheel.lua`, `gmod_sent_vehicle_fphysics_gib.lua`, `lua/weapons/weapon_sim*.lua`, `lua/effects/simfphys_*.lua` | Fuel pumps, wheel entity internals, destruction effects, repair/remote/filler tools |
| Sandbox tools | `gamemodes/sandbox/entities/weapons/gmod_tool/stools/simfphys*.lua` | Vehicle, suspension, wheel, gear, sound, and duplicator editor behavior |

When a requested capability is not represented by a documented accessor,
search the matching source area before declaring it a base contract. If it only
occurs in a vehicle definition or a client implementation detail, keep it
scoped accordingly.
