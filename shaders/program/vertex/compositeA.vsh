varying vec2 texcoord;

uniform int worldTime;

void main() {
	gl_Position = ftransform();
	
	texcoord = gl_MultiTexCoord0.xy;
}