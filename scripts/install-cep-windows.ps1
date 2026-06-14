# Install MCP Bridge CEP plugin for Premiere Pro (Windows)
param(
    [switch]$Copy
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$PluginSrc = Join-Path $ProjectRoot "premiere-pro-mcp\cep-plugin"
$PluginName = "MCPBridgeCEP"
$CepDir = Join-Path $env:APPDATA "Adobe\CEP\extensions"
$Dest = Join-Path $CepDir $PluginName

Write-Host "=== MCP Bridge CEP Plugin Installer (Windows) ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Source:      $PluginSrc"
Write-Host "Destination: $Dest"
Write-Host ""

if (-not (Test-Path $PluginSrc)) {
    throw "CEP plugin source not found at $PluginSrc. Clone/build premiere-pro-mcp first."
}

New-Item -ItemType Directory -Force -Path $CepDir | Out-Null

if (Test-Path $Dest) {
    Write-Host "Removing existing installation..."
    Remove-Item -Recurse -Force $Dest
}

if ($Copy) {
    Write-Host "Copying plugin files..."
    Copy-Item -Recurse -Force $PluginSrc $Dest
} else {
    Write-Host "Creating directory junction (development mode)..."
    cmd /c mklink /J "$Dest" "$PluginSrc" | Out-Null
}

# Enable unsigned CEP extensions (CSXS 9-14)
$csxsVersions = 9..14
foreach ($version in $csxsVersions) {
    $keyPath = "HKCU:\Software\Adobe\CSXS.$version"
    if (-not (Test-Path $keyPath)) {
        New-Item -Path $keyPath -Force | Out-Null
    }
    Set-ItemProperty -Path $keyPath -Name "PlayerDebugMode" -Value 1 -Type DWord
    Write-Host "Enabled PlayerDebugMode for CSXS.$version"
}

Write-Host ""
Write-Host "Installation complete." -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Restart Premiere Pro"
Write-Host "  2. Window > Extensions > MCP Bridge"
Write-Host "  3. Set temp dir to: $env:LOCALAPPDATA\Temp\premiere-mcp-bridge"
Write-Host "  4. Click Start Bridge"
Write-Host "  5. Use Cursor with .cursor/mcp.json in this project"
