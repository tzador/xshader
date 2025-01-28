float noise(vec2 p) {
  return fract(S(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float lightning(vec2 uv, vec2 center) {
  vec2 dir = normalize(uv - center);
  float angle = atan(dir.y, dir.x);
  float dist = length(uv - center);

  float bolt = 0.0;
  for(float i = 0.0; i < 5.0; i++) {
    float offset = noise(vec2(i, t * 0.5)) * Q;
    float thickness = 0.02 * (1.0 - dist);
    float curve = S(angle * 3.0 + offset + t) * 0.2;
    bolt += smoothstep(thickness, 0.0, A(dist - 0.3 - curve));
  }

  return bolt;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create central sphere
  float sphere = smoothstep(0.3, 0.29, length(uv));

  // Create lightning bolts
  float bolts = 0.0;
  for(float i = 0.0; i < 6.0; i++) {
    float angle = i * Q / 6.0 + t * 0.2;
    vec2 pos = vec2(C(angle), S(angle)) * 0.3;
    bolts += lightning(uv, pos);
  }

  // Add colors
  vec3 sphereColor = vec3(0.2, 0.4, 1.0);
  vec3 boltColor = vec3(0.6, 0.8, 1.0);

  vec3 finalColor = sphere * sphereColor + bolts * boltColor;

  // Add glow
  float glow = exp(-length(uv) * 2.0);
  finalColor += vec3(0.1, 0.2, 0.8) * glow;

  return vec4(finalColor, 1.0);
}
