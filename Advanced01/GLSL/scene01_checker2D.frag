#version 130

in vec2 outTexCoord;
out vec4 fragColor;

// TODO: uncomment these lines
uniform vec4 checkerColor0;
uniform vec4 checkerColor1;
uniform vec2 checkerScale;

void main()
{
	// TODO: write an appropriate code here
	float s = fract(outTexCoord.s / checkerScale.s);
	float t = fract(outTexCoord.t / checkerScale.t);
	vec4 color = (s < 0.5 && t < 0.5) || (s >= 0.5 && t >= 0.5) ? checkerColor0 : checkerColor1;
	fragColor = color;
}
