/// @description verlet(x, y, xprevious, yprevious, x_acceleration, y_acceleration, delta_time)
/// @param x
/// @param y
/// @param xprevious
/// @param yprevious
/// @param x_acceleration
/// @param y_acceleration
/// @param delta_time

var _x = argument[0];
var _y = argument[1];
var _xprevious = argument[2];
var _yprevious = argument[3];
var _x_acceleration = argument[4];
var _y_acceleration = VERLET_GRAVITY != 0 ? VERLET_GRAVITY : argument[5];
var _delta = argument[6];

var _vx = _x - _xprevious;
var _vy = _y - _yprevious;

var _vx_final = _vx * VERLET_DAMPING + _x_acceleration * (2 * _delta);
var _vy_final = _vy * VERLET_DAMPING + _y_acceleration * (2 * _delta);

var _nx = _x + _vx_final;
var _ny = _y + _vy_final;

_xprevious = _x;
_yprevious = _y;

var _col = VERLET_COLLIDER_OBJECT != noone ? instance_position(_nx, _ny, VERLET_COLLIDER_OBJECT) : noone;

if (_col != noone) {
	_x = _x;
	_y = _y;
	
	_xprevious = _x - _vx;
	_yprevious = _y - _vy;
} else {
	_x = _nx;
	_y = _ny;
}

return [_x, _y, _xprevious, _yprevious, _x_acceleration, _y_acceleration]