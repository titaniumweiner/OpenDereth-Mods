# Aquafir Creature Variants

Aquafir Creature Variants is a runtime-only OpenDereth server mod that gives ordinary monsters one or more randomly selected combat variants. It is a reviewed OpenDereth adaptation of the creature concepts in [Aquafir's ACE.BaseMod samples](https://github.com/aquafir/ACE.BaseMod/tree/41c2728fc0e4fb96d06b4e7949ca369ed5be9621/Samples/Expansion/Creatures), pinned to upstream commit `41c2728fc0e4fb96d06b4e7949ca369ed5be9621`.

The port does not replace creature weenies or write variant state to the world or character databases. Variants exist only on currently spawned creatures. Disabling the mod and restarting the server restores normal creature behavior and names.

> [!WARNING]
> This is a Preview combat mod. Its default 50% assignment and stacking chances are intentionally high so the behavior is easy to find during testing. Back up `%LOCALAPPDATA%\OpenDereth` and reduce those values for a long-term playthrough.

## Installation

1. Download `opendereth.aquafir-creature-variants-1.2.0-sp1.zip` and its matching `.zip.sha256` file from the OpenDereth-Mods release.
2. Keep both files together without renaming them.
3. Stop the Asheron's Call client and local ACE server.
4. Open **OpenDereth → Server Mods → Import a Mod ZIP...** and select the ZIP.
5. Enable the mod and restart the server.

No SQL import, custom weenie import, DAT modification, ThwargLauncher, or separate mod loader is required. The package must be used with the OpenDereth/ACE version for which it was built.

## How random assignment works

The default test profile uses:

```json
{
  "AssignmentChance": 0.50,
  "AllowVariantStacking": true,
  "AdditionalVariantChance": 0.50,
  "MaximumVariantsPerCreature": 3
}
```

For each eligible creature:

1. `AssignmentChance` decides whether the creature receives any variant. The default is 50%.
2. The first variant is selected from `TraitWeights`.
3. When stacking is enabled, `AdditionalVariantChance` is rolled after every selection.
4. Every successful additional roll selects another weighted variant that is not already present.
5. Selection stops after a failed additional roll, when all weighted variants are exhausted, or at `MaximumVariantsPerCreature`.

With both chances at 50% and the cap at three, approximately 50% of eligible creatures receive at least one variant, 25% receive at least two, and 12.5% receive three. Variants never repeat on the same creature.

The default weights make `Boss`, `Puppeteer`, and `Horde` less common than ordinary variants. A weight of `0.0` removes that variant from random selection without disabling the rest of the mod.

## Eligible creatures

Random assignment applies only to ordinary, attackable ACE `Creature` instances within the configured level range. The port intentionally excludes:

- players;
- NPCs and vendors;
- player pets and combat pets;
- specialized ACE creature subclasses;
- WCIDs in `ExcludedWeenieClassIds`;
- creatures outside `MinimumLevel` through `MaximumLevel`; and
- creatures not in `AllowedWeenieClassIds` when that allow list is non-empty.

`ForcedTraitsByWeenieClassId` assigns exactly one specified variant to a WCID. Forced entries bypass the random assignment and stacking rolls but still respect the enabled state, level range, allow list, and exclusion list.

## Variant reference

### Accurate — `Accurate`

Accurate creatures have a flat chance to make an attack unavoidable by setting that attack's evade chance to zero. The default `AccurateAutoHitChance` is 25%. This does not permanently lower the player's defense skill.

### Berserker — `Raging`

When health first falls to or below `BerserkerHealthThreshold`—60% by default—the creature becomes enraged for the rest of that spawn. Its six primary attributes receive the runtime `BerserkerAttributeMultiplier`, which defaults to 1.30. Healing above the threshold does not clear the enraged state.

### Comboer — `Frenetic`

Comboer counts consecutive successful hits against a player. Every `ComboHitThreshold` hits, five by default, the triggering hit is multiplied by `ComboDamageMultiplier`, 1.50 by default. Taking damage resets the combo counter.

### Drainer — `Atrophying` or `Stultifying`

Each Drainer independently chooses stamina or mana when it spawns. Successful damage against a player drains the chosen vital by a fraction of damage controlled by `DrainDamageFraction`. The default fraction is 1.0, and the vital cannot be reduced below the amount ACE permits.

### Duelist — `Dueling`

Duelist parries player damage while it is facing the player within the configured frontal arc. `DuelistFrontArcDegrees` defaults to a 40-degree total arc. Attacking from the side or rear avoids the parry.

### Evader — `Evasive`

Evader has a flat chance to evade an incoming physical attack. `EvaderAutoEvadeChance` defaults to 25%. The port corrects the reversed probability comparison in the experimental sample, so 25% means approximately 25%, not 75%.

### Exploder — `Exploding`

When its player target remains inside `ExploderTriggerRange`, the creature begins a visible heartbeat countdown. At zero it deals health-scaled fire damage to a bounded number of nearby players and destroys itself. Damage is capped by `ExploderMaximumDamage`; moving outside the range resets the countdown.

### Healer — `Mending`

While fighting a player, Healer periodically finds the most injured nearby ordinary monsters and restores a fraction of their maximum health. Range, interval, target limit, and healing fraction are controlled by `HealerRange`, `HealerIntervalSeconds`, `HealerMaximumTargets`, and `HealerHealthFraction`.

### Shielded — `Shielded`

Shielded starts with `ShieldCount` charges, three by default. Each charge completely negates one hit. Once charges are depleted, the shield set replenishes after `ShieldRechargeSeconds`. Charges and timers are runtime-only.

### SpellBreaker — `Breaking`

When SpellBreaker damages a player who is actively casting, it interrupts the cast and deals bounded fire damage based on the interrupted spell's mana use. `SpellBreakerManaDamageFraction` controls the conversion and `SpellBreakerMaximumDamage` provides the safety cap.

### Stomper — `Massive`

Successful hits against a player splash the same damage type to a limited number of other nearby players. Splash damage falls off with distance and is capped as a fraction of the original hit by `StomperMaximumSplashFraction`. Range and target count are separately bounded.

### Vampire — `Vampiric`

Vampire heals itself for a configurable fraction of successful damage against a player. `VampireLeechFraction` defaults to 1.0. ACE's ordinary maximum-health limit still applies, so it cannot overheal.

### Rogue — `Rakish`

Rogue attacks from behind have a configurable chance to interrupt the player's current attack or spell and drain stamina. `RogueFumbleChance`, `RogueCooldownSeconds`, and `RogueStaminaDrain` bound the effect. Unlike the experimental sample, this implementation never unequips, moves, or drops player items.

### Horde — `Swarm of N/M`

Horde represents several creatures through one bounded shared-health entity. Its maximum health increases for each configured additional member. The displayed `N/M` count falls as the shared health percentage falls, and outgoing damage scales with living members up to `HordeMaximumDamageMultiplier`. It does not recursively grow, merge creatures, or create extra corpses and loot.

### Puppeteer — `Conniving`

While fighting, Puppeteer periodically creates temporary copies around itself. These illusions are invulnerable, cannot attack or be attacked, grant no experience, carry no death treasure, and do not inherit random variants. Copies are tracked explicitly and destroyed when their lifetime expires, their owner dies, or the mod unloads. Maximum copies, spawn interval, lifetime, and radius are configurable.

### Boss — `Tyrannical`

Boss is a bounded encounter variant with configurable model scale, attributes, vitals, outgoing damage, and experience multipliers. It rotates among physical and elemental damage weaknesses; matching damage receives `BossWeaknessDamageMultiplier`, while other damage receives `BossOtherDamageMultiplier`. It can make its attacks unevadable, its spells unresistable, and periodically cast one spell selected from `BossSpellIds` within a configured range. This replaces the experimental sample's 1000x experience, volleys, and projectile "bullet hell" with conservative limits.

### Tank — `Guardian`

Tank protects nearby monsters from direct player damage. When an eligible nearby monster would be hit, the Guardian takes `TankRedirectDamageMultiplier` times that damage and the protected hit is cancelled. A Tank never redirects damage already aimed at itself, preventing recursive redirection. `TankProtectionRange` limits the search.

### Stunner — `Debilitating`

While its player target is nearby, Stunner periodically interrupts attacks and spells, freezes the target, and plays a kneeling motion. The player is released after `StunnerDurationSeconds`, and the implementation restores the player's previous frozen state. Overlapping stuns safely extend the expiry rather than releasing the player early.

## Stacking behavior

Stacked variants execute together rather than choosing only a visual prefix:

- offensive effects can trigger from the same hit;
- Horde and Boss damage multipliers combine multiplicatively;
- Horde and Boss maximum-health multipliers combine;
- an enraged Berserker/Boss combines both attribute multipliers;
- every timed Healer, Shielded, Puppeteer, Boss, Stunner, or Exploder behavior receives its heartbeat;
- Boss/Puppeteer illusions never inherit the owner's stack;
- a Tank stack cannot redirect damage aimed at itself; and
- an Exploder that dies stops processing later timed abilities on that heartbeat.

The creature's displayed name concatenates its assigned prefixes. A stacked Horde keeps its dynamic `Swarm of N/M` display in addition to its other prefixes.

## Settings reference

| Setting | Default | Purpose |
|---|---:|---|
| `Enabled` | `true` | Master switch. Takes effect after server restart. |
| `AssignmentChance` | `0.50` | Chance an eligible spawn receives at least one variant. |
| `AllowVariantStacking` | `true` | Allows more than one distinct variant on a creature. |
| `AdditionalVariantChance` | `0.50` | Chance to add each subsequent variant. |
| `MaximumVariantsPerCreature` | `3` | Hard cap from 1 through 18. |
| `ShowTraitInCreatureName` | `true` | Shows variant prefixes and Horde member counts. |
| `MinimumLevel` / `MaximumLevel` | `1` / `275` | Inclusive eligible level range. |
| `AllowedWeenieClassIds` | empty | Optional allow list; empty allows all otherwise eligible WCIDs. |
| `ExcludedWeenieClassIds` | empty | WCIDs that must never receive variants. |
| `ForcedTraitsByWeenieClassId` | empty | Exact WCID-to-single-variant mappings using decimal or `0x` keys. |
| `TraitWeights` | per variant | Relative random-selection weights; zero disables random selection for that variant. |

Every mechanical value described above is also present in `Settings.json`. Values are validated when the mod loads or reloads. Invalid probabilities, ranges, caps, WCIDs, spell IDs, or non-finite numbers reject the settings rather than silently applying unsafe behavior.

## Commands

Developer-access characters can use:

- `@creaturevariants status` — shows assignment, stacking, active-weight, forced-WCID, and settings-path information;
- `@creaturevariants list` — lists all available variant identifiers; and
- `@creaturevariants reload` — validates and loads edited settings for future spawns.

Creatures already alive retain their assigned stack until they despawn or the server restarts.

## Compatibility, removal, and testing

- **Target:** OpenDereth / ACE.Server 1.1 / .NET 10.
- **Data impact:** Settings only. No weenie, world, character, or client DAT rows are rewritten.
- **Removal:** Safe after stopping the server. Restart without the mod to restore stock behavior.
- **Conflict:** Do not combine it with Aquafir's broad `Expansion` creature framework unless their overlapping Harmony patches have been reviewed together.
- **Automated validation:** The package builds, loads, validates weighted selection and distinct capped stacking, checks the pinned ACE factory/combat/heartbeat/attribute/vital/scale/XP/spell-resistance signatures, and passes clean-removal tests.
- **Remaining risk:** The complete matrix of 18 variants, stacked combinations, custom creatures, custom spells, dungeons, and other combat mods has not been thoroughly tested in game.

The OpenDereth adaptation and Aquafir's original work are distributed under the GNU Affero General Public License v3.0.
