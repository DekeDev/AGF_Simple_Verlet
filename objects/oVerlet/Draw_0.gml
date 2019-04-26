// Exit out if uniform array is empty
if (array_length_1d(xPositionUniformArray) == 0) exit;

// Submit vertex buffer to screen using the verlet shader
shader_set(shVerlet);
shader_set_uniform_f_array(uniformPositionX, xPositionUniformArray);
shader_set_uniform_f_array(uniformPositionY, yPositionUniformArray);
shader_set_uniform_f_array(uniformOrigin, verletOrigin);
vertex_submit(vBuff, pr_trianglelist, texture);
shader_reset();