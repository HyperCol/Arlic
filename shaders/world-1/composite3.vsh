#version 330 compatibility

out vec4 texcoord;

uniform int worldTime;

void main() {
	gl_Position = ftransform();
	
	texcoord = gl_MultiTexCoord0;
}
