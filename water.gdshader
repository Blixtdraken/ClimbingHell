shader_type spatial;


uniform sampler2D lava_texture: source_color;
uniform sampler2D lava_normal: source_color;
uniform sampler2D lava_mask: source_color;

// Scroll direction and speed
uniform vec2 scroll_direction = vec2(0.0, 1.0); // Default to upward scroll
uniform float scroll_speed = 1.0; // Speed of scrolling
uniform vec2 uv_scale = vec2(1.0,1.0);

uniform float waves_height:hint_range(0.0, 1.0, 0.01);
uniform float waves_distort:hint_range(0.0, 1.0, 0.01);
uniform float wave_uv_scale:hint_range(0.0, 0.1, 0.001);
uniform sampler2D wave_noise;

uniform float wave_speed = 1.0;

uniform float distance_fade_min : hint_range(0.0, 4096.0, 0.01);
uniform float distance_fade_max : hint_range(0.0, 4096.0, 0.01);

uniform float scale = 1.0;

uniform float emm_multiplier:hint_range(0.0, 10.0, 0.001);

uniform float snap_multi = 1.0;

uniform vec4 fog_color:source_color;
//varying vec2 delta_vertex;

void vertex(){

	vec2 orig_vertex = VERTEX.xz;
	vec2 snapped_vertex =  round(VERTEX.xz*snap_multi)/snap_multi;
	vec2 node_pos_modulate = vec2(NODE_POSITION_WORLD.xz*snap_multi-vec2(ivec2(NODE_POSITION_WORLD.xz*snap_multi)))/snap_multi;
	VERTEX.xz =snapped_vertex-node_pos_modulate;

	vec2 delta_vertex = orig_vertex - VERTEX.xz;
	vec2 wave_uv_offset = NODE_POSITION_WORLD.xz + VERTEX.xz;
	VERTEX.y += texture(wave_noise,  wave_uv_scale*vec2(wave_speed*TIME+wave_uv_offset)).r*waves_height;

	VERTEX.xz += texture(wave_noise,  wave_uv_scale*vec2(wave_speed*TIME+wave_uv_offset)).r*waves_distort;

	UV += NODE_POSITION_WORLD.xz/scale - delta_vertex/scale;
}
vec3 srgb_to_linear(vec3 c) {
    return pow(c, vec3(2.222)); // Convert sRGB to linear
}
void fragment() {
	vec2 scrolled_uv =(UV + (scroll_direction * scroll_speed * TIME))*uv_scale;
    ALBEDO = texture(lava_texture, scrolled_uv).rgb;

	NORMAL_MAP = texture(lava_normal, scrolled_uv).rgb;
    METALLIC = 0.15 + texture(lava_mask, scrolled_uv).r*0.2;
	ROUGHNESS = 0.15 + (1.0 - texture(lava_mask, scrolled_uv).r)*0.5;
	EMISSION = texture(lava_texture, scrolled_uv).rgb* emm_multiplier;
	SPECULAR = -0.09+(1.0 - texture(lava_mask, scrolled_uv).r)*0.4;
	FOG.rgb = srgb_to_linear(fog_color.rgb);
	FOG.a = pow(1.0 - clamp(smoothstep(distance_fade_min, distance_fade_max, length(VERTEX)), 0.0, 1.0), 1.0/2.2);


}
