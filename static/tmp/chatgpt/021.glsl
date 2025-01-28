float ripple(vec2 uv, vec2 center, float time) {
  float dist = length(uv - center);
  float wave = S(dist * 10.0 - time * 5.0);
  return wave * smoothstep(2.0, 0.0, dist);
}

vec2 distort(vec2 uv) {
  vec2 distortion = vec2(0.0);

  // Create multiple ripple sources
  for(float i = 0.0; i < 5.0; i++) {
    float t_offset = t + i * P;
    vec2 center = vec2(C(t_offset * 0.4) * 0.5, S(t_offset * 0.3) * 0.5);

    float wave = ripple(uv, center, t_offset);
    vec2 direction = normalize(uv - center);
    distortion += direction * wave * 0.02;
  }

  // Add mouse interaction
  float mouseWave = ripple(uv, m * 2.0 - 1.0, t * 3.0);
  distortion += normalize(uv - (m * 2.0 - 1.0)) * mouseWave * 0.05;

  return uv + distortion;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create base water pattern
  vec2 distorted = distort(uv);
  float pattern = S(distorted.x * 10.0 + t) * S(distorted.y * 8.0 - t);

  // Create water colors
  vec3 waterLight = vec3(0.2, 0.5, 0.8);
  vec3 waterDark = vec3(0.1, 0.2, 0.4);
  vec3 highlight = vec3(1.0, 1.0, 1.0);

  // Mix colors based on pattern
  vec3 waterColor = mix(waterDark, waterLight, 0.5 + 0.5 * pattern);

  // Add highlights
  float spec = pow(max(0.0, pattern), 10.0);
  waterColor += highlight * spec * 0.5;

  // Add caustics effect
  float caustics = 0.5 + 0.5 * S(length(distorted) * 5.0 - t * 2.0);
  waterColor += vec3(0.2, 0.3, 0.4) * caustics * 0.2;

  // Add vignette
  float vignette = 1.0 - length(uv) * 0.5;
  waterColor *= vignette;

  return vec4(waterColor, 1.0);
}
