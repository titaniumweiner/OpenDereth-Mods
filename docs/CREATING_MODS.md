# Creating an OpenDereth server mod

OpenDereth server mods are .NET assemblies loaded by ACE's Harmony mod system. They can change server behavior but cannot, by themselves, add genuinely new client models, textures, sounds, terrain, or buildings.

## Minimal package layout

```text
author.mod-name-1.0.0.zip
├── ace-mod.json
└── mod/
    ├── ModAssembly.dll
    ├── Meta.json
    ├── README.md
    └── Settings.json        optional
```

The ZIP must be accompanied by `author.mod-name-1.0.0.zip.sha256`.

## Package manifest

```json
{
  "formatVersion": 1,
  "id": "author.mod-name",
  "name": "Readable Mod Name",
  "version": "1.0.0",
  "folderName": "ModAssembly",
  "entryAssembly": "ModAssembly.dll"
}
```

`folderName`, the DLL filename without `.dll`, and the assembly name must match.

## Metadata

```json
{
  "Name": "Readable Mod Name",
  "Author": "Your Name",
  "Description": "Explain what changes in plain language.",
  "Version": "1.0.0",
  "Priority": 0,
  "Enabled": true,
  "HotReload": false,
  "RegisterCommands": false,
  "CatalogId": "author.mod-name",
  "TargetAceVersion": "ACE.Server 1.1 / .NET 10",
  "DataImpact": "SettingsOnly",
  "RemovalPolicy": "Safe"
}
```

## Design requirements

- Patch exact ACE methods and signatures so incompatibility fails visibly after an ACE update.
- Keep optional behavior disabled or at stock ACE values by default.
- Validate settings and reject unsafe, non-finite, or out-of-range values.
- Do not mutate cached shared objects when a per-call clone is safer.
- Undo runtime patches and reversible static changes in `Dispose`.
- Document which completed changes remain after disabling.
- Declare dependencies and conflicts instead of assuming arbitrary mods compose safely.
- Never embed credentials, personal paths, client DAT files, or unlicensed third-party content.

## Testing checklist

At minimum, test that the mod:

1. builds against the exact OpenDereth ACE version;
2. targets the expected Harmony signatures;
3. applies only the intended rule change;
4. validates settings boundaries;
5. can be disabled and unpatched cleanly;
6. leaves saved data in the documented condition;
7. loads during an isolated ACE server startup;
8. produces a package whose checksum matches.

Gameplay-changing mods should also be tested in game across acquisition, use, save, logout, restart, disable, and recovery flows before being promoted from Preview.

## World and client content

Custom weenies, quests, encounters, recipes, and placements are world-content packages rather than ordinary behavior DLLs. They need versioned database migrations, custom ID ownership, backup rules, and rollback plans.

New terrain, models, textures, icons, sounds, or buildings also require a matched client-content package and an atomic way to switch the complete DAT set. Do not present those packages as harmless server-mod checkboxes.

For working mod source, see this repository's [`src` directory](https://github.com/titaniumweiner/OpenDereth-Mods/tree/main/src). Package rebuilt mods with OpenDereth's [`scripts/package-mod.ps1`](https://github.com/titaniumweiner/OpenDereth/blob/main/scripts/package-mod.ps1) helper.
