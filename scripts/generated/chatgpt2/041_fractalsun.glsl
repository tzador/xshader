float corona(vec2 uv, float time) {
  float angle = atan(uv.y, uv.x);
  float rays = abs(S(angle * 8.0 + time));
  float rings = S(length(uv) * 5.0 - time * 2.0);
  return rays * rings / (length(uv) + 0.1);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mp = m * 2.0 - 1.0;

  // Create sun core
  float core = exp(-length(uv) * 3.0);

  // Create corona
  float cor = corona(uv + mp * 0.2, t);
  cor += corona(uv * 1.5, -t * 0.5) * 0.5;

  // Combine and colorize
  vec3 color = vec3(1.0, 0.5, 0.2) * core;
  color += vec3(1.0, 0.8, 0.4) * cor;
  color += vec3(0.8, 0.3, 0.1) * pow(cor, 2.0);

  return vec4(color, 1.0);
}
