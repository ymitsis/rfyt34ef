shader_type canvas_item;
uniform float shadow_alpha : hint_range(0.0, 1.0) = 0.55;
uniform float transition : hint_range(0.0, 0.5) = 0.12;
uniform float boundary : hint_range(0.0, 1.0) = 0.5;
uniform vec2 light_dir = vec2(1.0, -1.0);

varying vec2 wpos;
varying vec2 wcenter;
varying float wrange;

void vertex() {
	wpos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	wcenter = (MODEL_MATRIX * vec4(vec2(0.0), 0.0, 1.0)).xy;
	vec2 tex_size = vec2(1.0) / TEXTURE_PIXEL_SIZE;
	vec2 half_size = tex_size * 0.5;
	wrange = max(length((MODEL_MATRIX * vec4(half_size, 0.0, 0.0)).xy), 0.001);
}

void fragment() {
	vec4 col = texture(TEXTURE, UV) * COLOR;
	vec2 dir = normalize(light_dir);
	float t = dot(wpos - wcenter, dir) / wrange;
	float shade01 = clamp(0.5 + 0.5 * t, 0.0, 1.0);
	float shadow_factor;
	if (transition <= 0.0001) {
		shadow_factor = 1.0 - step(boundary, shade01);
	} else {
		shadow_factor = 1.0 - smoothstep(boundary - transition, boundary + transition, shade01);
	}

	float a = clamp(shadow_factor * shadow_alpha, 0.0, 1.0);
	col.rgb = mix(col.rgb, vec3(0.0), a);

	COLOR = col;
}
