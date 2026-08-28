shader_type canvas_item;
uniform vec4 ring_color : source_color = vec4(0.2, 0.6, 1.0, 1.0);
uniform float glow_strength : hint_range(0.0, 3.0) = 1.0;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex = texture(TEXTURE,UV);
	
	vec2 pixel = TEXTURE_PIXEL_SIZE;
	
	float alpha = tex.a;
	
	alpha += texture(TEXTURE, UV + vec2(pixel.x, 0.0)).a;
	alpha += texture(TEXTURE, UV - vec2(pixel.x, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, pixel.y)).a;
	alpha += texture(TEXTURE, UV - vec2(0.0, pixel.y)).a;
	
	alpha /= 5.0;
	

	
	COLOR = vec4(
		ring_color.rgb,
		alpha * glow_strength
		);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
