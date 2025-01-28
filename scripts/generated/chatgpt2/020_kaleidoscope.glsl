float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

vec2 kaleidoscope(vec2 uv, float segments) {
  float angle = atan(uv.y, uv.x);
  float radius = length(uv);

  // Divide space into segments
  float segmentAngle = Q / segments;
  angle = mod(angle, segmentAngle);
  angle = min(angle, segmentAngle - angle);

  return vec2(C(angle), S(angle)) * radius;
}

vec2 complexMul(vec2 a, vec2 b) {
  return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

float mandelbrot(vec2 c, float maxIter) {
  vec2 z = vec2(0.0);
  float iter = 0.0;

  for(float i = 0.0; i < 100.0; i++) {
    if(i >= maxIter)
      break;

    z = complexMul(z, z) + c;
    if(length(z) > 2.0)
      break;
    iter++;
  }

  return iter / maxIter;
}

vec3 prismaticColor(float value) {
  // Create rainbow spectrum
  vec3 col1 = vec3(1.0, 0.0, 0.0);  // Red
  vec3 col2 = vec3(0.0, 1.0, 0.0);  // Green
  vec3 col3 = vec3(0.0, 0.0, 1.0);  // Blue
  vec3 col4 = vec3(1.0, 1.0, 0.0);  // Yellow
  vec3 col5 = vec3(1.0, 0.0, 1.0);  // Magenta

  value = fract(value * 3.0);
  float t = fract(value * 5.0);

  vec3 color = col1;
  color = mix(color, col2, smoothstep(0.0, 0.2, t));
  color = mix(color, col3, smoothstep(0.2, 0.4, t));
  color = mix(color, col4, smoothstep(0.4, 0.6, t));
  color = mix(color, col5, smoothstep(0.6, 0.8, t));
  color = mix(color, col1, smoothstep(0.8, 1.0, t));

  return color;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create zoom effect based on mouse position
  float zoom = 1.0 + length(mousePos) * 2.0;
  uv *= zoom;

  // Rotate based on time
  uv = rotate(uv, t * 0.2);

  // Apply kaleidoscope effect
  float segments = 8.0 + 4.0 * (1.0 + S(t * 0.5));
  vec2 kal = kaleidoscope(uv, segments);

  // Create fractal pattern
  vec2 c = kal * 2.0;
  c += mousePos;  // Add mouse influence
  float fractal = mandelbrot(c, 50.0);

  // Create dynamic color
  vec3 color = prismaticColor(fractal + t * 0.1);

  // Add symmetrical patterns
  for(float i = 1.0; i < 4.0; i++) {
    float angle = t * (0.1 + 0.1 * i) + i * Q / 4.0;
    vec2 offset = vec2(C(angle), S(angle)) * 0.5;

    vec2 uv2 = kal - offset;
    float pattern = mandelbrot(uv2 * (1.0 + i * 0.5), 20.0);

    color += prismaticColor(pattern - t * 0.2) * 0.3;
  }

  // Add glow effects
  float glow = exp(-length(kal) * 2.0);
  color += vec3(1.0, 0.5, 0.0) * glow;

  // Add mouse interaction glow
  float mouseGlow = exp(-length(uv - mousePos) * 1.5);
  color += prismaticColor(mouseGlow + t) * mouseGlow;

  // Add edge effects
  float edge = smoothstep(2.0 / zoom, 1.8 / zoom, length(uv));
  color *= edge;

  // Add sparkles
  for(float i = 0.0; i < 10.0; i++) {
    float t_offset = t + i * 1234.5678;
    vec2 sparklePos = vec2(hash(vec2(i, t_offset)), hash(vec2(t_offset, i))) * 2.0 - 1.0;

    float sparkle = exp(-length(kal - sparklePos) * 10.0);
    color += vec3(1.0) * sparkle * (0.5 + 0.5 * S(t * 10.0 + i));
  }

  return vec4(color, 1.0);
}
