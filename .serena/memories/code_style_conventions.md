# Code Style & Conventions for Cardmon

## GDScript Conventions

### Naming Conventions
- **Functions**: `snake_case` (e.g., `_enter_tree()`, `_load_config()`)
- **Variables**: `snake_case` (e.g., `http_server`, `config_path`)
- **Constants**: `UPPER_CASE` or `PascalCase` for class constants (e.g., `const HTTPServer = preload(...)`)
- **Classes**: `PascalCase` (e.g., `HTTPServer`, `ScreenshotManager`)
- **Private functions**: Prefix with `_` (e.g., `_enter_tree()`, `_load_config()`)

### Type Hints
- Always use return type hints: `func name() -> ReturnType:`
- Use type hints for parameters: `func name(param: Type) -> ReturnType:`
- Example: `func _enter_tree() -> void:`

### Indentation & Formatting
- Use **tabs** for indentation (not spaces)
- One statement per line
- Blank lines between logical sections

### Class Structure
- Use `@tool` annotation for editor scripts
- Use `extends` to inherit from base classes
- Preload dependencies at the top: `const ClassName = preload("path/to/file.gd")`
- Declare member variables after constants
- Implement lifecycle methods (_enter_tree, _ready, etc.)

### Comments
- Use `#` for single-line comments
- Keep comments minimal and focused on "why" not "what"
- Document complex logic

### Imports & Preloading
- Preload classes at the top of the file
- Use relative paths with `res://` prefix
- Example: `const HTTPServer = preload("res://addons/godot_mcp_enhanced/http_server.gd")`

## File Organization
- One main class per file
- Related helper classes can be in the same file if small
- Use descriptive filenames matching the main class

## Godot-Specific Patterns
- Use `@tool` for editor plugins
- Use `EditorPlugin` as base for editor extensions
- Use `add_child()` to add nodes to the scene tree
- Use `get_editor_interface()` to access editor functionality

## Character Encoding
- UTF-8 encoding for all files (as specified in .editorconfig)

## Rendering Settings
- Pixel-perfect rendering: `2d/snap/snap_2d_transforms_to_pixel=true`
- Nearest neighbor filtering: `textures/canvas_textures/default_texture_filter=0`
