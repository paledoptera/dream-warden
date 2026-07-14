shader_type spatial;

render_mode cull_disabled;

uniform sampler2D depths;
uniform sampler2D warden_color;

uniform float scroll_speed =0.1;

void vertex() {
	// Called for every vertex the material is visible on.
	// Hopefully has a PSX effect to it???? 
	VERTEX = intBitsToFloat(floatBitsToInt(VERTEX));
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 normal_sample = texture(warden_color,UV).rgb;
	
	vec2 uv_scroll_1 = UV + scroll_speed * TIME;
	vec2 uv_scroll_2 = UV - scroll_speed * TIME;
	
	vec3 main_warden_color = texture(warden_color,UV).rgb;
	
	vec3 depths_layer_1 = vec3(texture(depths,uv_scroll_1).g*0.3,texture(depths,uv_scroll_1).g*0.5,texture(depths,uv_scroll_1).b);
	vec3 depths_layer_2 = vec3(0.0,texture(depths,uv_scroll_2).g*2.5,texture(depths,uv_scroll_2).b);
	
	vec3 depths_layer_mix = mix(depths_layer_1,depths_layer_2,0.2);
	vec3 color = mix(main_warden_color,depths_layer_mix,depths_layer_mix*0.7);
	
	ALBEDO = color;
	EMISSION = color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
