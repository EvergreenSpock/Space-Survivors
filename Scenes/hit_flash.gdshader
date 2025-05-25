shader_type spatial;
render_mode unshaded, cull_back, depth_draw_opaque;

uniform vec3 base_color : source_color = vec3(0.5);
uniform vec3 flash_color : source_color = vec3(1.0);
uniform float intensity : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	ALBEDO = mix(base_color, flash_color, intensity);
}