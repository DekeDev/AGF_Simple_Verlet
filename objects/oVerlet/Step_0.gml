// Move x and y positions to parent entity if it's defined
if (VERLET_ANCHOR_ENTITY != noone) {
	x = VERLET_ANCHOR_ENTITY.x;
	y = VERLET_ANCHOR_ENTITY.y;
}
// Define origin of the verlet chain
verletOrigin = VERLET_FIXED_ORIGIN ? [x, y, VERLET_FIXED_ORIGIN_X, VERLET_FIXED_ORIGIN_Y] : [x, y, x, y];

// Recalculate point distance if needed
VERLET_POINT_DISTANCE = VERLET_FIX_LENGTH ? (VERLET_LENGTH / VERLET_POINTS) : VERLET_POINT_DISTANCE;

#region --- Calculate perpendicular vertices to verlet points for first point in array --------------------
	var _vo = verletObject[@0];
	var _width = VERLET_POINT_WIDTH;
	_vo[@2] = x;
	_vo[@3] = y;

	var _vo2 = verletObject[1];

	var _vx1 = _vo[2];
	var _vy1 = _vo[3];
	var _vx2 = _vo2[2];
	var _vy2 = _vo2[3];

	var _vdir = point_direction(_vx1, _vy1, _vx2, _vy2);

	var _x1 = _vx1 + lengthdir_x(_width/2, _vdir - 90);
	var _y1 = _vy1 + lengthdir_y(_width/2, _vdir - 90);
	var _x2 = _vx1 + lengthdir_x(_width/2, _vdir + 90);
	var _y2 = _vy1 + lengthdir_y(_width/2, _vdir + 90);

	xPositionUniformArray[0] = _x1;
	yPositionUniformArray[0] = _y1;
	xPositionUniformArray[1] = _x2;
	yPositionUniformArray[1] = _y2;
#endregion

#region --- Calculate verlet physics, constraints and vertex positions for the rest of the verlet chain ---
	for (var i = 1; i < VERLET_POINTS; ++i) {
		var _vo = verletObject[@i];
		var _vop = verletObject[@i-1];
		var _id = i * 2;
	
		// Verlet movement
		var _vres = verlet_physics(_vo[2], _vo[3], _vo[4], _vo[5], _vo[6], _vo[7], VERLET_DELTA_TIME);
	
		_vo[@2] = _vres[0];
		_vo[@3] = _vres[1];
		_vo[@4] = _vres[2];
		_vo[@5] = _vres[3];
		_vo[@6] = _vres[4];
		_vo[@7] = _vres[5];
	
		// Constraints
		var _cres = verlet_solve_constraints(VERLET_POINT_DISTANCE, _vo[2], _vo[3], _vop[2], _vop[3], _vop[0], VERLET_CONSTRAINT_ITERATIONS);
	
		_vo[@2] = _cres[0];
		_vo[@3] = _cres[1];
		_vop[@2] = _cres[2];
		_vop[@3] = _cres[3];
	
		// Calculate and write x/y positions for all points to their respective arrays
		var _vx1 = _vop[2];
		var _vy1 = _vop[3];
		var _vx2 = _vo[2];
		var _vy2 = _vo[3];

		var _vdir = point_direction(_vx1, _vy1, _vx2, _vy2);

		var _x1 = _vx1 + lengthdir_x(_width/2, _vdir - 90);
		var _y1 = _vy1 + lengthdir_y(_width/2, _vdir - 90);
		var _x2 = _vx1 + lengthdir_x(_width/2, _vdir + 90);
		var _y2 = _vy1 + lengthdir_y(_width/2, _vdir + 90);
	
		xPositionUniformArray[_id] = _x1;
		yPositionUniformArray[_id] = _y1;
		xPositionUniformArray[_id+1] = _x2;
		yPositionUniformArray[_id+1] = _y2;	
	}
#endregion