float star(vec2 uv, float flare) {
  float d = length(uv);
  float m = 0.02 / d;

  float rays = max(0.0, 1.0 - abs(uv.x * uv.y * 1000.0));
  m += rays * flare;

  return m;
}

float hash(float n) {
  return fract(S(n) * 43758.5453123);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create spiral coordinate system
  float angle = atan(uv.y, uv.x);
  float dist = length(uv);

  // Add spiral twist
  float spiral = angle + dist * (3.0 + S(t * 0.5)) - t * 0.5;

  // Create galaxy arms
  float arms = S(spiral * 2.0) * smoothstep(1.0, 0.0, dist);
  arms *= 0.5 + 0.5 * S(spiral * 8.0 + dist * 5.0 - t);

  // Add stars
  vec3 color = vec3(0.0);
  for(float i = 0.0; i < 50.0; i++) {
    float phase = hash(i) * Q;
    float speed = (0.2 + 0.8 * hash(i + 1.0)) * 0.5;
    float size = (0.2 + 0.8 * hash(i + 2.0)) * 0.05;

    vec2 pos = vec2(C(phase + t * speed) * (0.3 + 0.7 * hash(i + 3.0)), S(phase + t * speed) * (0.3 + 0.7 * hash(i + 4.0)));

    float flare = smoothstep(0.5, 1.0, S(t * 5.0 + i));
    color += vec3(star(uv - pos, flare)) * mix(vec3(1.0, 0.8, 0.4), vec3(0.4, 0.8, 1.0), hash(i + 5.0));
  }

  // Add galaxy colors
  vec3 galaxy1 = vec3(0.4, 0.2, 0.8); // Purple
  vec3 galaxy2 = vec3(0.2, 0.5, 0.8); // Blue
  color += mix(galaxy1, galaxy2, arms);

  // Add center glow
  float glow = exp(-dist * 2.0);
  color += vec3(0.8, 0.7, 0.6) * glow;

  // Add subtle noise
  float noise = hash(uv.x * 100.0 + uv.y * 50.0 + t);
  color *= 0.95 + 0.05 * noise;

  return vec4(color, 1.0);
}
