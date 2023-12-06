shader_type canvas_item;
render_mode unshaded;

uniform float cutoff : hint_range(0, 1);
uniform float smooth_size : hint_range(0, 1);
uniform sampler2D mask : source_color;

void fragment()
{
	float value = texture(mask, UV).r;
	float alpha = smoothstep(cutoff, cutoff + smooth_size, value * (1.0 - smooth_size) + smooth_size);
	vec4 colour = texture(TEXTURE, UV);
	colour.a *= texture(mask, UV).a;
	COLOR = vec4(colour.rgb, alpha);
}