# Installing and removing OpenDereth mods

## Before installing

1. Confirm the package targets your OpenDereth and ACE.Server versions.
2. Read its dependencies, conflicts, saved-data impact, removal policy, and Preview notice.
3. Close the game client and stop the local server.
4. For any mod marked **Changes remain**, **Backup required**, or **Do not remove**, copy `%LOCALAPPDATA%\OpenDereth` to a safe backup location.

## Importing a package

Download the mod's `.zip` from the current release. Format-2 packages are complete single files; no separate checksum download is required.

Open OpenDereth, choose **Server Mods**, select **Import a Mod ZIP...**, and choose the ZIP. The launcher validates every embedded SHA-256 file hash, identity, archive paths, size limits, manifest, metadata, and expected entry assembly before moving the complete mod into ACE's private Mods directory. Older format-1 packages remain compatible when their matching `.zip.sha256` file is beside the ZIP.

Restart the local server after installation or any settings change.

## Turning a mod off

Turning a mod off changes its `Enabled` metadata and stops its code after the next server restart. It does not undo changes already saved to characters, items, or the world.

For example, disabling Unlimited Stat Augmentation Gems restores the normal limit for future gem uses, but it does not lower stats already earned.

## Removing a mod

OpenDereth moves removable packages into its recovery directory instead of deleting them immediately. A **Do not remove** package should remain installed until it provides a tested cleanup migration and every dependent item or world record has been converted.

If startup fails after testing a mod, stop OpenDereth, restore the full `%LOCALAPPDATA%\OpenDereth` backup, and restart with the earlier mod set.

## Verifying manually

The machine-readable catalog records the SHA-256 of each complete release ZIP. Advanced users can compare a download with the catalog value using:

```powershell
Get-FileHash .\author.mod-name-version.zip -Algorithm SHA256
```

The reported hash must match that mod's `sha256` value in [`catalog.json`](../catalog.json). The launcher also verifies the embedded hashes of every payload file during import.
