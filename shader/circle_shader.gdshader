shader_type canvas_item;

uniform float circle_size : hint_range(0.0, 1.5) = 0.0;

uniform float smooth_size = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	
	vec2 dist = UV - vec2(0.5, 0.5);
	
	dist.x *= ratio;
	
	float len = length(dist);
	
	float alpha = smoothstep(circle_size - smooth_size, circle_size, len);
	
	COLOR = vec4(0.0, 0.0, 0.0, alpha);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
