vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float helix(vec2 uv, float offset) {
  float angle = atan(uv.y, uv.x);
  float dist = length(uv);

  // Create helix pattern
  float spiral = S(angle * 2.0 + dist * 5.0 + t * 2.0 + offset);
  float thickness = 0.1;

  return smoothstep(thickness, 0.0, A(spiral));
}

float particle(vec2 uv, vec2 pos, float size) {
  return exp(-length(uv - pos) * size);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  uv.x *= 1.5; // Adjust aspect ratio

  // Rotate entire view
  uv = rotate(uv, t * 0.2);

  // Create two helices with offset
  float h1 = helix(uv, 0.0);
  float h2 = helix(uv, P);

  // Add particles moving along the helices
  float particles = 0.0;
  for(float i = 0.0; i < 10.0; i++) {
    float offset = i * Q / 10.0 + t;
    vec2 pos = vec2(C(offset), S(offset)) * 0.5;
    particles += particle(uv, pos, 20.0);
  }

  // Create colors
  vec3 color1 = vec3(0.2, 0.5, 0.8); // Blue strand
  vec3 color2 = vec3(0.8, 0.2, 0.5); // Pink strand
  vec3 particleColor = vec3(1.0, 0.9, 0.7); // Warm particle color

  // Combine everything
  vec3 finalColor = color1 * h1 + color2 * h2 + particleColor * particles;

  // Add glow
  float glow = exp(-length(uv) * 1.5);
  finalColor += vec3(0.1, 0.2, 0.3) * glow;

  return vec4(finalColor, 1.0);
}
