# 语法错误记录本

记录开发过程中出现的语法错误，避免重复犯错。

---

## Godot 场景文件 (.tscn)

### 错误1：使用 preload() 而不是 ExtResource

**错误代码：**
```gdscript
texture = preload("res://icon.svg")
```

**错误信息：**
```
Parse Error: Parse error. [Resource file res://scenes/test/hd2d_test.tscn:26]
```

**正确写法：**
```gdscript
# 在文件头部声明资源
[ext_resource type="Texture2D" uid="uid://cqvvxqweeyc06" path="res://icon.svg" id="2_icon"]

# 在节点中引用
texture = ExtResource("2_icon")
```

**原因：**
.tscn 文件是序列化格式，不支持 `preload()` 函数调用，必须使用 `ExtResource` 引用。

---

## GDScript 类型推断

### 错误2：类型推断失败导致 Variant 警告

**错误代码：**
```gdscript
var delta_mouse := event.position - last_mouse_pos
var current_rotation := rotation.x
```

**错误信息：**
```
Cannot infer the type of "delta_mouse" variable because the value doesn't have a set type.
The variable type is being inferred from a Variant value, so it will be typed as Variant.
```

**正确写法：**
```gdscript
var delta_mouse: Vector2 = event.position - last_mouse_pos
var current_rotation: float = rotation.x
```

**原因：**
GDScript 的类型推断在某些情况下会失败，特别是：
- 从 Variant 类型推断时
- 复杂表达式的结果类型不明确时

**最佳实践：**
使用显式类型声明 `var name: Type = value` 而不是类型推断 `var name := value`，特别是在：
- 从属性访问（如 `rotation.x`）获取值时
- 从事件对象获取值时
- 类型不明显的表达式时
