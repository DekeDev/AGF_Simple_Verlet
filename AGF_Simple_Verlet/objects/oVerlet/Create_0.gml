// Initialize all important macros
#macro VERLET_DELTA_TIME 1/60 // Point to your global delta time variable (in ms) or just put 1/60 in here (@60FPS)
#macro VERLET_CONSTRAINT_ITERATIONS 5 // More iterations mean more accurate constraint solving but also more step time

// Define verlet chain
VERLET_POINTS = 8; // Number of points in the verlet chain
VERLET_FIX_LENGTH = true; // Set true to define the length for the whole chain and false to use the distance between points instead
VERLET_LENGTH = 45; // Length for the verlet chain. Only used if VERLET_FIX_LENGTH is true
VERLET_POINT_DISTANCE = 4.65; // Resting distance between all points
VERLET_POINT_WIDTH = 4; // Polygon width for the textured chain
VERLET_POINT_WIDTH_FACTOR = 0.95; // Width gets multiplied by this value with every point

VERLET_TEXTURE = sVerlet; // The main texture for the verlet chain

VERLET_ALPHA = 1.0; // Base alpha for all polygons
VERLET_ALPHA_DECREASE = -0.03; // Alpha gets reduced by this value with every point

VERLET_GRAVITY = 2.965; // Gravity (along the y-axis) for all points in the chain
VERLET_DAMPING = 0.740; // Damping for the verlet physics (0 - full damping, 1 - no damping)

VERLET_STRICT_CONSTRAINTS = true; // Clamp constraints strictly to point distance or give the verlet object a little bit of "stretch"
VERLET_ANCHOR_ENTITY = oAnchor; // Define an entity/object to anchor the verlet chain to
VERLET_COLLIDER_OBJECT = noone; // The verlet chain will collide with this object (or just put noone)

// Initialize verlet point array and texture
verletObject = [];
texture = noone;
VERLET_POINT_DISTANCE = VERLET_FIX_LENGTH ? (VERLET_LENGTH / VERLET_POINTS) : VERLET_POINT_DISTANCE;

// Initialize shader uniforms
xPositionUniformArray = [];
yPositionUniformArray = [];
uniformPositionX = shader_get_uniform(shVerlet, "xPosition");
uniformPositionY = shader_get_uniform(shVerlet, "yPosition");

// Fill verlet point array with default points
var _lastID = 0;

for (var i = 0; i < VERLET_POINTS; ++i) {
	var _fixed = (i == 0);
	
	//
	// Verlet Array
	// [fixed, parent id, x, y, xprevious, yprevious, x_acceleration, y_acceleration]
	//  
	verletObject[i] = [_fixed, _lastID, x, y + ((i+1) * VERLET_POINT_DISTANCE), x, y + ((i+1) * VERLET_POINT_DISTANCE), 0, VERLET_GRAVITY];
	
	_lastID = i;
}

#region --- Create vertex buffer ------------
	// Load texture and UVs
	var _sprite = VERLET_TEXTURE;
	var _alpha = VERLET_ALPHA;
		
	var sprUVs = sprite_get_uvs(_sprite, 0);
	texture = sprite_get_texture(_sprite, 0);
	var UVl = sprUVs[0]; var UVt = sprUVs[1]; var UVr = sprUVs[2]; var UVb = sprUVs[3];
		
	var _fullWidth = VERLET_POINT_WIDTH;
	var _halfWidth = _fullWidth / 2;
	
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_color();
	vertex_format_add_texcoord();
	vertex_format_add_custom(vertex_type_float1, vertex_usage_texcoord);
	vFormat = vertex_format_end();

	vBuff = vertex_create_buffer();

	vertex_begin(vBuff, vFormat);
	
	for (var i = 0; i < VERLET_POINTS - 1; ++i) {

		_id = i * 2;
		_fullWidth *= VERLET_POINT_WIDTH_FACTOR;
		_halfWidth = _fullWidth / 2;
		
		var _currentPoint = verletObject[i];
		var _nextPoint = verletObject[i+1];
		var _x = _currentPoint[2];
		var _y = _currentPoint[3];
		
		var _xNext = _nextPoint[2];
		var _yNext = _nextPoint[3];
		
		var _xLeft = _x - _halfWidth;
		var _xLeftNext = _xNext - _halfWidth;
		
		var _xRight = _x + _halfWidth;
		var _xRightNext = _xNext + _halfWidth;
		
		#region Triangle 1
			// TOP LEFT
			vertex_position_3d(vBuff, _xLeft, _y, depth);
			vertex_color(vBuff, c_white, _alpha);
			vertex_texcoord(vBuff, UVl, UVt);
			vertex_float1(vBuff, _id);
			
			// BOTTOM LEFT
			vertex_position_3d(vBuff, _xLeftNext, _yNext, depth);
			vertex_color(vBuff, c_white, _alpha + VERLET_ALPHA_DECREASE);
			vertex_texcoord(vBuff, UVl, UVb);
			vertex_float1(vBuff, _id+2);
			
			// TOP RIGHT
			vertex_position_3d(vBuff, _xRight, _y, depth);
			vertex_color(vBuff, c_white, _alpha);
			vertex_texcoord(vBuff, UVr, UVt);
			vertex_float1(vBuff, _id+1);
		#endregion
		
		#region Triangle 2
			// TOP RIGHT
			vertex_position_3d(vBuff, _xRight, _y, depth);
			vertex_color(vBuff, c_white, _alpha);
			vertex_texcoord(vBuff, UVr, UVt);
			vertex_float1(vBuff, _id+1);
			
			// BOTTOM RIGHT
			vertex_position_3d(vBuff, _xRightNext, _yNext, depth);
			vertex_color(vBuff, c_white, _alpha + VERLET_ALPHA_DECREASE);
			vertex_texcoord(vBuff, UVr, UVb);
			vertex_float1(vBuff, _id+3);
			
			// BOTTOM LEFT
			vertex_position_3d(vBuff, _xLeftNext, _yNext, depth);
			vertex_color(vBuff, c_white, _alpha + VERLET_ALPHA_DECREASE);
			vertex_texcoord(vBuff, UVl, UVb);
			vertex_float1(vBuff, _id+2);
		#endregion
		
		_alpha += VERLET_ALPHA_DECREASE;
	}
	
	vertex_end(vBuff);
	vertex_freeze(vBuff);
#endregion