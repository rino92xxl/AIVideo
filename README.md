# AIVideo

AI-driven video editing with Adobe Premiere Pro, powered by the [Premiere Pro MCP Server](https://github.com/leancoderkavy/premiere-pro-mcp).

This project connects Cursor (or any MCP-compatible AI client) to Premiere Pro so you can edit timelines, apply effects, manage media, and export using natural language.

## Prerequisites

- **Node.js 18+**
- **Adobe Premiere Pro 2020–2025+**
- **Cursor** (or Claude Desktop, Windsurf, etc.)

## Project structure

```
AIVideo/
├── .cursor/mcp.json          # Cursor MCP configuration
├── premiere-pro-mcp/       # Premiere Pro MCP server (MIT, leancoderkavy)
├── scripts/                  # Windows setup helpers
└── README.md
```

## Quick start

### 1. Build the MCP server

```powershell
cd premiere-pro-mcp
npm install
npm run build
```

### 2. Install the CEP panel (Windows)

Run the helper script from the project root:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install-cep-windows.ps1
```

Or manually:

1. Copy `premiere-pro-mcp/cep-plugin` to `%APPDATA%\Adobe\CEP\extensions\MCPBridgeCEP`
2. In Registry Editor, set these `DWORD` values to `1`:
   - `HKEY_CURRENT_USER\Software\Adobe\CSXS.9\PlayerDebugMode`
   - Repeat for CSXS.10 through CSXS.14

### 3. Configure Cursor

MCP is preconfigured in `.cursor/mcp.json`. The bridge temp directory is:

`%LOCALAPPDATA%\Temp\premiere-mcp-bridge`

Create it if it does not exist:

```powershell
New-Item -ItemType Directory -Force -Path "$env:LOCALAPPDATA\Temp\premiere-mcp-bridge"
```

Reload Cursor MCP servers after building (`premiere-pro-mcp/dist/index.js` must exist).

### 4. Start the bridge in Premiere Pro

1. Open (or restart) Premiere Pro
2. Go to **Window → Extensions → MCP Bridge**
3. Set **Temp Directory** to `%LOCALAPPDATA%\Temp\premiere-mcp-bridge`
4. Click **Start Bridge** — status should show green **Running**
5. In Cursor, ask: *"What's my current Premiere Pro project?"*

## Example prompts

- Import all clips from a folder and create a new sequence
- Add cross dissolves between clips on the timeline
- Apply Lumetri color correction to match A-roll
- Export the active sequence as 1080p H.264

## MCP capabilities

The bundled MCP server exposes **269 tools** across 28 modules: project/sequence management, timeline editing, effects, keyframes, audio, captions, export, and more.

See `premiere-pro-mcp/README.md` for full documentation.

## Git setup

This repo is ready to push to a remote:

```powershell
git init
git add .
git commit -m "Initial AIVideo project with Premiere Pro MCP"
git remote add origin <your-repo-url>
git push -u origin main
```

## Credits

- [leancoderkavy/premiere-pro-mcp](https://github.com/leancoderkavy/premiere-pro-mcp) — MIT License

## License

The `premiere-pro-mcp` subdirectory is licensed under MIT (see `premiere-pro-mcp/LICENSE`). Add your own license for project-specific code as needed.
