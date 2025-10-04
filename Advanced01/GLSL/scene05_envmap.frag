#version 130

#define PI 3.141592653589793

in vec3 vWorldEyeDir;
in vec3 vWorldNormal;

out vec4 fragColor;

// TODO: uncomment these lines
uniform sampler2D envmap;

float atan2(in float y, in float x)
{
    return x == 0.0 ? sign(y)*PI/2 : atan(y, x);
}

void main()
{
	// TODO: write an appropriate code here
	vec3 ref = reflect(vWorldEyeDir, vWorldNormal);
	float theta = asin(ref.y);
	float phi = atan(ref.z, ref.x);
	vec2 uv = vec2((phi + PI) / (2.0 * PI), 1.0 - (theta + PI/2.0) / PI);
	vec4 color = texture2D(envmap, uv);
	fragColor = color;
}
