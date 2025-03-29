shader_type canvas_item;

uniform float size: hint_range(0.0, 1.0) = 0.5;
uniform float spacing = 20.0;
uniform float angle: hint_range(0.0, 6.28) = 0.785;
uniform float speed: hint_range(0.0, 1.0) = 0.03;
uniform vec3 color1: source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 color2: source_color = vec3(0.0, 0.0, 0.0);

void fragment() {
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

	vec2 grid_uv = mod(aspect_corrected_uv * spacing, 1.0) - 0.5;
	float dist = length(grid_uv);
	float alpha = smoothstep(size-(size*0.01), size-(size*0.01), dot(dist,dist)*4.0);
	COLOR = mix(vec4(color1, 1.), vec4(color2, 1.), alpha);
}