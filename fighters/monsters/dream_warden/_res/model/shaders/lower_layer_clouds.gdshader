shader_type spatial;

uniform sampler2D cloud_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
	vec3 view_dir = normalize(CAMERA_POSITION_WORLD - world_pos);
	
	vec2 uv = UV;
	
	vec3 clouds = texture(cloud_texture,uv).rgb;
	
	ALBEDO = clouds;
	ALPHA = clouds.r;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
