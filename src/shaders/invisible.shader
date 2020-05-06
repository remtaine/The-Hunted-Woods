shader_type canvas_item;

void fragment() {
	vec4 col = texture(TEXTURE,UV);

	if (!AT_LIGHT_PASS) {
		// Get the color from the texture
		// Compute greyscale color (mean of red, green and blue)
		// Apply greyscale color (same for red, green and blue, then we keep the same alpha)
		COLOR = vec4(texture(TEXTURE, UV).rgb, 0);
	}
	else {
	// For all other fragments
		COLOR = vec4(texture(TEXTURE, UV).rgb, col.a);
	}
}

