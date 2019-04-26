//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)
attribute float in_Weight;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float xPosition[256];
uniform float yPosition[256];

void main()
{
    vec4 verlet_pos = vec4( in_Position.xyz, 1.0);
	
	int index = int(in_Weight);

	verlet_pos.x = xPosition[index];
	verlet_pos.y = yPosition[index];
	
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * verlet_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}
