class_name SkillData
extends Resource

@export var skill_name: String = "技能"
@export var damage: int = 30       # 基础伤害（不含攻击力加成）
@export var atk_range: int = 1         # 攻击射程，1=只打相邻格
@export var ap_cost: float = 40.0  # 使用后扣除的行动力
