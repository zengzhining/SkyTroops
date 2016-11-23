#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_texCoord;

uniform float uNumber;

vec3 blur(vec2);

void main(void)
{
	vec4 col =texture2D(CC_Texture0, v_texCoord);

    float instance = col.r * 0.3 + col.g * 0.6 + col.b * 0.12;
	gl_FragColor = vec4( instance * 1.5,  instance* 1.0, instance* 1.0 , 1.0);
	// gl_FragColor = vec4( 0.8,  0.0, 0.0 , 1.0) * col;
}

