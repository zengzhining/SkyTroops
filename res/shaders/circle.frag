#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_texCoord;

uniform float uNumber;

void main(void)
{
	vec2 pos = v_texCoord  ;

	// float brightness = wave(pos, CC_Time[1]);

	// float brightness = 0.;
	float brightness = 1.0;



	vec4 col =texture2D(CC_Texture0, pos);

	if (pow(pos.y-0.5, 2.)  + pow(pos.x-(0.5), 2.)  > pow(CC_Time[1], 2.) )
	{
		col = vec4(0.0,0.0,1.0,0.0);
	}

    vec4 finalColor = col * vec4(brightness,brightness,brightness,1.0);
	gl_FragColor = finalColor ;
	// gl_FragColor = vec4( 0.8,  0.0, 0.0 , 1.0) * col * uNumber;
}

