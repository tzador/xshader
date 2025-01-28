float crystal(vec2 p) {
  float a = atan(p.y, p.x);
  float r = length(p);
  float facets = abs(S(a * 6.0 + r * 3.0 - t));
  return facets * exp(-r * 2.0);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mp = m * 2.0 - 1.0;

  // Rotate and scale space
  vec2 rot = vec2(uv.x * C(t) - uv.y * S(t), uv.x * S(t) + uv.y * C(t));

  // Create crystal pattern
  float c = crystal(rot + mp * 0.3);
  c += crystal(rot * 1.5 - mp * 0.2) * 0.5;

  // Create prismatic colors
  vec3 color = 0.5 + 0.5 * C(c * 8.0 + vec3(0, 2, 4));
  color *= 1.0 + c * 2.0;
  color *= exp(-length(uv) * 0.7);

  return vec4(color, 1.0);
}
