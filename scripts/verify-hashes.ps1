# verify-hashes.ps1
# Checks the SHA-256 hashes listed in evidence/REPORT-*.md against the files in this repo.
# PowerShell 5.1. Run from the repo root:  powershell -File scripts\verify-hashes.ps1
# All paths are relative to the repo root. Exit code 1 if any hash differs or any file is missing.

# Stop on unexpected errors, but handle missing files ourselves below.
$ErrorActionPreference = 'Stop'

# Block 1: find the reports. They must be under evidence/ in the current folder.
if (-not (Test-Path -LiteralPath 'evidence')) {
    Write-Output 'evidence folder not found. Run this script from the repo root.'
    exit 2
}
$reports = Get-ChildItem -LiteralPath 'evidence' -Filter 'REPORT-*.md' | Sort-Object Name

# Block 2: count mismatches over all reports.
$totalMismatches = 0

foreach ($report in $reports) {
    $checked = 0
    $mismatches = 0
    $bad = New-Object System.Collections.Generic.List[string]

    # Block 3: read the report as text. Hash lines look like: <64 hex characters> <path>.
    # The path is relative to the repo root. A separator of one or more spaces is accepted.
    $lines = [System.IO.File]::ReadAllLines((Join-Path 'evidence' $report.Name))
    foreach ($line in $lines) {
        if ($line -match '^([0-9a-f]{64})\s+(\S+)\s*$') {
            $expected = $Matches[1]
            $path = $Matches[2]
            $checked++

            # Block 4: compute the hash of the listed file. A missing file counts as a mismatch.
            if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
                $mismatches++
                $bad.Add("MISMATCH $path (file not found)")
                continue
            }
            $actual = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLower()

            # Block 5: compare with the hash in the report.
            if ($actual -ne $expected) {
                $mismatches++
                $bad.Add("MISMATCH $path")
            }
        }
    }

    # Block 6: print the result for this report, then each bad path.
    Write-Output ("{0}: checked={1} mismatches={2}" -f $report.Name, $checked, $mismatches)
    foreach ($b in $bad) { Write-Output $b }
    $totalMismatches += $mismatches
}

# Block 7: exit code for scripts and CI.
if ($totalMismatches -gt 0) { exit 1 }
exit 0
