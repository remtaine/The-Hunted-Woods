shader_type canvas_item;

void fragment() {
	vec4 col = texture(TEXTURE,UV);

	if (!AT_LIGHT_PASS) {
		// Get the color from the texture
		// Compute greyscale color (mean of red, green and blue)
		float grey = (col.r + col.g + col.b) * 0.06;

		// Apply greyscale color (same for red, green and blue, then we keep the same alpha)
		COLOR = vec4(grey, grey, grey, col.a);
	}
	else {
	// For all other fragments
		COLOR = vec4(texture(TEXTURE, UV).rgb, col.a);
	}
}