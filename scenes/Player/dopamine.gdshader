shader_type canvas_item;
render_mode unshaded;

// Screen texture sampled back through a BackBufferCopy placed before this overlay.
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Both driven by sciemnianie.gd from the current dopamine level.
uniform float brightness : hint_range(0.0, 1.0) = 1.0;
uniform float mono : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec3 col = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	float gray = dot(col, vec3(0.2126, 0.7152, 0.0722));
	col = mix(col, vec3(gray), mono);
	col *= brightness;
	COLOR = vec4(col, 1.0);
}
