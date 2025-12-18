# Task Completion Checklist for Cardmon

## After Completing Development Tasks

### Code Quality
- [ ] Code follows GDScript conventions (snake_case, type hints, etc.)
- [ ] Code uses tabs for indentation
- [ ] Comments are clear and explain "why" not "what"
- [ ] No unused variables or imports
- [ ] Type hints are present on all functions

### Testing
- [ ] Test changes in Godot editor (F5 to play)
- [ ] Verify no console errors or warnings
- [ ] Test affected game systems/features
- [ ] Check pixel-perfect rendering still works

### Git & Version Control
- [ ] Changes are committed with descriptive messages
- [ ] Commit message explains the "why" of changes
- [ ] No unintended files are committed
- [ ] Changes are pushed to remote if needed

### File Management
- [ ] No temporary or debug files left behind
- [ ] File encoding is UTF-8
- [ ] Scene files (.tscn) are properly saved
- [ ] Script files (.gd) are properly formatted

### Documentation
- [ ] Complex logic is documented
- [ ] Function purposes are clear from names and type hints
- [ ] Any new systems are documented in comments

## Common Development Tasks

### Adding a New Script
1. Create `.gd` file in appropriate directory
2. Add `extends` declaration
3. Add type hints to all functions
4. Use tabs for indentation
5. Follow naming conventions
6. Test in editor
7. Commit with descriptive message

### Modifying Existing Scripts
1. Read the existing code first
2. Understand the current structure
3. Make minimal changes needed
4. Test thoroughly
5. Verify no regressions
6. Commit changes

### Creating New Scenes
1. Create `.tscn` file
2. Add appropriate root node type
3. Configure nodes and properties
4. Attach scripts if needed
5. Test in editor
6. Save and commit

## Godot Editor Workflow
- Save frequently (Ctrl+S)
- Use F5 to test changes immediately
- Check console for errors
- Use debugger for complex issues
- Reload scripts if needed (Ctrl+R)
