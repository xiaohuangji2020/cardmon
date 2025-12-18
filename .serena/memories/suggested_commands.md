# Suggested Commands for Cardmon Development

## Godot Editor
- Open Godot editor: `godot` (from project root)
- Run the game: Press F5 in editor or use Scene > Play
- Run specific scene: Select scene and press F6

## Git Commands
- Check status: `git status`
- View recent commits: `git log --oneline -10`
- Create commit: `git add . && git commit -m "message"`
- Push changes: `git push origin master`

## File Navigation
- List directory contents: `ls -la`
- Find GDScript files: `find . -name "*.gd"`
- Find scene files: `find . -name "*.tscn"`
- Search in files: `grep -r "pattern" --include="*.gd"`

## Project Structure Navigation
- Main plugin: `addons/godot_mcp_enhanced/plugin.gd`
- Project config: `project.godot`
- Game icon: `icon.svg`

## Development Workflow
1. Make changes to GDScript files
2. Save files (Godot auto-reloads)
3. Test in editor (F5)
4. Commit changes with git
5. Push to remote

## Useful Godot Shortcuts
- F5: Play current scene
- F6: Play selected scene
- F7: Play custom scene
- Ctrl+S: Save scene
- Ctrl+Shift+S: Save all
