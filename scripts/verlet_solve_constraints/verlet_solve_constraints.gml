/// @description solve_constraints(rest_distance, x, y, parent_x, parent_y, parent_fixed, iterations)
/// @param rest_distance
/// @param x
/// @param y
/// @param parent_x
/// @param parent_y
/// @param parent_fixed
/// @param iterations

var _rest_distance = argument[0];
var _x = argument[1];
var _y = argument[2];
var _parent_x = argument[3];
var _parent_y = argument[4];
var _parent_fixed = argument[5];
var _iterations = argument[6];

repeat(_iterations) {
	var _diff_x = _parent_x - _x;
	var _diff_y = _parent_y - _y;

	var _d = point_distance(_x, _y, _parent_x, _parent_y);

	var _distance_diff = (_rest_distance - _d) / _d;

	var _t_x = _diff_x * 0.5 * _distance_diff;
	var _t_y = _diff_y * 0.5 * _distance_diff;

	if (!_parent_fixed && VERLET_STRICT_CONSTRAINTS ? _d < _rest_distance : true) {
		_parent_x += _t_x;
		_parent_y += _t_y;
	}

	_x -= _t_x;
	_y -= _t_y;
}

verletPhysicsReturn[0] = _x;
verletPhysicsReturn[1] = _y;
verletPhysicsReturn[2] = _parent_x;
verletPhysicsReturn[3] = _parent_y;

return verletPhysicsReturn;