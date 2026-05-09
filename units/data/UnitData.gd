class_name UnitData
extends Resource

@export var unit_name: String = "Unknown"
@export var unit_type: Enums.UnitType = Enums.UnitType.ENEMY
@export var max_hp: int = 100
@export var attack: int = 20        # 攻击力，叠加在技能伤害上
@export var defense: int = 5        # 防御，减少受到的伤害
@export var speed: float = 50.0     # 速度，决定 AP 回复快慢
@export var move_range: int = 5     # 最大移动格数
@export var color: Color = Color.GRAY  # 占位色块颜色，有美术后替换
@export var skills: Array[Resource] = []  # 携带的 SkillData 列表
