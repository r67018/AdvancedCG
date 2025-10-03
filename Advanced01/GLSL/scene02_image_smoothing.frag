#version 130

#define PI 3.14159265359
#define SIGMA 10.0

in vec2 outTexCoord;
out vec4 fragColor;

// TODO: uncomment these lines
uniform sampler2D tex;
uniform int halfKernelSize;
uniform float uScale;
uniform float vScale;

void main()
{
	// TODO: write an appropriate code here
	vec4 color = vec4(0.0);
	float weightSum = 0.0;
	for (int x = -halfKernelSize; x <= halfKernelSize; x++) {
		for (int y = -halfKernelSize; y <= halfKernelSize; y++) {
			vec2 coord = vec2(outTexCoord.s + vScale * x, outTexCoord.t + uScale * y);
			vec4 t = texture2D(tex, coord);
			float weight = 1/(2.0*PI*SIGMA*SIGMA) * exp(-(float(x*x + y*y) / (2.0*SIGMA*SIGMA)));
			color += weight * t;
			weightSum += weight;
		}
	}
	fragColor = color / weightSum;
}
