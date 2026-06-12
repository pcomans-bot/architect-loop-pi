param([switch]$Project)

$src = Join-Path $PSScriptRoot "skills\architect"
if ($Project) {
    $dest = Join-Path (Get-Location) ".claude\skills\architect"
} else {
    $dest = Join-Path $env:USERPROFILE ".claude\skills\architect"
}

New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
Copy-Item -Recurse $src $dest

Write-Host "Installed /architect to $dest"
$codex = Get-Command codex -ErrorAction SilentlyContinue
if ($codex) {
    Write-Host "Codex CLI found: $(codex --version) (need >= 0.133 for default Goal Mode)"
} else {
    Write-Host "Codex CLI not found - install the builder with: npm i -g @openai/codex@latest"
}
