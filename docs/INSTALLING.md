# Installing and removing OpenDereth mods

## Before installing

1. Confirm the package targets your OpenDereth and ACE.Server versions.
2. Read its dependencies, conflicts, saved-data impact, removal policy, and Preview notice.
3. Close the game client and stop the local server.
4. For any mod marked **Changes remain**, **Backup required**, or **Do not remove**, copy `%LOCALAPPDATA%\OpenDereth` to a safe backup location.

## Importing a package

Download both the `.zip` and its matching `.zip.sha256` file from the same release. Keep them in the same directory without renaming either one.

Open OpenDereth, choose **Server Mods**, select **Import a Mod ZIP...**, and choose the ZIP. The launcher validates the checksum, identity, archive paths, size limits, manifest, metadata, and expected entry assembly before moving the complete mod into ACE's private Mods directory.

Restart the local server after installation or any settings change.

## Turning a mod off

Turning a mod off changes its `Enabled` metadata and stops its code after the next server restart. It does not undo changes already saved to characters, items, or the world.

For example, disabling Unlimited Stat Augmentation Gems restores the normal limit for future gem uses, but it does not lower stats already earned.

## Removing a mod

OpenDereth moves removable packages into its recovery directory instead of deleting them immediately. A **Do not remove** package should remain installed until it provides a tested cleanup migration and every dependent item or world record has been converted.

If startup fails after testing a mod, stop OpenDereth, restore the full `%LOCALAPPDATA%\OpenDereth` backup, and restart with the earlier mod set.

## Verifying manually

The `.zip.sha256` file contains the expected SHA-256 hash. Advanced users can compare it with:

```powershell
Get-FileHash .\author.mod-name-version.zip -Algorithm SHA256
```

The reported hash must match the checksum file exactly.
