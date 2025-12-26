shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_back, unshaded;

uniform vec3 grid_color : source_color = vec3(0.4, 0.4, 0.4);
global uniform float grid_size;
uniform float world_size = 20.0; // 根据地图大小调整

void fragment() {
    vec2 pos = UV * world_size;
    vec2 grid = fract(pos / grid_size);
	vec2 derivative = fwidth(pos / grid_size);
    float line_x = smoothstep(derivative.x, 0.0, grid.x) + smoothstep(1.0 - derivative.x, 1.0, grid.x);
    float line_y = smoothstep(derivative.y, 0.0, grid.y) + smoothstep(1.0 - derivative.y, 1.0, grid.y);
    float mask = clamp(line_x + line_y, 0.0, 1.0);
    ALBEDO = grid_color;
    ALPHA = mask * 0.5;
}