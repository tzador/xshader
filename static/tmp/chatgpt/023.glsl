float noise(vec2 p) {
  return fract(S(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float fbm(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;
  float frequency = 1.0;

  // Add multiple noise layers
  for(float i = 0.0; i < 6.0; i++) {
    value += amplitude * noise(p * frequency);
    amplitude *= 0.5;
    frequency *= 2.0;
  }
  return value;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  uv.y *= 1.5; // Stretch vertically

  // Create base fire shape
  float shape = 1.0 - length(uv - vec2(0.0, -0.5));

  // Add noise-based distortion
  vec2 q = vec2(uv.x * 2.0, uv.y * 2.0 + t * 2.0);

  float noise1 = fbm(q);
  float noise2 = fbm(q * 2.0 + noise1 + t);

  // Create fire pattern
  float fire = shape * (noise1 * 0.5 + noise2 * 0.5);
  fire = smoothstep(0.1, 1.0, fire);

  // Create color gradient
  vec3 color1 = vec3(1.0, 0.2, 0.0); // Orange
  vec3 color2 = vec3(1.0, 0.8, 0.0); // Yellow
  vec3 color3 = vec3(0.8, 0.0, 0.0); // Red

  vec3 fireColor = mix(color3, color1, fire);
  fireColor = mix(fireColor, color2, pow(fire, 2.0));

  // Add flickering
  float flicker = noise(vec2(t * 5.0, 0.0));
  fireColor *= 0.8 + 0.2 * flicker;

  // Add glow
  float glow = exp(-length(uv) * 1.5);
  fireColor += vec3(0.8, 0.3, 0.0) * glow * fire;

  return vec4(fireColor * fire, 1.0);
}
