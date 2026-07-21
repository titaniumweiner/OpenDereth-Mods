# OpenDereth Mods

OpenDereth Mods is the public mod library for [OpenDereth](https://github.com/titaniumweiner/OpenDereth), the portable single-player Asheron's Call emulator and launcher.

This repository keeps mod releases independent from launcher releases. Players can download only the changes they want, while authors can document, test, and update their work without requiring a new OpenDereth build.

> [!IMPORTANT]
> These packages target **OpenDereth / ACE.Server 1.1 on .NET 10**. Most are marked **Preview** because they build and pass automated compatibility tests but have not been thoroughly tested across every in-game situation. Stop the game and server, and back up `%LOCALAPPDATA%\OpenDereth` before testing progression or saved-item changes.

## Installing a mod

1. Download both the mod's `.zip` and matching `.zip.sha256` file from the [latest release](https://github.com/titaniumweiner/OpenDereth-Mods/releases/latest).
2. Keep the two files together without renaming either one.
3. Close the Asheron's Call client and stop the local server.
4. In OpenDereth, open **Server Mods**, choose **Import a Mod ZIP...**, and select the ZIP.

See [Installing and removing mods](docs/INSTALLING.md) for the complete safety and recovery guide.

## Available mods

| Mod | What it does | Saved-data impact | Status |
|---|---|---:|---|
| [Aquafir Creature Variants](#aquafir-creature-variants) | Randomly gives ordinary monsters one or more of 18 stackable combat variants. | Settings only | Preview |
| [All-Tier Salvage & Loot Luck](#all-tier-salvage--loot-luck) | Makes every equipment-loot tier eligible for all category-compatible ACE materials, with optional luck settings. | Changes remain on generated items | Preview |
| [Unlimited Stat Augmentation Gems](#unlimited-stat-augmentation-gems) | Removes the shared limit on six innate-stat augmentation gems while keeping each stat capped at 100. | Character progression | Preview |
| [Unlimited Skill Specializations](#unlimited-skill-specializations) | Removes the 70-credit total specialization ceiling while preserving normal costs and prerequisites. | Character progression | Preview |
| [Expanded Cast on Strike](#expanded-cast-on-strike) | Allows compatible non-Aetheria equipped items to use cast-on-strike procs. | Runtime behavior | Preview |
| [Critical Override](#critical-override) | Makes physical and magic critical chances against creatures configurable. | Settings only | Ready |
| [Society Tailoring](#society-tailoring) | Allows Society armor to participate in tailoring. | Changes remain on tailored items | Preview |
| [CustomClothingBase](#customclothingbase) | Loads custom ClothingTable definitions from JSON without requiring client DAT edits. | Saved items may depend on it | Preview |
| [Hello Command](#hello-command) | Adds `/hello` and `/bye` as a small server-mod development example. | None | Preview / developer sample |

## Aquafir Creature Variants

**Original concepts:** [aquafir](https://github.com/aquafir/ACE.BaseMod/tree/41c2728fc0e4fb96d06b4e7949ca369ed5be9621/Samples/Expansion/Creatures)<br>
**OpenDereth review and port:** OpenDereth<br>
**Package:** `opendereth.aquafir-creature-variants-1.2.0-sp1.zip`

Randomly gives eligible ordinary monsters one or more of 18 runtime combat variants: Accurate, Berserker, Comboer, Drainer, Duelist, Evader, Exploder, Healer, Shielded, SpellBreaker, Stomper, Vampire, Rogue, Horde, Puppeteer, Boss, Tank, and Stunner.

The default testing profile gives 50% of eligible creatures at least one variant. Stacking is enabled, with a 50% roll for each additional distinct variant and a maximum of three. The assignment chance, stacking behavior, level and WCID filters, per-variant weights, and every mechanical value can be edited in `Settings.json`. Boss, Puppeteer, and Horde use lower random weights than ordinary variants.

This is a runtime-only mod. It does not replace creature weenies or rewrite character, world, or client DAT data. Stacked variants execute together, including multiplicative Boss/Horde damage and health scaling, combined Berserker/Boss attributes, multiple on-hit effects, and independent timed abilities. Creature names display all assigned prefixes.

### What each variant does

These are the shipped testing defaults. Every chance, timer, range, multiplier, target limit, and safety cap listed below can be changed in `Settings.json`.

| Variant | Creature-name prefix | Behavior and default values |
|---|---|---|
| **Accurate** | `Accurate` | Has a 25% flat chance to make each physical attack unavoidable. It affects only that attack and does not permanently lower the player's defense skill. |
| **Berserker** | `Raging` | At 60% health or lower, gains a 1.30x runtime multiplier to all six primary attributes for the rest of that spawn. Healing above 60% does not end the rage. |
| **Comboer** | `Frenetic` | Counts consecutive successful hits against a player. Every fifth hit deals 1.50x damage; taking damage resets the combo counter. |
| **Drainer** | `Atrophying` or `Stultifying` | Chooses stamina or mana when it spawns, then drains that vital on successful player hits. The default drain equals 100% of damage dealt. |
| **Duelist** | `Dueling` | Parries player damage while facing the attacker inside a 40-degree total frontal arc. Attacks from its side or rear bypass the parry. |
| **Evader** | `Evasive` | Has a 25% flat chance to evade an incoming physical attack. This port corrects the experimental sample's reversed probability comparison. |
| **Exploder** | `Exploding` | Starts a visible three-heartbeat countdown while its target remains within 5 units. At zero it deals health-scaled fire damage, capped at 250, to a bounded group of nearby players and then destroys itself; leaving range resets the countdown. |
| **Healer** | `Mending` | Every 15 seconds, heals up to three injured ordinary monsters within 15 units for 20% of their maximum health. |
| **Shielded** | `Shielded` | Starts with three shield charges. Each charge completely negates one hit; the full set replenishes 25 seconds after depletion. |
| **SpellBreaker** | `Breaking` | When it damages a player who is actively casting, interrupts the cast and deals extra fire damage based on the spell's mana use, capped at 250. |
| **Stomper** | `Massive` | Successful player hits splash the same damage type with distance falloff to as many as five other players within 10 units. Splash is capped at 80% of the original hit. |
| **Vampire** | `Vampiric` | Heals itself for 100% of successful damage dealt to a player, up to its normal maximum health. |
| **Rogue** | `Rakish` | Attacks from behind have a 25% chance, with a 10-second cooldown, to interrupt the player's current attack or cast and drain 20 stamina. It never unequips, moves, or drops player items. |
| **Horde** | `Swarm of N/M` | Represents an initial swarm of three to six members through one shared-health creature. Each extra member adds 50% maximum health; each additional living member adds 15% outgoing damage, capped at 3x. The displayed living count falls with health, without creating extra corpses or loot. |
| **Puppeteer** | `Conniving` | Creates up to three temporary illusions, one every 15 seconds, within 3 units. Copies last 45 seconds, cannot attack or be attacked, grant no XP or loot, and are cleaned up on timeout, owner death, or mod unload. |
| **Boss** | `Tyrannical` | Becomes a larger encounter creature: 1.75x scale, 1.50x attributes, 2x vitals, 1.25x outgoing damage, and 5x XP. It rotates a damage weakness every 15 seconds (1.50x matching damage and 0.50x other damage) and periodically casts one bounded special spell. Its attacks can be unevadable and its spells unresistable. |
| **Tank** | `Guardian` | Intercepts direct player damage aimed at another monster within 10 units and takes 50% of that damage itself while cancelling the protected hit. It cannot redirect hits already aimed at itself, preventing recursion. |
| **Stunner** | `Debilitating` | Every 20 seconds, when its player target is within 8 units, interrupts attacks and spells and freezes the player in a kneeling motion for 2 seconds. It restores the player's previous frozen state; overlapping stuns safely extend the duration. |

When variants stack, their mechanics run together rather than merely adding extra name prefixes. For example, a Tyrannical Swarm combines Boss and Horde health and damage scaling, while on-hit traits such as Drainer, Vampire, and Stomper can all trigger from the same successful attack.

- [Download ZIP](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.1.0/opendereth.aquafir-creature-variants-1.2.0-sp1.zip)
- [Download checksum](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.1.0/opendereth.aquafir-creature-variants-1.2.0-sp1.zip.sha256)
- [Complete installation, variant, stacking, settings, command, and compatibility guide](docs/AQUIFIR_CREATURE_VARIANTS.md)
- [Reviewed port source](src/AquafirCreatureVariants)

**Removal:** Safe after stopping and restarting the server. All variant state, temporary illusions, stuns, and name prefixes are runtime-only. Conflicts with Aquafir's broad `Expansion` creature framework.

> [!WARNING]
> This package is a Preview. The intentionally high 50% assignment/stacking defaults are meant for testing, and every stacked combination has not been thoroughly tested in game. Back up before use and reduce the probabilities for a long-term world.

## All-Tier Salvage & Loot Luck

**Author:** OpenDereth<br>
**Package:** `opendereth.universal-loot-luck-1.0.0-sp1.zip`

Generated armor, weapons, clothing, jewelry, casters, and other equipment normally select materials from tier-specific ACE tables. This mod combines the normalized tier 1-6 rows for the item's own material category before rolling. Every hunting tier can therefore produce the compatible materials that yield low- and high-tier salvage.

It does **not** put loose salvage bags on corpses or assign arbitrary materials to unrelated item categories.

The default configuration changes only material availability. Optional, independent settings can add a bounded loot-quality bias or multiply generated-loot category chances, trophy rates, and the initial rare-eligibility roll. All optional luck controls default to stock ACE behavior.

- [Download ZIP](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/opendereth.universal-loot-luck-1.0.0-sp1.zip)
- [Download checksum](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/opendereth.universal-loot-luck-1.0.0-sp1.zip.sha256)
- [Source and full settings reference](src/UniversalLootLuck)

**Removal:** Safe to disable after restart, but materials and quality already generated on saved items remain. Conflicts with Aquafir's broad `Expansion` loot framework.

## Unlimited Stat Augmentation Gems

**Author:** OpenDereth<br>
**Package:** `opendereth.unlimited-stat-augmentation-gems-1.0.0-sp1.zip`

Removes the normal shared limit of ten gems across Strength, Endurance, Coordination, Quickness, Focus, and Self. Each innate stat remains hard-capped at 100. Gems retain their normal experience cost and consumption behavior, and all other augmentation limits remain unchanged.

- [Download ZIP](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/opendereth.unlimited-stat-augmentation-gems-1.0.0-sp1.zip)
- [Download checksum](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/opendereth.unlimited-stat-augmentation-gems-1.0.0-sp1.zip.sha256)
- [Source](src/UnlimitedStatAugmentation)

**Removal:** Turning it off restores the normal shared limit after restart. Stat increases already earned remain. Conflicts with Aquafir's broader `QualityOfLife` augmentation-limit feature.

## Unlimited Skill Specializations

**Author:** OpenDereth<br>
**Package:** `opendereth.unlimited-skill-specializations-1.0.0-sp1.zip`

Removes ACE's ceiling of 70 total credits invested in specialized skills. It does not grant credits: a skill must still be trained, the character must have its normal specialization cost available, and that cost is deducted normally. ACE's administrator verifier is updated so legitimate over-cap characters are not reset.

- [Download ZIP](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/opendereth.unlimited-skill-specializations-1.0.0-sp1.zip)
- [Download checksum](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/opendereth.unlimited-skill-specializations-1.0.0-sp1.zip.sha256)
- [Source](src/UnlimitedSkillSpecializations)

**Removal:** Existing over-cap specializations remain until lowered normally. Conflicts with Aquafir's broader `QualityOfLife` specialization changes.

## Expanded Cast on Strike

**Original content and documented filter:** [titaniumweiner/ACEUniqueWeenies](https://github.com/titaniumweiner/ACEUniqueWeenies)<br>
**OpenDereth port:** titaniumweiner / OpenDereth<br>
**Package:** `titaniumweiner.ace-unique-weenies-proc-1.0.0-sp1.zip`

Stock ACE runs its equipped-item proc pass only for Aetheria. This mod also accepts a non-Aetheria equipped item when it has a proc, is not cloak weave proc type `1`, and its self-target flag matches the current attack. It is intended for compatible custom jewelry, armor, and weapons such as the ACEUniqueWeenies content.

- [Download ZIP](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/titaniumweiner.ace-unique-weenies-proc-1.0.0-sp1.zip)
- [Download checksum](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/titaniumweiner.ace-unique-weenies-proc-1.0.0-sp1.zip.sha256)
- [Port source](src/ExpandedCastOnStrike)

**Removal:** Safe for the database. Custom items remain, but their non-Aetheria equipped procs stop working after restart.

## Critical Override

**Original author:** [aquafir](https://github.com/aquafir/ACE.BaseMod/tree/master/Samples/CriticalOverride)<br>
**OpenDereth port:** OpenDereth<br>
**Package:** `aquafir.critical-override-1.0.0-sp1.zip`

Provides two simple settings for physical and magic critical-hit chances against non-player creatures. Player-versus-player calculations remain unchanged.

- [Download ZIP](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/aquafir.critical-override-1.0.0-sp1.zip)
- [Download checksum](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/aquafir.critical-override-1.0.0-sp1.zip.sha256)
- [Port source](src/CriticalOverride)

**Removal:** Safe after restart. Earlier combat results are not recalculated.

## Society Tailoring

**Original author:** [aquafir](https://github.com/aquafir/ACE.BaseMod/tree/master/Samples/SocietyTailoring)<br>
**OpenDereth port:** OpenDereth<br>
**Package:** `aquafir.society-tailoring-1.0.0-sp1.zip`

Allows Society armor to be used in ACE's tailoring workflow while preserving inventory and retained-item checks.

- [Download ZIP](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/aquafir.society-tailoring-1.0.0-sp1.zip)
- [Download checksum](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/aquafir.society-tailoring-1.0.0-sp1.zip.sha256)
- [Port source](src/SocietyTailoring)

**Removal:** Turning it off stops new Society tailoring, but completed tailoring changes remain on items.

## CustomClothingBase

**Author:** [OptimShi](https://github.com/OptimShi/CustomClothingBase)<br>
**Package:** `optimshi.custom-clothing-base-1.11-upstream.zip`

Loads custom server-side ClothingTable entries from JSON, enabling new clothing colors and appearance combinations without client DAT updates. The package contains OptimShi's unmodified official v1.11 binaries plus OpenDereth metadata and import structure.

- [Download ZIP](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/optimshi.custom-clothing-base-1.11-upstream.zip)
- [Download checksum](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/optimshi.custom-clothing-base-1.11-upstream.zip.sha256)
- [Original source and documentation](https://github.com/OptimShi/CustomClothingBase)

**Removal:** Do not remove it while saved items or world content refer to custom ClothingBase IDs.

> [!NOTE]
> The upstream repository currently has no `LICENSE` file. Redistribution here is based on OptimShi's permission reported by the OpenDereth project maintainer. Attribution and the original project link are preserved.

## Hello Command

**Original author:** [aquafir](https://github.com/aquafir/ACE.BaseMod/tree/master/Samples/HelloCommand)<br>
**OpenDereth port:** OpenDereth<br>
**Package:** `aquafir.hello-command-1.0.0-sp1.zip`

A deliberately small developer example that registers `/hello` and `/bye`. It is useful as a working reference for OpenDereth server-mod authors and adds little to ordinary gameplay.

- [Download ZIP](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/aquafir.hello-command-1.0.0-sp1.zip)
- [Download checksum](https://github.com/titaniumweiner/OpenDereth-Mods/releases/download/v1.0.0/aquafir.hello-command-1.0.0-sp1.zip.sha256)
- [Port source](src/HelloCommand)

**Removal:** Safe after restart.

## Machine-readable catalog

[`catalog.json`](catalog.json) contains stable IDs, versions, descriptions, compatibility, saved-data policies, dependencies, conflicts, release URLs, and SHA-256 values. A future OpenDereth launcher can consume this file while retaining its bundled catalog as an offline fallback.

The schema is documented in [`catalog.schema.json`](catalog.schema.json).

## Contributing a mod

Community contributions are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) and [Creating an OpenDereth mod](docs/CREATING_MODS.md) before submitting a pull request.

Every submitted package must include source or an authoritative source link, clear permission/license information, an OpenDereth manifest, saved-game and removal behavior, compatibility metadata, tests appropriate to its risk, and a SHA-256 checksum.

## Project relationship and trademarks

This library is maintained for OpenDereth and uses the ACE emulator. It is not affiliated with or endorsed by Warner Bros., Turbine, or the original Asheron's Call developers. Asheron's Call names and assets belong to their respective owners.

Except for separately attributed third-party material, repository documentation and OpenDereth-authored mod code are distributed under the [GNU Affero General Public License v3.0](LICENSE).
