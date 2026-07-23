# OpenDereth Mods v1.2.0

This release adds **Three Imbues 1.0.0-sp1** and migrates the complete public catalog to OpenDereth's single-file package format 2.

Every release ZIP now embeds a SHA-256 hash for every payload file. The updated launcher verifies the complete manifest before installation, so players download and import only one ZIP. Legacy format-1 packages remain supported when their external `.zip.sha256` file is present.

**OpenDereth v0.2.0-preview.11 or newer is required to import these format-2 packages.** Older launcher releases understand only the legacy sidecar format.

- Supports combinations such as Armor Rending, Critical Strike, and Crippling Blow on one eligible weapon.
- Preserves ACE's normal item/material eligibility, ten-tinker limit, skill and workmanship calculations, success chance, salvage consumption, and failure destruction.
- Rejects duplicate effects and enforces a hard maximum of three.
- Stores effects in ACE's persistent `ImbuedEffect`, `ImbuedEffect2`, and `ImbuedEffect3` properties.
- Makes weapon and equipped-defense calculations read the combined ACE imbue slots.
- Includes a setting that may lower the limit to one or two but cannot raise it above the tested cap.

The packages target OpenDereth's pinned ACE.Server 1.1 / .NET 10 runtime. The full OpenDereth suite passes 101/101 tests, including single-file installation, legacy-package compatibility, altered-file rejection, unlisted-file rejection, archive safety, mod behavior, and removal paths.

## Install

Download the desired ZIP, stop the game and local server, then use **OpenDereth → Server Mods → Import a Mod ZIP...**. No separate checksum file is needed for v1.2.0 packages.

Back up `%LOCALAPPDATA%\OpenDereth` first. Do not permanently remove the mod while characters own multi-imbued items; secondary effects stay saved but stock ACE does not activate them.

---

# OpenDereth Mods v1.1.0

This release adds **Aquafir Creature Variants 1.2.0-sp1**, a reviewed runtime-only port of Aquafir's experimental creature concepts.

- Eighteen completed variants: Accurate, Berserker, Comboer, Drainer, Duelist, Evader, Exploder, Healer, Shielded, SpellBreaker, Stomper, Vampire, Rogue, Horde, Puppeteer, Boss, Tank, and Stunner.
- Configurable random assignment with a visible 50% testing default.
- Distinct variant stacking with a configurable additional-roll chance and cap of three by default.
- Weighted rarity, level and WCID filters, exact forced-WCID examples, and bounds validation for every mechanic.
- Runtime-only state: no character, world, weenie, or client DAT rows are rewritten.
- Complete documentation for installation, every variant, stacking interactions, settings, commands, compatibility, removal, and remaining Preview risks.

The package builds against OpenDereth's pinned ACE.Server 1.1 / .NET 10 runtime. The full OpenDereth automated suite passes 95/95 tests. Its SHA-256 is `CB76F1BAE5A5A2A87E8579E4EFDEB88745B4984EC466186FA4D666CF6095E54F`.

## Install

Download both `opendereth.aquafir-creature-variants-1.2.0-sp1.zip` and its matching `.zip.sha256` file. Keep them together, stop the game and local server, then use **OpenDereth → Server Mods → Import a Mod ZIP...**.

The 50% assignment and stacking values are intentionally high for testing. Read the [complete guide](docs/AQUIFIR_CREATURE_VARIANTS.md), back up `%LOCALAPPDATA%\OpenDereth`, and reduce the probabilities for a long-term world.

---

# OpenDereth Mods v1.0.0

The first independent OpenDereth mod-library release contains eight checksum-verified packages for OpenDereth / ACE.Server 1.1 on .NET 10.

## Gameplay and content mods

- **All-Tier Salvage & Loot Luck** — all category-compatible materials at every equipment-loot tier, plus optional quality, loot, trophy, and rare controls.
- **Unlimited Stat Augmentation Gems** — unlimited uses of the six innate-stat gems with each stat still capped at 100.
- **Unlimited Skill Specializations** — removes the 70-credit total specialization ceiling while preserving normal costs.
- **Expanded Cast on Strike** — enables compatible non-Aetheria equipped-item procs.
- **Critical Override** — configurable physical and magic critical chances against creatures.
- **Society Tailoring** — permits Society armor in tailoring.
- **CustomClothingBase v1.11** — OptimShi's JSON-driven custom ClothingTable loader, packaged for OpenDereth import.
- **Hello Command** — a small working server-mod development example.

## Install

Download both the desired `.zip` and its matching `.zip.sha256` file. Keep them together, stop the game and local server, then use **OpenDereth → Server Mods → Import a Mod ZIP...**.

Most packages are Preview builds with automated compatibility coverage but limited in-game testing. Read each mod's description, dependencies, conflicts, saved-data impact, and removal policy in the [catalog README](https://github.com/titaniumweiner/OpenDereth-Mods#available-mods) before installing. Back up `%LOCALAPPDATA%\OpenDereth` before testing progression or saved-item changes.

Every uploaded ZIP is verified against both its sidecar checksum and the SHA-256 recorded in [`catalog.json`](https://github.com/titaniumweiner/OpenDereth-Mods/blob/main/catalog.json) before this release is created.
