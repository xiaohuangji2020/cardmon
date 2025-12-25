# Cardmon 架构设计文档

## 项目概述

一款融合宝可梦收集、SRPG战棋、实时探索和卡牌系统的 HD-2D 像素风格游戏。

- **引擎**: Godot 4.5
- **语言**: GDScript
- **视口**: 640 x 360
- **像素密度**: 1.0m = 32px

---

## 架构分析

### 设计原则

1. **领域驱动设计 (DDD)**: 按功能模块分类，而非文件类型
2. **组件化**: 使用组合优于继承，提高代码复用
3. **数据分离**: 静态数据（Resource）与运行时实例分离
4. **事件驱动**: 使用信号（Signal）和事件总线解耦系统

### 核心系统依赖关系

```
EventBus (事件总线)
    ↓
┌───────────────────────────────────────┐
│           Core Components             │
│  (Health, Stats, Buff, Position)      │
└───────────────────────────────────────┘
    ↓
┌───────────────────────────────────────┐
│           Grid System                 │
│  (网格数据、寻路、地形)                 │
└───────────────────────────────────────┘
    ↓
┌───────────────────────────────────────┐
│           Unit System                 │
│  (玩家、宝可梦、AI)                    │
└───────────────────────────────────────┘
    ↓
┌───────────────────────────────────────┐
│           Turn System (CTB)           │
│  (行动力、回合队列、透支)               │
└───────────────────────────────────────┘
    ↓
┌───────────────────────────────────────┐
│           Battle System               │
│  (技能、伤害、胜负判定)                 │
└───────────────────────────────────────┘
    ↓
┌───────────────────────────────────────┐
│           Card System                 │
│  (指令卡、刷卡、锻造)                   │
└───────────────────────────────────────┘
    ↓
┌───────────────────────────────────────┐
│           Exploration System          │
│  (实时探索、明雷、交互)                 │
└───────────────────────────────────────┘
```

---

## 项目目录结构

```
res://
├── autoload/                    # 全局单例（Autoload）
│   ├── event_bus.gd            # 事件总线
│   ├── game_manager.gd         # 游戏状态管理
│   └── save_manager.gd         # 存档管理
│
├── core/                        # 核心框架
│   ├── constants/              # 常量定义
│   │   ├── enums.gd           # 枚举（属性、状态等）
│   │   └── formulas.gd        # 伤害公式、数值常量
│   ├── utils/                  # 工具类
│   │   ├── grid_utils.gd      # 网格算法（A*寻路等）
│   │   └── math_utils.gd      # 数学工具
│   └── components/             # 通用组件
│       ├── health_component.gd
│       ├── stats_component.gd
│       ├── buff_component.gd
│       └── grid_object.gd     # 网格对象基类
│
├── gameplay/                    # 游戏玩法
│   ├── battle/                 # 战斗系统
│   │   ├── grid/              # 网格系统
│   │   │   ├── battle_grid.gd        # 战斗网格管理
│   │   │   ├── grid_cell.gd          # 格子数据
│   │   │   └── grid_renderer.gd      # 网格渲染
│   │   ├── turn/              # CTB回合管理
│   │   │   ├── turn_manager.gd       # 回合管理器
│   │   │   ├── action_queue.gd       # 行动队列
│   │   │   └── action_point.gd       # 行动力系统
│   │   ├── skills/            # 技能系统
│   │   │   ├── skill_executor.gd     # 技能执行器
│   │   │   ├── damage_calculator.gd  # 伤害计算
│   │   │   └── skill_effects/        # 技能效果
│   │   └── referee.gd         # 胜负判定
│   │
│   ├── units/                  # 单位系统
│   │   ├── base_unit.gd       # 单位基类
│   │   ├── player/            # 玩家
│   │   │   ├── player_unit.gd
│   │   │   ├── sync_rate.gd          # 同步率系统
│   │   │   └── talent_tree.gd        # 天赋树
│   │   ├── pokemon/           # 宝可梦
│   │   │   ├── pokemon_unit.gd
│   │   │   ├── evolution.gd          # 进化系统
│   │   │   └── capture.gd            # 捕捉系统
│   │   └── ai/                # AI行为
│   │       ├── battle_ai.gd
│   │       └── exploration_ai.gd
│   │
│   ├── cards/                  # 卡牌系统
│   │   ├── card_manager.gd    # 卡牌管理
│   │   ├── card_effects/      # 卡牌效果
│   │   └── forge/             # 锻造系统
│   │       ├── forge_manager.gd
│   │       └── modules/       # 锻造模组
│   │
│   ├── terrain/                # 地形系统
│   │   ├── terrain_manager.gd
│   │   └── terrain_effects/   # 地形效果
│   │
│   ├── weather/                # 天气系统
│   │   └── weather_manager.gd
│   │
│   └── exploration/            # 探索系统
│       ├── exploration_controller.gd
│       ├── interaction/       # 交互
│       └── spawning/          # 明雷刷新
│
├── data/                        # 数据定义（Resource）
│   ├── pokemon/                # 宝可梦数据
│   │   ├── pokemon_data.gd    # 宝可梦数据类
│   │   └── species/           # 各种族数据 .tres
│   ├── skills/                 # 技能数据
│   │   ├── skill_data.gd
│   │   └── definitions/       # 技能定义 .tres
│   ├── cards/                  # 卡牌数据
│   │   ├── card_data.gd
│   │   └── definitions/       # 卡牌定义 .tres
│   ├── terrains/               # 地形数据
│   │   └── terrain_data.gd
│   └── type_chart.tres         # 属性克制表
│
├── scenes/                      # 场景文件
│   ├── main/                   # 主场景
│   │   └── main.tscn
│   ├── battle/                 # 战斗场景
│   │   └── battle_scene.tscn
│   ├── exploration/            # 探索场景
│   │   └── exploration_scene.tscn
│   └── test/                   # 测试场景
│
├── assets/                      # 资源文件
│   ├── sprites/                # 精灵图
│   │   ├── characters/        # 角色（纸娃娃部件）
│   │   ├── pokemon/           # 宝可梦
│   │   ├── effects/           # 特效
│   │   └── ui/                # UI图标
│   ├── audio/                  # 音频
│   │   ├── bgm/
│   │   └── sfx/
│   ├── fonts/                  # 字体
│   └── shaders/                # 着色器
│       └── billboard.gdshader # Billboard着色器
│
├── ui/                          # UI系统
│   ├── battle/                 # 战斗UI
│   │   ├── battle_hud.tscn
│   │   ├── turn_order_bar.tscn
│   │   └── card_panel.tscn
│   ├── exploration/            # 探索UI
│   └── common/                 # 通用UI组件
│
├── addons/                      # 插件（已有 godot_mcp_enhanced）
│
└── docs/                        # 文档（已有）
```

