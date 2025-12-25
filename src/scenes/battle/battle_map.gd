extends Node3D

# 获取场景里的那个方块人
# 注意：如果你拖进去的节点名字叫 "Unit2" 或别的，这里要改名
@onready var player_unit: GameUnit = $Unit
@onready var grid_system: Node3D = $GridSystem

const HIGHLIGHT_CELL = preload("res://src/scenes/grid/highlight_cell.tscn")# 2. 存放当前显示的高亮色块，方便以后清理
var selected_unit: GameUnit = null
var current_highlights: Array[Node3D] = []

func _clear_highlights():
	for h in current_highlights:
		h.queue_free()
	current_highlights.clear()

func _unhandled_input(event: InputEvent) -> void:
	# 这是一个临时的测试控制，不是最终的玩法
	# 按键盘的方向键来“跳格子”

	if event.is_action_pressed("ui_up"): # 默认是键盘上箭头
		# 这里的 y-1 其实是 3D 里的 z-1 (向前)
		player_unit.walk_to(player_unit.grid_pos + Vector2i(0, -1))

	elif event.is_action_pressed("ui_down"):
		player_unit.walk_to(player_unit.grid_pos + Vector2i(0, 1))

	elif event.is_action_pressed("ui_left"):
		player_unit.walk_to(player_unit.grid_pos + Vector2i(-1, 0))

	elif event.is_action_pressed("ui_right"):
		player_unit.walk_to(player_unit.grid_pos + Vector2i(1, 0))

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# 1. 射线检测：看点中了什么
			var hit = _do_raycast()
			if hit:
				if hit is GameUnit:
					_on_unit_clicked(hit)
				else:
					_on_floor_clicked(hit)
			else:
				_deselect()

# 射线检测逻辑
func _do_raycast():
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000.0

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)

	return result.collider if result else null

# 当点中一个小人
func _on_unit_clicked(unit: GameUnit):
	_deselect() # 先清除旧的选中
	selected_unit = unit
	print("选中了: ", unit.name)

	# 展示范围
	_draw_range(unit.get_attack_cells(), Color(1, 0.2, 0.2, 0.4)) # 先画大圈红色
	_draw_range(unit.get_move_cells(), Color(0.2, 0.4, 1, 0.5))    # 再画小圈蓝色

# 当点中地板（后续寻路逻辑在此扩展）
func _on_floor_clicked(collider):
	if selected_unit:
		print("已选中单位，准备点击地面寻路...")
		# 这里之后写 A* 寻路和移动逻辑
# 渲染色块
func _draw_range(cells: Array[Vector2i], color: Color):
	for cell in cells:
		var h = HIGHLIGHT_CELL.instantiate()
		add_child(h)
		# 0.02偏移防止Z-Fighting，格子大小2.0
		h.position = Vector3(cell.x * 2.0, 0.02, cell.y * 2.0)

		# 修改颜色
		var mat = StandardMaterial3D.new()
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat.albedo_color = color
		h.material_override = mat

		current_highlights.append(h)

func _deselect():
	selected_unit = null
	for h in current_highlights:
		h.queue_free()
	current_highlights.clear()
