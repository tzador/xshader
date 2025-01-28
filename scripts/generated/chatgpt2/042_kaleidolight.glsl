vec2 kaleido(vec2 p) {
  float a = atan(p.y, p.x);
  float r = length(p);
  a = mod(a, Q / 4.0) - Q / 8.0;
  return vec2(C(a), S(a)) * r;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mp = m * 2.0 - 1.0;

  // Apply kaleidoscope effect
  vec2 k = kaleido(uv);
  k += mp * 0.2;

  // Create light pattern
  float light = S(k.x + t) * S(k.y - t);
  light += 0.5 * S(length(k) * 5.0 - t * 2.0);

  // Create rainbow colors
  vec3 color = 0.5 + 0.5 * C(light * 5.0 + vec3(0, 2, 4));
  color *= exp(-length(uv) * 0.7); // Vignette

  return vec4(color, 1.0);
}
