# Cardmon Project Index

## Project Structure

### Root Files
- `project.godot` - Godot 4.5 project configuration
- `icon.svg` - Project icon
- `README.md` - Project description
- `LICENSE` - License file
- `.editorconfig` - Editor configuration (UTF-8)
- `.gitignore` - Git ignore rules
- `.gitattributes` - Git attributes
- `claude.md` - Claude instructions

### Configuration Files
- `godot_mcp_config.json` - MCP plugin configuration
- `.mcp.json` - MCP server configuration
- `.vscode/settings.json` - VS Code settings

### Main Plugin: Godot MCP Enhanced
Located in `addons/godot_mcp_enhanced/`

#### Core Files
1. **plugin.gd** - Main plugin entry point
   - Extends: EditorPlugin
   - Initializes all MCP systems
   - Manages HTTP server, screenshot manager, scene/script operations
   - Loads configuration from godot_mcp_config.json

2. **http_server.gd** - HTTP server for MCP communication
   - Handles incoming MCP requests
   - Routes requests to appropriate handlers

3. **scene_operations.gd** - Scene manipulation
   - Scene tree operations
   - Node management
   - Scene file operations

4. **script_operations.gd** - Script operations
   - Script creation and editing
   - Script attachment to nodes
   - Script execution

5. **screenshot_manager.gd** - Screenshot capture
   - Captures editor screenshots
   - Captures running game screenshots
   - Screenshot management

6. **debugger_integration.gd** - Debugger integration
   - Debugger communication
   - Runtime debugging support

7. **file_operations.gd** - File operations
   - File read/write
   - Directory operations
   - File management

8. **runtime_operations.gd** - Runtime operations
   - Game execution control
   - Runtime state management
   - Performance monitoring

#### UI
- **ui/bottom_panel.tscn** - Editor bottom panel UI
- **ui/bottom_panel.gd** - Bottom panel script

## Key Systems

### MCP Integration
- HTTP server for remote editor control
- Configuration-driven setup
- Support for scene, script, file, and runtime operations

### Editor Plugin Architecture
- Modular design with separate operation handlers
- Configuration file support
- Bottom panel UI for user interaction

### Rendering Configuration
- Viewport: 640 x 360 pixels
- Pixel-perfect rendering enabled
- Nearest-neighbor texture filtering
- Forward Plus rendering

## File Organization
```
cardmon/
├── addons/
│   └── godot_mcp_enhanced/
│       ├── plugin.gd (main entry)
│       ├── http_server.gd
│       ├── scene_operations.gd
│       ├── script_operations.gd
│       ├── screenshot_manager.gd
│       ├── debugger_integration.gd
│       ├── file_operations.gd
│       ├── runtime_operations.gd
│       └── ui/
│           ├── bottom_panel.gd
│           └── bottom_panel.tscn
├── project.godot
├── godot_mcp_config.json
└── [other config files]
```

## Development Entry Points
- **Main Plugin**: `addons/godot_mcp_enhanced/plugin.gd`
- **HTTP Server**: `addons/godot_mcp_enhanced/http_server.gd`
- **Configuration**: `godot_mcp_config.json`

## Dependencies
- Godot 4.5 engine
- GDScript language
- No external dependencies (pure Godot)
