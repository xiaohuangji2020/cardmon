# Cardmon Project Overview

## Project Purpose
Cardmon is a Godot 3D game project combining:
- Pokémon-style gameplay
- Real-time exploration
- SRPG turn-based grid combat (tactical/strategy RPG)
- CTB (Charge Turn Battle) turn system
- Card-based enhancement mechanics inspired by Digimon 3
- HD-2D pixel art style

## Tech Stack
- **Engine**: Godot 4.5 (Forward Plus rendering)
- **Language**: GDScript
- **Viewport**: 640 x 360 pixels
- **Rendering**: 2D with pixel-perfect snapping
- **Plugins**: Godot MCP Enhanced (for editor integration and MCP server support)

## Project Structure
- `addons/godot_mcp_enhanced/` - MCP plugin for editor integration and remote operations
  - `plugin.gd` - Main plugin entry point
  - `http_server.gd` - HTTP server for MCP communication
  - `scene_operations.gd` - Scene manipulation operations
  - `script_operations.gd` - Script operations
  - `screenshot_manager.gd` - Screenshot capture
  - `debugger_integration.gd` - Debugger integration
  - `file_operations.gd` - File operations
  - `runtime_operations.gd` - Runtime operations
  - `ui/bottom_panel.tscn` - Editor UI panel
- `project.godot` - Godot project configuration
- `.editorconfig` - Editor configuration (UTF-8 charset)

## Code Style & Conventions
- **Language**: GDScript (Godot's Python-like scripting language)
- **Indentation**: Tabs (as seen in plugin.gd)
- **Type Hints**: Used (e.g., `func _enter_tree() -> void:`)
- **Naming**: snake_case for functions and variables, PascalCase for classes
- **Constants**: UPPER_CASE (e.g., `const HTTPServer = preload(...)`)
- **Preloading**: Used for class definitions
- **Annotations**: @tool for editor scripts

## Important Notes
- Project uses Godot 4.5 features
- Pixel-perfect rendering enabled (2d/snap/snap_2d_transforms_to_pixel=true)
- Default texture filter set to nearest (textures/canvas_textures/default_texture_filter=0)
- MCP plugin provides remote editor control capabilities
