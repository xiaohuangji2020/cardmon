# Cardmon Project Overview

## Purpose
Cardmon is a Godot 4.5 game project with an integrated MCP (Model Context Protocol) enhanced plugin for AI assistant integration.

## Tech Stack
- **Engine**: Godot 4.5 (Forward Plus rendering)
- **Language**: GDScript (Godot scripting language)
- **MCP Integration**: godot_mcp_enhanced plugin v1.0.0
- **Configuration**: JSON-based config (godot_mcp_config.json)

## Project Structure
```
cardmon/
├── addons/
│   └── godot_mcp_enhanced/
│       ├── plugin.gd (main plugin entry point)
│       ├── plugin.cfg (plugin metadata)
│       ├── http_server.gd (HTTP server for MCP)
│       ├── file_operations.gd
│       ├── script_operations.gd
│       ├── scene_operations.gd
│       ├── runtime_operations.gd
│       ├── debugger_integration.gd
│       ├── screenshot_manager.gd
│       ├── python/ (Python MCP server components)
│       └── ui/ (UI components including bottom_panel.gd)
├── godot_mcp_config.json (MCP configuration)
├── project.godot (Godot project config)
└── icon.svg (project icon)
```

## MCP Configuration
- MCP Server Port: 3571
- Runtime Server Port: 3572
- Auto Screenshot: enabled
- Screenshot on Error: enabled
- Screenshot on Scene Change: enabled

## Code Style & Conventions
- GDScript (Godot's Python-like scripting language)
- File naming: snake_case.gd for scripts
- Plugin architecture with modular components
