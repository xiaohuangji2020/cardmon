class_name Unit
extends Node2D

# 信号
signal died(unit: Unit)
signal hp_changed(current_hp: int, max_hp: int)

# 静态数据引用
var data: UnitData

# 运行时状态（会随战斗变化）
var current_hp: int = 0
var current_ap: float = 0.0   # 当前行动力，由 CTBSystem 每帧更新
var grid_pos: Vector2i        # 当前所在格子坐标
var has_acted: bool = false   # 本回合是否已使用技能（每回合重置）

# 视觉节点（代码动态创建）
var _body: ColorRect
var _label: Label

# 初始化：传入数据和初始格子位置
func setup(unit_data: UnitData, spawn_pos: Vector2i) -> void:
	data = unit_data
	current_hp = data.max_hp
	grid_pos = spawn_pos
	_build_visuals()

func _build_visuals() -> void:
	# 色块，居中对齐格子
	_body = ColorRect.new()
	var size := Enums.CELL_SIZE - 4
	_body.size = Vector2(size, size)
	_body.position = Vector2(-size * 0.5, -size * 0.5)
	_body.color = data.color
	add_child(_body)
	
	# 名字标签，显示在色块上方
	_label = Label.new()
	_label.text = data.unit_name
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.position = Vector2(-Enums.CELL_SIZE, -Enums.CELL_SIZE - 2)
	_label.size = Vector2(Enums.CELL_SIZE * 2, 8)
	_label.add_theme_font_size_override("font_size", 5)  # 像素风小字
	add_child(_label)

# 由 CTBSystem 每帧调用，回复行动力
func regen_ap(delta: float) -> void:
	if current_ap < Enums.MAX_AP:
		current_ap = min(current_ap + data.speed * delta, Enums.MAX_AP)

func is_ap_full() -> bool:
	return current_ap >= Enums.MAX_AP

# 行动结束后扣除行动力（不归零，快单位保留溢出优势）
func consume_ap(amount: float) -> void:
	current_ap -= amount

# 受到伤害
func take_damage(raw_damage: int) -> void:
	var actual: int = max(raw_damage - data.defense, 1)
	current_hp = max(current_hp - actual, 0)
	emit_signal("hp_changed", current_hp, data.max_hp)
	
	# 简单的受伤视觉反馈（色块闪白）
	_flash_hit()
	
	if current_hp <= 0:
		emit_signal("died", self)

func _flash_hit() -> void:
	_body.color = Color.WHITE
	await get_tree().create_timer(0.1).timeout
	if is_instance_valid(_body):
		_body.color = data.color

# 工具方法
func is_alive() -> bool:
	return current_hp > 0

func is_enemy() -> bool:
	return data.unit_type == Enums.UnitType.ENEMY

func is_ally() -> bool:
	return data.unit_type == Enums.UnitType.PLAYER \
		or data.unit_type == Enums.UnitType.PLAYER_POKEMON \
		or data.unit_type == Enums.UnitType.ALLY \
		or data.unit_type == Enums.UnitType.ALLY_POKEMON
