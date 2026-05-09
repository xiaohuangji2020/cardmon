extends Node

# 子节点引用（在 Battle.tscn 场景里赋值，名称必须一致）
@onready var grid_manager: GridManager = $Grid
@onready var ctb_system: CTBSystem = $CTBSystem
@onready var ctb_bar: Control = $UI/CTBBar
@onready var action_menu: Control = $UI/ActionMenu
@onready var result_label: Label = $UI/ResultLabel

# 状态
var _battle_state: Enums.BattleState = Enums.BattleState.WAITING
var _action_state: Enums.ActionState = Enums.ActionState.IDLE
var _active_unit: Unit = null
var _all_units: Array[Unit] = []

# 缓存当前高亮的格子（用于点击判断）
var _move_cells: Array[Vector2i] = []
var _attack_cells: Array[Vector2i] = []

func _ready() -> void:
	result_label.visible = false
	_spawn_units()
	_connect_signals()
	ctb_system.register_units(_all_units)
	ctb_system.start()

# ── 初始化 ──────────────────────────────────────────────────────

func _spawn_units() -> void:
	# [数据路径, 出生格子]
	var spawn_list := [
		["res://units/data/tres/player.tres",  Vector2i(1, 4)],
		["res://units/data/tres/pikachu.tres", Vector2i(1, 5)],
		["res://units/data/tres/enemy_a.tres", Vector2i(8, 4)],
		["res://units/data/tres/enemy_b.tres", Vector2i(8, 5)],
	]
	
	var unit_scene := preload("res://units/Unit.tscn")
	
	for entry in spawn_list:
		var unit_data: UnitData = load(entry[0])
		var unit: Unit = unit_scene.instantiate()
		add_child(unit)
		unit.setup(unit_data, entry[1])
		grid_manager.place_unit(unit, entry[1])
		unit.connect("died", _on_unit_died)
		ctb_bar.add_unit(unit)
		_all_units.append(unit)

func _connect_signals() -> void:
	ctb_system.unit_ready.connect(_on_unit_ready)
	grid_manager.cell_clicked.connect(_on_cell_clicked)
	action_menu.move_pressed.connect(_on_move_pressed)
	action_menu.skill_pressed.connect(_on_skill_pressed)
	action_menu.wait_pressed.connect(_on_wait_pressed)

# ── CTB 流程 ────────────────────────────────────────────────────

func _on_unit_ready(unit: Unit) -> void:
	_active_unit = unit
	_active_unit.has_acted = false
	
	if unit.is_enemy():
		_battle_state = Enums.BattleState.ENEMY_TURN
		action_menu.hide_menu()
		await UnitAI.run(unit, grid_manager, _all_units)
		_end_turn()
	else:
		_battle_state = Enums.BattleState.PLAYER_TURN
		_action_state = Enums.ActionState.IDLE
		action_menu.show_at(_active_unit.position)

# 回合结束：扣行动力，重置状态，恢复跑条
func _end_turn() -> void:
	if _active_unit:
		_active_unit.consume_ap(Enums.MAX_AP)
	_action_state = Enums.ActionState.IDLE
	_move_cells.clear()
	_attack_cells.clear()
	grid_manager.clear_highlights()
	action_menu.hide_menu()
	_battle_state = Enums.BattleState.WAITING
	ctb_system.resume()

# ── 玩家输入处理 ────────────────────────────────────────────────

func _on_move_pressed() -> void:
	if _battle_state != Enums.BattleState.PLAYER_TURN: return
	_action_state = Enums.ActionState.SELECTING_MOVE
	_move_cells = grid_manager.get_move_range(
		_active_unit.grid_pos, _active_unit.data.move_range)
	grid_manager.highlight_cells(_move_cells, GridManager.COLOR_MOVE)
	action_menu.hide_menu()

func _on_skill_pressed() -> void:
	if _battle_state != Enums.BattleState.PLAYER_TURN: return
	if _active_unit.has_acted:
		return   # 本回合已经用过技能，不允许再次使用
	if _active_unit.data.skills.is_empty():
		return
	_action_state = Enums.ActionState.SELECTING_SKILL
	var skill: SkillData = _active_unit.data.skills[0]
	_attack_cells = grid_manager.get_attack_range(_active_unit.grid_pos, skill.atk_range)
	grid_manager.highlight_cells(_attack_cells, GridManager.COLOR_ATTACK)
	action_menu.hide_menu()

func _on_wait_pressed() -> void:
	_end_turn()

func _on_cell_clicked(grid_pos: Vector2i) -> void:
	if _battle_state != Enums.BattleState.PLAYER_TURN: return
	
	match _action_state:
		Enums.ActionState.SELECTING_MOVE:
			if grid_pos in _move_cells:
				grid_manager.move_unit(_active_unit, _active_unit.grid_pos, grid_pos)
				_active_unit.grid_pos = grid_pos
				_action_state = Enums.ActionState.IDLE
				grid_manager.clear_highlights()
				action_menu.show_at(_active_unit.position)
			# 点击了不可移动的格子：不响应，保持高亮状态
		
		Enums.ActionState.SELECTING_SKILL:
			if grid_pos in _attack_cells:
				var target: Unit = grid_manager.get_unit_at(grid_pos)
				if target != null and target.is_enemy():
					var skill: SkillData = _active_unit.data.skills[0]
					var damage := skill.damage + _active_unit.data.attack
					target.take_damage(damage)
					_active_unit.has_acted = true
					_action_state = Enums.ActionState.IDLE
					grid_manager.clear_highlights()
					action_menu.show_at(_active_unit.position)
		
		Enums.ActionState.IDLE:
			# 无操作状态下点击格子：可以在这里加"选中单位查看信息"功能
			pass

# ── 胜负判断 ────────────────────────────────────────────────────

func _on_unit_died(unit: Unit) -> void:
	grid_manager.remove_unit(unit.grid_pos)
	ctb_system.remove_unit(unit)
	ctb_bar.remove_unit(unit)
	_all_units.erase(unit)
	unit.queue_free()
	_check_battle_over()

func _check_battle_over() -> void:
	var has_ally  := _all_units.any(func(u): return u.is_ally()  and u.is_alive())
	var has_enemy := _all_units.any(func(u): return u.is_enemy() and u.is_alive())
	
	if not has_ally:
		_end_battle("失败")
	elif not has_enemy:
		_end_battle("胜利！")

func _end_battle(text: String) -> void:
	_battle_state = Enums.BattleState.BATTLE_OVER
	ctb_system.stop()
	action_menu.hide_menu()
	result_label.text = text
	result_label.visible = true
