#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_texCoord;

uniform float uNumber;

float stripes(vec2 p, float steps) {
  return fract(p.x*steps);
}

float wrap(float x) {
  return abs(mod(x, 2.)-1.);
}

float wave(vec2 p, float angle) {
  vec2 direction = vec2(cos(angle), -sin(angle));
  return cos(dot(p, direction));
}

float random(float p) {
  return fract(sin(p)*10000.);
}

float noise(vec2 p) {
  return random(p.x + p.y*10000.);
}

float stepNoise(vec2 p) {
  return noise(floor(p));
}

//chess
float checkerboard(vec2 p, float steps) {
  float x = floor(p.x * steps);
  float y = floor(p.y * steps);
  return mod(x + y, 2.);
}

vec2 sw(vec2 p) {return vec2( floor(p.x) , floor(p.y) );}
vec2 se(vec2 p) {return vec2( ceil(p.x)  , floor(p.y) );}
vec2 nw(vec2 p) {return vec2( floor(p.x) , ceil(p.y)  );}
vec2 ne(vec2 p) {return vec2( ceil(p.x)  , ceil(p.y)  );}

float smoothNoise(vec2 p) {
  vec2 inter = smoothstep(0., 1., fract(p));
  float s = mix(noise(sw(p)), noise(se(p)), inter.x);
  float n = mix(noise(nw(p)), noise(ne(p)), inter.x);
  return mix(s, n, inter.y);
  return noise(nw(p));
}

float fractalNoise(vec2 p) {
  float total = 0.0;
  total += smoothNoise(p);
  total += smoothNoise(p*2.) / 2.;
  total += smoothNoise(p*4.) / 4.;
  total += smoothNoise(p*8.) / 8.;
  total += smoothNoise(p*16.) / 16.;
  total /= 1. + 1./2. + 1./4. + 1./8. + 1./16.;
  return total;
}

float movingNoise(vec2 p) {
  float total = 0.0;
  total += smoothNoise(p     - CC_Time[1]);
  total += smoothNoise(p*2.  + CC_Time[1]) / 2.;
  total += smoothNoise(p*4.  - CC_Time[1]) / 4.;
  total += smoothNoise(p*8.  + CC_Time[1]) / 8.;
  total += smoothNoise(p*16. - CC_Time[1]) / 16.;
  total /= 1. + 1./2. + 1./4. + 1./8. + 1./16.;
  return total;
}

float nestedNoise(vec2 p) {
  float x = movingNoise(p);
  float y = movingNoise(p + 100.);
  return movingNoise(p + vec2(x, y));
}

void main(void)
{
	vec2 pos = v_texCoord *6.0 ;

	// float brightness = wave(pos, CC_Time[1]);

	// float brightness = 0.;
	float brightness = nestedNoise(pos );



	vec4 col =texture2D(CC_Texture0, v_texCoord);


    float instance = col.r * 0.3  + col.g * 0.6 + col.b * 0.12;
    vec4 greyColor = vec4( instance * 1.0,  instance* 1.0, instance* 1.0 , col.a);

    vec4 finalColor = col * vec4(brightness,brightness,brightness,1.0);
	gl_FragColor = finalColor ;
	// gl_FragColor = vec4( 0.8,  0.0, 0.0 , 1.0) * col * uNumber;
}

