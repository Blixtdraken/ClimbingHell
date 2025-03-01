shader_type spatial;

render_mode unshaded;

uniform sampler2D right: source_color;
uniform sampler2D left: source_color;

uniform vec2 uv_scale = vec2(1);

const float was_size = 1832.0;

uniform float blend_offset = 0.0;
void fragment() {
	float blend = clamp(float(VIEW_INDEX) + blend_offset,0.0,1.0);


	vec2 uv = vec2(SCREEN_UV.x,SCREEN_UV.y);
	ALBEDO =
	texture(left, uv).rgb*(blend)*1.0 +
	texture(right,  uv).rgb*(1.0-blend);



	/*
	ALBEDO=mix(vec3(blend),
	texture(right, SCREEN_UV*uv_scale)
	.rgb*vec3(0,0,1),
	texture(left, SCREEN_UV*uv_scale)
	.rgb*vec3(1,0,0)
	);
	*/


}

void light(){
	//DIFFUSE_LIGHT = vec3(0.45);
}
