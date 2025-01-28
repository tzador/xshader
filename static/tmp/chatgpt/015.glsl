float dna(vec2 uv, float offset) {
  float y = uv.y * 10.0 + t + offset;
  float x = uv.x * 5.0;

  float helix = S(y) * 0.5;
  float dist = length(vec2(x - helix, uv.y));
  float thickness = 0.02 + 0.01 * S(y * 2.0);

  return smoothstep(thickness, 0.0, dist);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create two intertwining helices
  float helix1 = dna(uv, 0.0);
  float helix2 = dna(uv, P);

  // Add connecting bars
  float bars = 0.0;
  for(float i = 0.0; i < 10.0; i++) {
    float y = mod(uv.y * 10.0 + t, Q) - P;
    float bar = smoothstep(0.02, 0.0, A(y - i * P / 5.0));
    bars += bar * smoothstep(0.1, 0.0, A(uv.x));
  }

  // Combine with colors
  vec3 color1 = vec3(0.8, 0.2, 0.2);
  vec3 color2 = vec3(0.2, 0.2, 0.8);
  vec3 barColor = vec3(0.9, 0.9, 0.2);

  vec3 finalColor = helix1 * color1 + helix2 * color2 + bars * barColor;

  // Add glow
  float glow = exp(-length(uv));
  finalColor += vec3(0.1, 0.1, 0.3) * glow;

  return vec4(finalColor, 1.0);
}
