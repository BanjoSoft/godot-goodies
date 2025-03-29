shader_type canvas_item;

uniform float size = 20.0;
uniform float angle: hint_range(0.0, 6.28) = 0.785;
uniform float speed: hint_range(0.0, 1.0) = 0.03;
uniform vec3 color1: source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 color2: source_color = vec3(0.0, 0.0, 0.0);

void fragment() {
	vec2 center = vec2(0.5, 0.5);
	vec2 aspect_corrected_uv = SCREEN_UV;
	aspect_corrected_uv.x *= (SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x);

	float cos_angle = cos(angle);
	float sin_angle = sin(angle);
	mat2 rotation_matrix = mat2(
		vec2(cos_angle, -sin_angle),
		vec2(sin_angle, cos_angle)
	);
	
	aspect_corrected_uv = aspect_corrected_uv * rotation_matrix;
	aspect_corrected_uv += vec2(TIME * speed, 0);
	
	float total = floor(aspect_corrected_uv.x * size) + floor(aspect_corrected_uv.y * size);
	bool isEven = mod(total, 2.0) == 0.0;
	vec4 col1 = vec4(color1.rgb, 1.0);
	vec4 col2 = vec4(color2.rgb, 1.0);
	COLOR = (isEven) ? col1 : col2;
}