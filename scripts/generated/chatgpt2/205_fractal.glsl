/*
Dynamic Fractal
Creates an animated fractal pattern using minimal
iterative transformations.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 2.0;
  vec2 z = uv;
  float iter = 0.0;

    // Dynamic parameters
  vec2 c = vec2(cos(t * 0.5) * 0.4, sin(t * 0.3) * 0.4);

    // Fractal iteration
  for(int i = 0; i < 8; i++) {
        // Complex number operations
    z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;

        // Accumulate iterations
    iter += exp(-length(z) * 0.5);

        // Early break for optimization
    if(length(z) > 2.0)
      break;
  }

    // Create color from iteration count
  vec3 color = vec3(iter * 0.1, iter * iter * 0.05, exp(-iter * 0.5));

  return vec4(color, 1.0);
}
