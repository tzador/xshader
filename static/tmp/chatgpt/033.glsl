vec2 cmul(vec2 a, vec2 b) {
  return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

float mandelbrot(vec2 c) {
  vec2 z = vec2(0.0);
  float iter = 0.0;
  const float maxIter = 100.0;

  for(float i = 0.0; i < maxIter; i++) {
    z = cmul(z, z) + c;
    if(length(z) > 2.0) {
      iter = i;
      break;
    }
  }

  // Smooth coloring
  return iter - log2(log2(length(z))) + 4.0;
}

vec3 palette(float t) {
  vec3 a = vec3(0.5, 0.5, 0.5);
  vec3 b = vec3(0.5, 0.5, 0.5);
  vec3 c = vec3(1.0, 1.0, 1.0);
  vec3 d = vec3(0.0, 0.1, 0.2);

  return a + b * C(Q * (c * t + d));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  uv.x *= 1.5;

  // Create zoom animation
  float time = t * 0.1;
  float zoom = pow(2.0, time);

  // Define interesting point to zoom into
  vec2 center = vec2(-0.7436438870371587, 0.1318259043091893);

  // Transform coordinates
  vec2 c = center + uv / zoom;

  // Calculate mandelbrot value
  float m = mandelbrot(c);

  // Create color
  vec3 color = palette(m * 0.02 + time);

  // Add smooth transition
  color *= smoothstep(0.0, 1.0, m / 100.0);

  // Add glow at iteration boundaries
  float glow = exp(-fract(m) * 3.0);
  color += vec3(1.0, 0.8, 0.4) * glow * 0.3;

  // Add subtle vignette
  float vignette = 1.0 - length(uv * 0.5);
  color *= vignette;

  // Add subtle noise to break up banding
  float noise = fract(S(uv.x * 100.0 + uv.y * 50.0 + time) * 43758.5453);
  color *= 0.95 + 0.05 * noise;

  return vec4(color, 1.0);
}
