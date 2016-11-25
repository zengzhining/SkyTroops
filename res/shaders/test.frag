#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_texCoord;

const float outlineSize = 20.0; 
const vec3 outlineColor = vec3(0.0,1.0, 0.0); 
const vec2 textureSize = vec2(40.0, 60.0); 

uniform float uNumber;

// 判断在这个角度上距离为outlineSize那一点是不是透明
int getIsStrokeWithAngel(float angel)
{
    int stroke = 0;
    float rad = angel * 0.01745329252; 
    vec2 unit = 1.0 / textureSize.xy;
    vec2 offset = vec2(outlineSize * cos(rad) * unit.x, outlineSize * sin(rad) * unit.y); 
    float a = texture2D(CC_Texture0, v_texCoord + offset).a;
    if (a >= 0.5)
    {
        stroke = 1;
    }
    return stroke;
}

void main(void)
{
	vec4 myC = texture2D(CC_Texture0, v_texCoord); // 正在处理的这个像素点的颜色
    if (myC.a >= 0.5) // 不透明，不管，直接返回
    {
        gl_FragColor = myC;
        return;
    }
    // 这里肯定有朋友会问，一个for循环就搞定啦，怎么这么麻烦！其实我一开始也是用for的，但后来在安卓某些机型（如小米4）会直接崩溃，查找资料发现OpenGL es并不是很支持循环，while和for都不要用
    int strokeCount = 0;
    strokeCount += getIsStrokeWithAngel(0.0);
    strokeCount += getIsStrokeWithAngel(30.0);
    strokeCount += getIsStrokeWithAngel(60.0);
    strokeCount += getIsStrokeWithAngel(90.0);
    strokeCount += getIsStrokeWithAngel(120.0);
    strokeCount += getIsStrokeWithAngel(150.0);
    strokeCount += getIsStrokeWithAngel(180.0);
    strokeCount += getIsStrokeWithAngel(210.0);
    strokeCount += getIsStrokeWithAngel(240.0);
    strokeCount += getIsStrokeWithAngel(270.0);
    strokeCount += getIsStrokeWithAngel(300.0);
    strokeCount += getIsStrokeWithAngel(330.0);

    if (strokeCount > 0) // 四周围至少有一个点是不透明的，这个点要设成描边颜色
    {
        myC.rgb = outlineColor;
        myC.a = 1.0;
    }

    vec4 finalColor = myC;

	gl_FragColor = finalColor ;
	// gl_FragColor = vec4( 0.8,  0.0, 0.0 , 1.0) * col * uNumber;
}


