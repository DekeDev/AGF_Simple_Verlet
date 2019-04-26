draw_set_halign(fa_right);
var _x = window_get_width() - 8;
var _y = 8;
var _yadd = 12;

for (var i = 0; i < VERLET_POINTS; ++i) {
	var _point = verletObject[i];
	draw_text(_x, _y + (i * _yadd), "POINT " + string(i) + ": (" + string(_point[2]) + ", " + string(_point[3]) + ")");	
}

draw_set_halign(fa_left);