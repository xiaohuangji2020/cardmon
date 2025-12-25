```
battle_camera.tscn
CameraRig (Node3D)          <-- 负责【平移】：只在水平地面(XZ轴)移动
  └── CameraPivot (Node3D)  <-- 负责【旋转】：控制仰角(X轴)和水平旋转(Y轴)
		└── Camera3D        <-- 负责【缩放】：只负责前后拉伸(Z轴) 或 调整FOV
```
