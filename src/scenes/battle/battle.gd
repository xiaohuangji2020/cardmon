extends Node3D

# 获取场景里的那个方块人
# 注意：如果你拖进去的节点名字叫 "Unit2" 或别的，这里要改名
@onready var player_unit: GameUnit = $Unit
@onready var grid_system: Node3D = $GridSystem

var selected_unit: GameUnit = null

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
			var hit = PhysicsUtil.mouse_raycast(get_viewport())
			if hit:
				if hit is GameUnit:
					_on_unit_clicked(hit)
				else:
					_on_floor_clicked(hit)
			else:
				_deselect()


# 当点中一个小人
func _on_unit_clicked(unit: GameUnit):
	grid_system.clear_all() # 先清除旧的选中
	selected_unit = unit
	print("选中了: ", unit.name)

	# 展示范围
	grid_system.display_range(unit.get_attack_cells(), 'attack') # 先画大圈红色
	grid_system.display_range(unit.get_move_cells(), '')    # 再画小圈蓝色

# 当点中地板（后续寻路逻辑在此扩展）
func _on_floor_clicked(collider):
	if selected_unit:
		print("已选中单位，准备点击地面寻路...", collider)
		# 这里之后写 A* 寻路和移动逻辑

func _deselect():
	grid_system.clear_all() # 先清除旧的选中
