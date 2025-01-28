float neonLine(vec2 uv, vec2 start, vec2 end, float width) {
  vec2 line = end - start;
  vec2 point = uv - start;
  float len = length(line);
  float proj = clamp(dot(point, line) / (len * len), 0.0, 1.0);

  float dist = length(point - line * proj);
  return smoothstep(width, 0.0, dist);
}

vec3 neonColor(float intensity, vec3 color) {
  return color * pow(intensity, 2.0) + vec3(0.8, 0.8, 0.9) * pow(intensity, 8.0);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create animated neon shapes
  float time = t * 0.5;
  vec3 finalColor = vec3(0.0);

  // Create rotating triangle
  for(float i = 0.0; i < 3.0; i++) {
    float angle1 = time + i * Q / 3.0;
    float angle2 = time + (i + 1.0) * Q / 3.0;

    vec2 point1 = vec2(C(angle1), S(angle1)) * 0.5;
    vec2 point2 = vec2(C(angle2), S(angle2)) * 0.5;

    float line = neonLine(uv, point1, point2, 0.02);
    vec3 color = vec3(S(time + i), C(time + i * 2.0), S(time + i * 3.0));
    finalColor += neonColor(line, color);
  }

  // Add pulsing center
  float center = exp(-length(uv) * 5.0);
  center *= 0.5 + 0.5 * S(time * 3.0);
  finalColor += neonColor(center, vec3(1.0, 0.2, 0.8));

  // Add background glow
  float bgGlow = 0.0;
  for(float i = 0.0; i < 6.0; i++) {
    float angle = time * 0.5 + i * Q / 6.0;
    vec2 glowPos = vec2(C(angle), S(angle)) * 0.8;
    bgGlow += exp(-length(uv - glowPos) * 3.0) * 0.2;
  }
  finalColor += vec3(0.1, 0.2, 0.3) * bgGlow;

  // Add subtle noise
  float noise = fract(S(uv.x * 100.0 + uv.y * 50.0 + time) * 43758.5453);
  finalColor *= 0.95 + 0.05 * noise;

  return vec4(finalColor, 1.0);
}
