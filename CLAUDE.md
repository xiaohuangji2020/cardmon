# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 提供在此仓库中工作时的指导。

## 重要说明
使用中文回复我
当编辑或者添加新功能后需要更新本文件，以及其关联的子文件

## 项目概述

**elomon**（代号：cardmon / 宝可梦战棋）是一个用 Godot 4.6 开发的宝可梦风格战棋 RPG 原型。战斗在 20×20 网格上进行，采用 CTB（Charge Time Battle）系统——每个单位根据自身速度持续积累行动力（AP），达到 100 时轮到该单位行动。

## 运行游戏

用 Godot 4.6 编辑器打开项目，按 F5（运行项目）。主场景为 `battle/Battle.tscn`。

`addons/godot_mcp` 是编辑器自动化插件，与游戏逻辑无关。

## 核心系统一览

| 系统 | 入口文件 | 职责 |
|------|----------|------|
| 战斗循环 | `battle/BattleManager.gd` | 协调所有子系统，驱动回合状态机 |
| CTB 计时 | `battle/ctb/CTBSystem.gd` | 每帧累加 AP，AP 满时暂停并通知 |
| 网格 | `grid/GridManager.gd` | 管理单位位置、移动/攻击范围计算、点击事件 |
| 单位运行时 | `units/Unit.gd` | HP、AP、格子位置等动态状态 |
| 单位静态数据 | `units/data/UnitData.gd` | 属性、技能列表（`.tres` 实例） |
| 敌方 AI | `units/UnitAI.gd` | 无状态静态类，靠近并攻击最近的我方单位 |
| 全局枚举/常量 | `core/Enums.gd` | `UnitType`、`BattleState`、`ActionState`、网格常量 |

## 详细文档

- [架构详解](.claude/architecture.md) — 各系统的实现细节与数据流
- [关键约定](.claude/conventions.md) — 坐标系、AP 经济、节点命名等开发约定
