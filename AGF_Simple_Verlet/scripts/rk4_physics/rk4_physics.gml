/// @description rk4(x, y, xprevious, yprevious, x_acceleration, y_acceleration)
/// @param x
/// @param y
/// @param xprevious
/// @param yprevious
/// @param x_acceleration
/// @param y_acceleration

var _x = argument[0];
var _y = argument[1];
var _xprev = argument[2];
var _yprev = argument[3];
var _x_acc = argument[4];
var _y_acc = argument[5];

_x_acc = 0;
_y_acc = -global.g;

global.delta = 1/60

var _stiff = .5;
var _damp = global.damping;

var _vx = _x - _xprev;
var _vy = _y - _yprev;
_xprev = _x;
_yprev = _y;

var _x1 = _x;
var _vx1 = _vx * _damp;
var _ax1 = (-_stiff*_x1-_damp*_vx1) * 0 * global.delta;

var _y1 = _y;
var _vy1 = _vy;
var _ay1 = (-_stiff*_y1-_damp*_vy1) * _y_acc * 0 * global.delta;

var _x2 = _x + 0.5 * _vx1 * global.delta;
var _vx2 = _vx + 0.5 * _ax1 * global.delta * _damp;
var _ax2 = (-_stiff*_x2-_damp*_vx2)  * 0.5 * global.delta;

var _y2 = _y + 0.5 * _vy1 * global.delta;
var _vy2 = _vy + 0.5 * _ay1 * global.delta;
var _ay2 = (-_stiff*_y2-_damp*_vy2) * _y_acc * 0.5 * global.delta;

var _x3 = _x + 0.5 * _vx2 * global.delta;
var _vx3 = _vx + 0.5 * _ax2 * global.delta * _damp;
var _ax3 = (-_stiff*_x3-_damp*_vx3) * 0.5 * global.delta;

var _y3 = _y + 0.5 * _vy2 * global.delta;
var _vy3 = _vy + 0.5 * _ay2 * global.delta;
var _ay3 = (-_stiff*_y3-_damp*_vy3) *_y_acc * 0.5 * global.delta;

var _x4 = _x + _vx3 * global.delta;
var _vx4 = _vx + _ax3 * global.delta * _damp;
var _ax4 = (-_stiff*_x4-_damp*_vx4) * 0.5 * global.delta;

var _y4 = _y + _vy3 * global.delta;
var _vy4 = _vy + _ay3 * global.delta;
var _ay4 = (-_stiff*_y4-_damp*_vy4) * _y_acc  * 0.5 * global.delta;

var _nx = _x + (global.delta / 6) * (_vx1 + 2*_vx2 + 2*_vx3 + _vx4);
var _ny = _y + (global.delta / 6) * (_vy1 + 2*_vy2 + 2*_vy3 + _vy4);

_x_acc = _vx + (global.delta / 6) * (_ax1 + 2*_ax2 + 2*_ax3 + _ax4);
_y_acc = _vy + (global.delta / 6) * (_ay1 + 2*_ay2 + 2*_ay3 + _ay4);

var _col = instance_position(_nx, _ny, collider);

if (_col != noone) {
	_x = _nx + _col.vx;
	_y = _ny;
	
	//xprev = x - _vx;
	//yprev = y - _vy;
} else {
	_x = _nx;
	_y = _ny;
}

return [_x, _y, _xprev, _yprev, _x_acc, _y_acc]