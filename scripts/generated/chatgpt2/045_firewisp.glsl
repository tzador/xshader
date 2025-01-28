float wisp(vec2 p, vec2 center) {
  vec2 d = p - center;
  float a = atan(d.y, d.x) * 3.0;
  return exp(-length(d) * 2.0) * (0.5 + 0.5 * S(a + t * 3.0));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mp = m * 2.0 - 1.0;

  // Create multiple wisps
  float w = wisp(uv, mp);
  w += wisp(uv, mp + vec2(S(t), C(t)) * 0.2) * 0.7;
  w += wisp(uv, mp - vec2(C(t * 0.7), S(t * 0.7)) * 0.3) * 0.5;

  // Create fire colors
  vec3 color = vec3(1.0, 0.5, 0.1) * w;
  color += vec3(1.0, 0.8, 0.3) * pow(w, 2.0);
  color += vec3(0.3, 0.1, 0.0) * exp(-length(uv) * 1.5);

  return vec4(color, 1.0);
}
