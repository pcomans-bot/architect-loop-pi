param([switch]$Project)

$srcRoot = Join-Path $PSScriptRoot "skills"
if ($Project) {
    $destRoot = Join-Path (Get-Location) ".claude\skills"
} else {
    $destRoot = Join-Path $env:USERPROFILE ".claude\skills"
}

New-Item -ItemType Directory -Force $destRoot | Out-Null
foreach ($skill in Get-ChildItem -Directory $srcRoot) {
    $dest = Join-Path $destRoot $skill.Name
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Copy-Item -Recurse $skill.FullName $dest
    Write-Host "Installed /$($skill.Name) to $dest"
}

# Builder: pi pointed at a cheap model (DeepSeek by default).
$pi = Get-Command pi -ErrorAction SilentlyContinue
if ($pi) {
    Write-Host "pi found: $(pi --version)"
    # web_search tool: pi-search-hub. Fail loudly — researchers depend on web_search.
    pi install npm:pi-search-hub
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Installed pi-search-hub (web_search tool)"
    } else {
        Write-Warning "Failed to install pi-search-hub (web_search for researchers). Fix the error above, then run: pi install npm:pi-search-hub"
    }
} else {
    Write-Host "pi not found - install the builder: npm i -g --ignore-scripts @earendil-works/pi-coding-agent@latest"
    Write-Host "  then re-run .\install.ps1 (it installs pi-search-hub for web_search)"
}

# Keyless DuckDuckGo (the default web_search backend) needs the `ddgs` Python pkg.
# We don't auto-install it (no global pip mutation) — just say so if it's missing.
python -c "import ddgs" 2>$null
if ($LASTEXITCODE -ne 0) { Write-Host "NOTE: keyless DuckDuckGo search needs the 'ddgs' package - run: pip install ddgs" }

Write-Host "Set your builder key:  `$env:DEEPSEEK_API_KEY=sk-...           (see skills/architect/dispatch.md to switch models)"
Write-Host "Optional better search: `$env:SEARCH_TAVILY_API_KEY=tvly-...     (else web_search uses keyless DuckDuckGo)"
Write-Host "Optional hardening:     npm config set min-release-age 4        (season npm installs; see README)"
