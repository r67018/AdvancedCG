#version 130

in vec3 vVertexNormal;
out vec4 fragColor;

void main()
{
	// TODO: write an appropriate code here
	fragColor = vec4(0.5 * vVertexNormal + 0.5, 1.0);
}
