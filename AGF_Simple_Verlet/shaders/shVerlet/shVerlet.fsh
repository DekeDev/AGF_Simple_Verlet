//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 new_colour = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	new_colour.a = v_vColour.a;
	
    gl_FragColor = new_colour;
}
