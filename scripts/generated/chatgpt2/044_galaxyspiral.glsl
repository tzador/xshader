float star(vec2 p) {
  return pow(0.5 + 0.5 * S(length(p) * 50.0 + t), 20.0);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mp = m * 2.0 - 1.0;

  // Create spiral
  float angle = atan(uv.y, uv.x);
  float r = length(uv);
  float spiral = S(mod(angle * 2.0 + r * 5.0 - t, Q) - 2.0);
  spiral *= exp(-r * 2.0);

  // Add stars
  vec2 st = uv * 3.0;
  st = vec2(st.x * C(t * 0.2) - st.y * S(t * 0.2), st.x * S(t * 0.2) + st.y * C(t * 0.2));
  float stars = star(st) + star(st + 1.234) + star(st - 2.345);

  // Combine colors
  vec3 color = vec3(0.5, 0.2, 1.0) * spiral;
  color += vec3(1.0, 0.8, 0.4) * stars;
  color += vec3(0.4, 0.2, 0.8) * exp(-length(uv - mp * 0.5) * 3.0);

  return vec4(color, 1.0);
}
