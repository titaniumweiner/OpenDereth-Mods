# Contributing to OpenDereth Mods

Thank you for helping make reusable Asheron's Call content easier to discover and share.

## Before opening a pull request

Open an issue describing the mod when it introduces persistent character data, custom world IDs, client DAT changes, or dependencies on another mod. This lets maintainers identify ID ownership, conflicts, and rollback requirements before players depend on the package.

## Submission requirements

A catalog submission must include:

- a stable lowercase ID such as `author.mod-name`;
- a useful name, author, and plain-language description;
- the authoritative source repository and license or explicit redistribution permission;
- the targeted OpenDereth, ACE.Server, and .NET versions;
- an `ace-mod.json` package manifest and valid `Meta.json`;
- dependencies and known conflicts;
- saved-data impact and a truthful removal policy;
- installation, configuration, and removal instructions;
- tests appropriate to the code's risk;
- a reproducible format-2 ZIP with an embedded SHA-256 hash for every payload file.

Do not include copyrighted Asheron's Call client files, DAT files, passwords, database credentials, private Discord messages, personal filesystem paths, or third-party binaries without permission.

## Testing levels

- **Ready:** Rebuilt for the pinned OpenDereth ACE version, automated checks pass, and representative behavior has been tested in game.
- **Preview:** Rebuilt and automated checks pass, but in-game coverage is limited.
- **Experimental:** The package is intentionally incomplete or high risk.
- **Needs port:** Source exists but has not been rebuilt for the pinned runtime.

Never describe a package as thoroughly tested unless its documented gameplay, save, restart, disable, and rollback flows have actually been exercised.

## Saved-data policies

- **Safe:** No saved game data depends on the mod.
- **Changes remain:** The mod can be disabled, but completed progression or item changes are not undone.
- **Backup required:** Disabling may leave unusual but loadable state.
- **Do not remove:** Characters, items, world content, spells, or client data may require the mod.

## Pull request contents

Update the README entry, `catalog.json`, source or source link, testing statement, checksum, dependencies, conflicts, and safety notice together. Binary release assets are published by maintainers after review; do not commit large compiled packages directly to the repository.

By contributing OpenDereth-authored code or documentation, you agree that it may be distributed under the repository's GNU Affero General Public License v3.0. Third-party projects retain their own licenses and attribution.
