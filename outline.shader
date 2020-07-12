shader_type spatial;
render_mode cull_front, unshaded, ambient_light_disabled;

uniform float outline_thickness : hint_range(0.0, 1.0, 0.001) = 0.005;
uniform vec4 outline_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform sampler2D noise;
uniform float roughness;
render_mode world_vertex_coords;

void vertex()
{
	float d = (texture(noise, UV).r - 0.5) * roughness + 1.0;
	VERTEX = (NORMAL * outline_thickness * d) + VERTEX;
}

void fragment()
{
	ALBEDO = outline_color.rgb;
}