---

## 关键设计决策

### 1. 静态数据 vs 运行时实例

```gdscript
# 静态数据（Resource）- 图鉴数据
class_name PokemonData extends Resource
@export var species_id: int
@export var base_stats: Dictionary  # HP, ATK, DEF, SPATK, SPDEF, SPD
@export var types: Array[Enums.ElementType]
@export var learnable_skills: Array[SkillData]

# 运行时实例 - 具体的一只宝可梦
class_name PokemonInstance extends RefCounted
var data: PokemonData  # 引用静态数据
var current_hp: int
var level: int
var learned_skills: Array[SkillData]
var buffs: Array[Buff]
```

### 2. 组件化设计

```gdscript
# 通用组件可被任何单位使用
class_name HealthComponent extends Node
signal health_changed(current, max_hp)
signal died

var max_hp: int
var current_hp: int

func take_damage(amount: int) -> void:
    current_hp = max(0, current_hp - amount)
    health_changed.emit(current_hp, max_hp)
    if current_hp <= 0:
        died.emit()
```

### 3. 事件总线

```gdscript
# autoload/event_bus.gd
extends Node

signal battle_started
signal turn_changed(unit)
signal unit_moved(unit, from_pos, to_pos)
signal skill_used(caster, skill, targets)
signal terrain_changed(cell, old_type, new_type)
signal sync_rate_changed(new_value)
```

### 4. CTB 行动力系统

```gdscript
# 时间片机制
class_name ActionQueue extends Node

var units: Array[BaseUnit]
var tick: int = 0

func get_next_unit() -> BaseUnit:
    # 按行动力排序，返回最先行动的单位
    units.sort_custom(func(a, b): return a.next_action_tick < b.next_action_tick)
    return units[0]

func schedule_next_action(unit: BaseUnit, ap_cost: int) -> void:
    var delay = calculate_delay(unit.stats.speed, ap_cost)
    unit.next_action_tick = tick + delay

    # 透支惩罚
    if unit.action_points < 0:
        unit.next_action_tick += EXHAUSTION_PENALTY
        unit.add_buff(Buffs.EXHAUSTED)
```

---

## 技术要点

### HD-2D 实现

1. **Billboard Sprite3D**: 使用 `billboard` 模式让2D精灵始终面向摄像机
2. **正交摄像机**: 使用 Orthogonal 投影模拟2D视角
3. **像素完美**: 设置 viewport 为 640x360，使用 nearest 过滤

### 纸娃娃系统

```gdscript
# 角色由多个 Sprite3D 组成
# - body (身体)
# - head (头部)
# - weapon (武器)
# 换装只需替换对应的 texture
```

### 网格系统

```gdscript
class_name GridCell extends RefCounted
var position: Vector2i
var terrain_type: Enums.TerrainType
var terrain_state: Enums.TerrainState  # 燃烧、结冰等
var occupant: BaseUnit
var height: int
var movement_cost: int  # 寻路权值
```

---

## 风险与注意事项

1. **HD-2D 渲染**: 需要早期验证 Billboard + 像素完美的效果
2. **CTB 复杂度**: 行动力透支、打断、插队需要仔细设计优先级队列
3. **同步率平衡**: 产出/消耗需要大量测试调整
4. **地形交互**: 元胞自动机式的地形传播需要性能优化
5. **AI 复杂度**: 战棋AI评估函数需要迭代优化
