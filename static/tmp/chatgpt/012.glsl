vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = A(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec4 f() {
  // Calculate zoom factor
  float zoom = exp(t * 0.5);

  // Get the initial center point
  vec2 center = vec2(-0.5, 0.0);

  // Calculate the point we want to zoom towards (based on mouse position)
  vec2 zoomTarget = center + (m * 2.0 - 1.0) * 0.5;

  // Smoothly move the center towards the zoom target as we zoom in
  center = mix(center, zoomTarget, 1.0 - 1.0 / zoom);

  // Map pixel coordinates to complex plane, using the new center
  vec2 c = (p * 2.0 - 1.0) / zoom + center;

  // Mandelbrot iteration
  vec2 z = vec2(0.0);
  float iter = 0.0;
  const float MAX_ITER = 100.0;

  for(float i = 0.0; i < MAX_ITER; i++) {
    // z = z^2 + c
    z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;

    if(length(z) > 2.0) {
      iter = i;
      break;
    }
  }

  // Smooth coloring
  float smooth_iter = iter - log2(log2(length(z))) + 4.0;

  // Create cycling color based on iteration count
  vec3 color = hsv2rgb(vec3(smooth_iter * 0.1 + t * 0.2,  // Hue cycles with time
  0.8,                          // Saturation
  iter < MAX_ITER ? 1.0 : 0.0   // Value (black for set interior)
  ));

  return vec4(color, 1.0);
}
