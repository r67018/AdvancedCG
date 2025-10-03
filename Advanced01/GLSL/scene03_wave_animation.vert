#version 130

in vec4 vertexPosition;

// TODO: uncomment these lines
uniform float temporalSignal;
uniform mat4 projModelViewMatrix;

void main()
{
	// TODO: write an appropriate code here
	float wave = sin(2 * vertexPosition.x + temporalSignal) + cos(2 * vertexPosition.z + temporalSignal);
	gl_Position = projModelViewMatrix * vertexPosition + vec4(temporalSignal * 0.01, wave, 0, 0);
}
