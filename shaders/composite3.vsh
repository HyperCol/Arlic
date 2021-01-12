#version 120

varying vec4 texcoord;

uniform int worldTime;

void main() {
	gl_Position = ftransform();
	
	texcoord = gl_MultiTexCoord0;
}
