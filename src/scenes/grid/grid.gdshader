shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_back, unshaded;

uniform vec3 grid_color : source_color = vec3(0.4, 0.4, 0.4);
uniform float line_thickness : hint_range(0.001, 0.1) = 0.02;
uniform float grid_size = 2.0;
uniform float world_size = 40.0; // 根据地图大小调整

void fragment() {
    vec2 pos = UV * world_size;
    vec2 grid = fract(pos / grid_size);
    float half_thick = line_thickness * 0.5;
    float line_x = smoothstep(half_thick, 0.0, grid.x) + smoothstep(1.0 - half_thick, 1.0, grid.x);
    float line_y = smoothstep(half_thick, 0.0, grid.y) + smoothstep(1.0 - half_thick, 1.0, grid.y);
    float mask = clamp(line_x + line_y, 0.0, 1.0);
    ALBEDO = grid_color;
    ALPHA = mask * 0.5;
}