# Extension points and integration rules

## Prefer hooks over base edits

The legacy base exposes server-side hooks. Cancellable hooks treat a truthy
return as “base handling stops”; observational hooks do not use their return.

| Purpose | Hook | Behavior |
| --- | --- | --- |
| Vehicle initialized | `simfphysOnSpawn` | Observational |
| Base simulation tick | `simfphysOnTick` | Observational, about every 0.025 seconds |
| Engine start/stop | `simfphysOnEngine` | Cancellable |
| Lock/unlock | `simfphysOnLock` | Cancellable |
| Use interaction | `simfphysUse` | Cancellable |
| Damage intake | `simfphysOnTakeDamage` | Cancellable |
| Physics collision | `simfphysPhysicsCollide` | Cancellable |
| Destroyed/repaired/removed | `simfphysOnDestroyed`, `simfphysOnRepaired`, `simfphysOnDelete` | Observational |
| Fire/smoke | `simfphysOnFire`, `simfphysOnSmoke` | Cancellable |

Use a unique hook identifier and make cancellation intentional. An SEF feature
should normally use its own server action and vehicle registry entry, not a
global base hook. Hooks are suitable when an external event, rather than an
SEF key binding, is the source of the behavior.

## Realm boundaries

- Base physics, driver controls, engine start/stop, locks, damage, fuel, and
  suspension changes are server-owned.
- Base dashboard and lighting visuals run client-side. The turn signal raw
  fields are populated on the client by a net receiver.
- Never make an SEF client renderer the source of truth for feature permission
  or vehicle mutations.
- Never reuse a simfphys net message for unrelated SEF state. Use an SEF-owned
  message with explicit validation if a client request is genuinely required.

## Animation and state

The base uses server-side bodygroups, animations, and some pose parameters for
vehicle operation. Repeated server calls to `ManipulateBoneAngles`,
`ManipulateBonePosition`, or other visual setters can replicate frequently.

For SEF visual-only animation, prefer an authoritative state transition and
client interpolation. Keep server-side continuous mutation only when the
change is physically relevant or networked visibility is specifically needed.
Model bones, bodygroups, skins, and pose parameters must be checked per
vehicle; they are never guaranteed by the base.

## Input coexistence

The base establishes driver bindings only after its driver-state transition.
Use SEF's server input path for an action and validate its conditions there.
Avoid binding features to the same default keys as the base unless concurrent
behavior is intentional and documented.

The base itself uses `PlayerButtonDown` for number-key seat switching and lock
behavior. A second server-side hook can coexist, but it must not assume that
all button events belong to the driver or that an occupied seat is always the
driver seat.

## Source-backed troubleshooting

- A feature works for the driver but not a passenger: compare
  `ply:IsDrivingSimfphys()` with `ply:GetSimfphys()` and decide which is the
  intended rule.
- A dashboard indicator is stale or missing: distinguish generated NetworkVar
  state from client-only lighting fields, then confirm the configured model
  has a light table or vehicle-specific capability.
- A vehicle breaks after a suspension or wheel change: inspect
  `spawn.lua` before changing raw wheel or elastic tables; those are base
  construction internals.
- A source field is absent: do not add a speculative fallback. Tell the user
  which vehicle/addon contract is missing and what additional API would be
  needed.
