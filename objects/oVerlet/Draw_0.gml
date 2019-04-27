// Exit out if uniform array is empty
if (array_length_1d(xPositionUniformArray) == 0) exit;

// Submit vertex buffer to screen using the verlet shader
shader_set(shVerlet);
shader_set_uniform_f_array(uniformPositionX, xPositionUniformArray);
shader_set_uniform_f_array(uniformPositionY, yPositionUniformArray);
shader_set_uniform_f_array(uniformOrigin, verletOrigin);

// Build transformation matrix for the loaded 3D model and set position, rotation and scale
var mat = matrix_build(0, 0, depth, 0, 0, 0, 1, 1, 1);
matrix_set(matrix_world, mat);

// Submit the vertex buffer
vertex_submit(vBuff, pr_trianglelist, texture);

// Reset world transformation matrix
matrix_set(matrix_world, matrix_build_identity());

shader_reset();