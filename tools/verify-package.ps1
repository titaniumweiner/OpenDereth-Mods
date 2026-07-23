param(
    [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
    [string[]] $PackagePath
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression.FileSystem

foreach ($path in $PackagePath) {
    $path = (Resolve-Path -LiteralPath $path).Path
    $archive = [IO.Compression.ZipFile]::OpenRead($path)
    try {
        $manifestEntries = @($archive.Entries | Where-Object { $_.FullName.Replace('\', '/') -ieq 'ace-mod.json' })
        if ($manifestEntries.Count -ne 1) {
            throw "$(Split-Path $path -Leaf) must contain exactly one ace-mod.json at the ZIP root."
        }
        $reader = [IO.StreamReader]::new($manifestEntries[0].Open())
        try {
            $manifest = $reader.ReadToEnd() | ConvertFrom-Json
        }
        finally {
            $reader.Dispose()
        }
        if ($manifest.formatVersion -ne 2 -or $manifest.integrity.algorithm -ine 'SHA256') {
            throw "$(Split-Path $path -Leaf) is not an embedded-integrity format-2 package."
        }

        $expected = @{}
        foreach ($property in @($manifest.integrity.files.psobject.Properties)) {
            $normalized = $property.Name.Replace('\', '/')
            if (-not $normalized.StartsWith('mod/', [StringComparison]::OrdinalIgnoreCase) -or
                $property.Value -notmatch '^[A-Fa-f0-9]{64}$' -or $expected.ContainsKey($normalized)) {
                throw "Invalid integrity entry in $(Split-Path $path -Leaf): $($property.Name)"
            }
            $expected[$normalized] = $property.Value
        }
        if ($expected.Count -eq 0) {
            throw "$(Split-Path $path -Leaf) has an empty integrity manifest."
        }

        $seen = @{}
        foreach ($entry in $archive.Entries) {
            $normalized = $entry.FullName.Replace('\', '/')
            if ($normalized -ieq 'ace-mod.json' -or $normalized.EndsWith('/')) {
                continue
            }
            if ($seen.ContainsKey($normalized) -or -not $expected.ContainsKey($normalized)) {
                throw "Duplicate or unhashed package entry in $(Split-Path $path -Leaf): $normalized"
            }
            $seen[$normalized] = $true
            $stream = $entry.Open()
            try {
                $sha = [Security.Cryptography.SHA256]::Create()
                try {
                    $actual = ([BitConverter]::ToString($sha.ComputeHash($stream))).Replace('-', '')
                }
                finally {
                    $sha.Dispose()
                }
            }
            finally {
                $stream.Dispose()
            }
            if ($actual -ine $expected[$normalized]) {
                throw "Embedded checksum mismatch in $(Split-Path $path -Leaf): $normalized"
            }
        }
        if ($seen.Count -ne $expected.Count) {
            throw "$(Split-Path $path -Leaf) is missing one or more integrity-listed files."
        }
        Write-Host "Verified format-2 package: $(Split-Path $path -Leaf)"
    }
    finally {
        $archive.Dispose()
    }
}
