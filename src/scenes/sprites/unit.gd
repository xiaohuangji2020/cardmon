extends CharacterBody3D
class_name GameUnit  # 给个类名，方便以后其他脚本识别它

# --- 配置参数 ---
# 移动速度 (做动画用)
@export var move_speed: float = 5.0
# 格子大小 (必须和你的地面网格匹配)
const GRID_SIZE: float = 2.0

# --- 核心状态 ---
# 逻辑坐标：它现在在第几行第几列？
var grid_pos: Vector2i = Vector2i(0, 0)

# 目标世界坐标：动画要飘去哪里？
var target_world_pos: Vector3

# --- 标记状态 ---
var is_moving: bool = false
@export var move_range: int = 4    # 移动力
@export var attack_range: int = 2  # 攻击距离

func _ready() -> void:
	# 初始化：把单位瞬间摆放到由于 grid_pos 决定的位置
	position = grid_to_world(grid_pos)
	target_world_pos = position

func _process(delta: float) -> void:
	if is_moving:
		# 平滑移动逻辑：一步步向目标靠近
		# move_toward 是 Godot 处理数值移动的神器
		var current_pos = position
		# 只在水平面移动，保持 Y 轴不变 (防止脚离地)
		var new_pos = current_pos.move_toward(target_world_pos, move_speed * delta)

		position = new_pos

		# 检查是否这就到了？(距离极小时算到达)
		if position.distance_to(target_world_pos) < 0.01:
			position = target_world_pos # 强制归位，消除浮点误差
			is_moving = false
			print("到达格子: ", grid_pos)

# --- 核心功能：移动指令 ---
# 外部调用这个函数，让它走
func walk_to(new_grid_pos: Vector2i):
	if is_moving:
		return # 正在走的时候别打断

	grid_pos = new_grid_pos
	# 算出 3D 世界哪里是终点
	target_world_pos = grid_to_world(grid_pos)
	# 简单的朝向逻辑：让方块脸朝向目标
	look_at(target_world_pos)
	# 修正 look_at 可能导致的歪头（锁住X和Z旋转）
	rotation.x = 0
	rotation.z = 0

	is_moving = true

# --- 工具函数：翻译官 ---
# 输入 (1, 2) -> 输出 Vector3(2.0, 0.0, 4.0)
func grid_to_world(g_pos: Vector2i) -> Vector3:
	var x = g_pos.x * GRID_SIZE
	var z = g_pos.y * GRID_SIZE # 注意：2D的y对应3D的z
	return Vector3(x, 0.0, z)

# Unit.gd

# 计算移动范围（曼哈顿距离）
func get_move_cells() -> Array[Vector2i]:
	return _calculate_manhattan_cells(move_range)

# 计算攻击范围（基于移动范围外扩）
func get_attack_cells() -> Array[Vector2i]:
	# 这里逻辑：移动范围边缘再往外扩攻击距离
	# 简单演示：只算以当前位置为中心的攻击范围
	return _calculate_manhattan_cells(move_range + attack_range)

# 计算曼哈顿距离下的所有可到达格子
# 内部通用曼哈顿距离计算：$d = |x_1 - x_2| + |y_1 - y_2|$
func _calculate_manhattan_cells(radius: int) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			if abs(x) + abs(y) <= radius:
				cells.append(grid_pos + Vector2i(x, y))
	return cells
