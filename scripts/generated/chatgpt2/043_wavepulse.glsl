float wave(vec2 p, vec2 center) {
  float d = length(p - center);
  return S(d * 10.0 - t * 5.0) / (d + 0.2);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mp = m * 2.0 - 1.0;

  // Create multiple wave sources
  float w = wave(uv, mp);
  w += wave(uv, vec2(S(t), C(t)) * 0.5);
  w += wave(uv, -vec2(C(t * 0.7), S(t * 0.7)) * 0.3);

  // Create interference color
  vec3 color = vec3(0.2, 0.5, 1.0) * w;
  color += vec3(0.1, 0.3, 0.8) * pow(w, 2.0);
  color += vec3(0.0, 0.2, 0.5) * exp(-length(uv) * 2.0); // Background glow

  return vec4(color, 1.0);
}
