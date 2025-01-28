float aurora(vec2 p) {
  float r = length(p);
  float a = atan(p.y, p.x) * 3.0;
  float wave = S(r - 0.5 + 0.2 * S(a + t * 2.0));
  return wave * smoothstep(1.0, 0.5, r);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mp = m * 2.0 - 1.0;

  // Create flowing aurora
  vec2 warp = vec2(S(t * 0.7), C(t * 0.5)) * 0.2;
  float aur = aurora(uv + warp + mp * 0.1);
  aur += aurora(uv * 1.2 - warp) * 0.5;

  // Create colors
  vec3 color = mix(vec3(0.0, 0.8, 0.4), vec3(0.0, 0.4, 0.8), aur);
  color += vec3(0.0, 1.0, 0.5) * pow(aur, 3.0);

  return vec4(color, 1.0);
}
