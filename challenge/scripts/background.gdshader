shader_type canvas_item;

uniform vec2 scroll_speed = vec2(0.0, 0.1);

void fragment() {
    vec2 uv = UV - scroll_speed * TIME;
    COLOR = texture(TEXTURE, fract(uv));
}
