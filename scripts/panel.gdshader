shader_type canvas_item;

uniform float blur_size = 3.0;
uniform int radius = 4;
uniform sampler2D screen_tex : hint_screen_texture;
uniform float desat : hint_range(0.0, 1.0) = 0.15;

void fragment() {
    vec4 col = vec4(0.0);
    float count = 0.0;
    for (int x = -radius; x <= radius; x++) {
        for (int y = -radius; y <= radius; y++) {
            vec2 offset = vec2(float(x), float(y)) * blur_size * SCREEN_PIXEL_SIZE;
            col += texture(screen_tex, SCREEN_UV + offset);
            count += 1.0;
        }
    }
    vec4 blurred = col / count;
    float luma = dot(blurred.rgb, vec3(0.299, 0.587, 0.114));
    vec3 blurred_desat = mix(blurred.rgb, vec3(luma), desat);
    COLOR = vec4(blurred_desat, blurred.a);
}
