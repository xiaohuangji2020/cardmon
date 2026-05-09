class_name UnitAI
extends RefCounted   # 不是节点，是纯逻辑类

# 执行 AI 行动，返回值用 await 等待（内部有延迟）
static func run(enemy: Unit, grid_manager: GridManager, all_units: Array[Unit]) -> void:
	# 1. 找最近的我方单位
	var target := _find_nearest_ally(enemy, all_units)
	if target == null:
		return
	
	# 稍作延迟，模拟"思考"，同时让玩家看清楚发生了什么
	await Engine.get_main_loop().create_timer(0.4).timeout
	
	# 2. 计算移动范围，找最靠近目标的格子
	var move_cells: Array[Vector2i] = grid_manager.get_move_range(enemy.grid_pos, enemy.data.move_range)
	var best_cell := _find_best_move(move_cells, target.grid_pos, enemy.grid_pos)
	
	# 3. 移动
	if best_cell != enemy.grid_pos:
		grid_manager.move_unit(enemy, enemy.grid_pos, best_cell)
		enemy.grid_pos = best_cell
		await Engine.get_main_loop().create_timer(0.2).timeout
	
	# 4. 检查是否在攻击范围内
	if enemy.data.skills.is_empty():
		return
	var skill: SkillData = enemy.data.skills[0]
	var attack_cells: Array[Vector2i] = grid_manager.get_attack_range(enemy.grid_pos, skill.atk_range)
	
	if target.grid_pos in attack_cells:
		var damage := skill.damage + enemy.data.attack
		target.take_damage(damage)

# 找最近的我方单位（曼哈顿距离）
static func _find_nearest_ally(enemy: Unit, all_units: Array[Unit]) -> Unit:
	var nearest: Unit = null
	var min_dist := INF
	for unit in all_units:
		if unit.is_ally() and unit.is_alive():
			var dist: int = abs(unit.grid_pos.x - enemy.grid_pos.x) \
					  + abs(unit.grid_pos.y - enemy.grid_pos.y)
			if dist < min_dist:
				min_dist = dist
				nearest = unit
	return nearest

# 在可移动格子里找最靠近目标的一格
static func _find_best_move(move_cells: Array[Vector2i], target: Vector2i, current: Vector2i) -> Vector2i:
	if move_cells.is_empty():
		return current
	var best := current
	var min_dist: int = abs(current.x - target.x) + abs(current.y - target.y)
	for cell in move_cells:
		var dist: int = abs(cell.x - target.x) + abs(cell.y - target.y)
		if dist < min_dist:
			min_dist = dist
			best = cell
	return best
