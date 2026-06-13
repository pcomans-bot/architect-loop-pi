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
    # web_search tool: pi-search-hub (keyless DuckDuckGo by default; Tavily etc. optional)
    pi install npm:pi-search-hub *> $null; Write-Host "Installed pi-search-hub (web_search tool)"
} else {
    Write-Host "pi not found - install the builder: npm i -g --ignore-scripts @earendil-works/pi-coding-agent, then: pi install npm:pi-search-hub"
}
# Keyless DuckDuckGo search needs the ddgs Python package
if (Get-Command pip -ErrorAction SilentlyContinue) { pip install --quiet ddgs *> $null }
Write-Host "Set your builder key:  `$env:DEEPSEEK_API_KEY=sk-...   (see skills/architect/dispatch.md to switch models)"
Write-Host "Optional better search: `$env:TAVILY_API_KEY=tvly-...  (else web_search uses keyless DuckDuckGo)"
