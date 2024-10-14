shader_type canvas_item;

uniform vec3 color: source_color = vec3(1.0);
uniform float amount: hint_range(0.0, 1.0) = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 original_color = texture(TEXTURE, UV).rgb;
	COLOR.rgb = mix(original_color, color, amount);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
