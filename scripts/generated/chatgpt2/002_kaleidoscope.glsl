vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

vec2 kaleidoscope(vec2 uv, float segments) {
  float angle = atan(uv.y, uv.x);
  float radius = length(uv);

  // Create symmetry
  angle = mod(angle, Q / segments);
  if(mod(angle, Q / segments * 2.0) > Q / segments) {
    angle = Q / segments - (angle - Q / segments);
  }

  return vec2(C(angle), S(angle)) * radius;
}

vec3 rainbow(float t) {
  vec3 a = vec3(0.5, 0.5, 0.5);
  vec3 b = vec3(0.5, 0.5, 0.5);
  vec3 c = vec3(1.0, 1.0, 1.0);
  vec3 d = vec3(0.0, 0.33, 0.67);

  return a + b * C(Q * (c * t + d));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create time-varying zoom
  float zoom = 1.0 + 0.5 * S(t * 0.2);
  uv *= zoom;

  // Rotate the entire pattern
  uv = rotate(uv, t * 0.1);

  // Apply kaleidoscope effect
  float segments = 8.0;
  vec2 kal = kaleidoscope(uv, segments);

  // Create pattern
  float pattern = 0.0;
  for(float i = 1.0; i < 4.0; i++) {
    vec2 offset = vec2(S(t * i * 0.2), C(t * i * 0.3)) * 0.3;
    vec2 p = kal + offset;
    pattern += S(length(p) * 5.0 - t * i);
  }

  // Create color
  vec3 color = rainbow(pattern * 0.2 + t * 0.1);

  // Add highlights
  float highlight = pow(pattern, 5.0);
  color += vec3(1.0) * highlight;

  // Add center glow
  float glow = exp(-length(uv) * 2.0);
  color += rainbow(t * 0.2) * glow;

  return vec4(color, 1.0);
}
