shader_type canvas_item;
render_mode unshaded;

// Screen texture sampled with nearest filtering - no smoothing, so pixels stay chunky.
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

// 0.0 = fully sane, 1.0 = dopamine empty. Driven by sciemnianie.gd.
uniform float horror : hint_range(0.0, 1.0) = 0.0;
uniform float pixel_scale : hint_range(1.0, 8.0) = 2.0;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// Classic 4x4 Bayer matrix without a texture lookup.
float bayer2(vec2 a) {
	a = floor(a);
	return fract(a.x / 2.0 + a.y * a.y * 0.75);
}

float bayer4(vec2 a) {
	return bayer2(a * 0.5) * 0.25 + bayer2(a);
}

void fragment() {
	// Snap every lookup to a pixel grid.
	vec2 px = SCREEN_PIXEL_SIZE * pixel_scale;
	vec2 uv = (floor(SCREEN_UV / px) + 0.5) * px;

	// Blocky horizontal tears - offsets are whole screen pixels.
	float slice = floor(uv.y / (8.0 * px.y));
	float tick = floor(TIME * 7.0);
	float tear = step(1.0 - 0.16 * horror, hash(vec2(slice, tick)));
	uv.x += (hash(vec2(slice + 19.0, tick)) - 0.5) * 32.0 * px.x * tear * horror;
	uv = clamp(uv, px * 0.5, vec2(1.0) - px * 0.5);

	vec3 col = texture(SCREEN_TEXTURE, uv).rgb;

	// Drain the colour.
	float gray = dot(col, vec3(0.2126, 0.7152, 0.0722));
	col = mix(col, vec3(gray), horror);

	// Crimson creeps into what shadows remain.
	col = mix(col, vec3(0.22, 0.0, 0.03), horror * (1.0 - gray) * 0.8);

	// Ordered dithering into a shrinking palette - retro crunch, no blur.
	float levels = mix(256.0, 4.0, horror);
	float dither = (bayer4(floor(uv / px)) - 0.5) * horror / levels;
	col = floor((col + dither) * levels + 0.5) / levels;

	// Stepped vignette - the dark closes in.
	vec2 centered = (uv - 0.5) * vec2(SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, 1.0);
	float vignette = 1.0 - smoothstep(0.25, 0.95, length(centered));
	vignette = floor(vignette * 8.0 + 0.5) / 8.0;
	col *= mix(1.0, vignette, horror);

	// Hard scanlines.
	float scan = mod(floor(uv.y / (2.0 * px.y)), 2.0);
	col *= mix(1.0, mix(0.85, 1.0, scan), horror);

	// Heartbeat and sparse static snow.
	float beat = pow(max(0.0, sin(TIME * 5.5)), 16.0);
	col.r += beat * horror * 0.12;

	vec2 cell = floor(uv / (3.0 * px));
	float snow = step(1.0 - 0.02 * horror, hash(cell + floor(TIME * 16.0)));
	col = mix(col, vec3(0.9), snow * horror * 0.8);

	COLOR = vec4(clamp(col, 0.0, 1.0), 1.0);
}
