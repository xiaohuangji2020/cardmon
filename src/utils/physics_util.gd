# PhysicsUtil.gd
class_name PhysicsUtil

# 视觉中心的射线检测
#static func raycast_from_viewport_center(world_3d: World3D, camera: Camera3D, distance: float = 100.0, mask: int = 1):
	#var viewport: Viewport = camera.get_viewport()
	#var center = viewport.size / 2
	#var from = camera.project_ray_origin(center)
	#var to = from + camera.project_ray_normal(center) * distance
#
	#var space_state = world_3d.direct_space_state
	#var query = PhysicsRayQueryParameters3D.create(from, to, mask)
	#return space_state.intersect_ray(query)


# 鼠标位置的射线检测
static func mouse_raycast(viewport: Viewport, distance: float = 1000.0):
	#var mouse_pos = get_viewport().get_mouse_position()
	var mouse_pos = viewport.get_mouse_position()
	var camera = viewport.get_camera_3d()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * distance

	var space_state = viewport.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)

	#return result.collider if result else null
	return result.get("collider", null)
