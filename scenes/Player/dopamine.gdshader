shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float nightness : hint_range(0.0, 1.0) = 0.0;
uniform vec3 night_tint : source_color = vec3(0.08, 0.12, 0.28);

void fragment() {
	vec4 screen_col = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec3 dark_col = screen_col.rgb * night_tint;
	COLOR = vec4(mix(screen_col.rgb, dark_col, nightness), screen_col.a);
}
