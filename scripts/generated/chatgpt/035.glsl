float wave(vec2 uv, vec2 center, float frequency, float phase) {
  float dist = length(uv - center);
  return 0.5 + 0.5 * S(dist * frequency - phase);
}

vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create time-based animation
  float time = t * 0.5;

  // Create multiple wave sources
  float pattern = 0.0;
  for(float i = 0.0; i < 4.0; i++) {
    float angle = time * (0.2 + i * 0.1);
    float radius = 0.8 + 0.2 * S(time + i * P);
    vec2 center = vec2(C(angle), S(angle)) * radius;

    float freq = 10.0 + 5.0 * S(time * 0.5 + i);
    float phase = time * (1.0 + i * 0.2);

    pattern += wave(uv, center, freq, phase);
  }

  // Add mouse interaction
  pattern += wave(uv, m * 2.0 - 1.0, 15.0, time * 2.0) * 2.0;

  // Normalize and create interference
  pattern = mod(pattern, 1.0);
  float interference = smoothstep(0.45, 0.55, pattern);

  // Create color palette
  vec3 color1 = vec3(0.2, 0.5, 0.8);
  vec3 color2 = vec3(0.8, 0.2, 0.5);
  vec3 color = mix(color1, color2, interference);

  // Add wave highlights
  float highlight = smoothstep(0.9, 1.0, pattern);
  color += vec3(1.0) * highlight;

  // Add subtle color variation
  vec2 rotUV = rotate(uv, time * 0.1);
  color *= 0.8 + 0.2 * vec3(S(rotUV.x * 2.0 + time), S(rotUV.y * 2.0 + time + Q / 3.0), S((rotUV.x + rotUV.y) * 2.0 + time + Q * 2.0 / 3.0));

  // Add glow at wave intersections
  float glow = pow(pattern, 4.0);
  color += vec3(0.2, 0.4, 0.8) * glow;

  // Add vignette
  float vignette = 1.0 - length(uv) * 0.5;
  color *= vignette;

  return vec4(color, 1.0);
}
