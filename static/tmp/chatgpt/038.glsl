float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 reaction(vec2 uv, float time) {
  vec2 n = floor(uv * 10.0);
  vec2 f = fract(uv * 10.0);

  // Create chemical concentrations A and B
  float a = 0.0;
  float b = 0.0;

  // Add multiple reaction centers
  for(float i = 0.0; i < 5.0; i++) {
    float phase = hash(vec2(i, floor(time)));
    vec2 center = vec2(C(time * 0.5 + i * P), S(time * 0.3 + i * P)) * 0.5;

    float dist = length(uv - center);
    float reaction = smoothstep(0.2, 0.0, dist) * S(time * 2.0 + i);

    a += reaction;
    b += reaction * (0.8 + 0.2 * S(dist * 10.0 - time));
  }

  // Add noise-based variations
  float noise = hash(n + time);
  a += noise * 0.1;
  b += noise * 0.05;

  return vec2(a, b);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create time-based animation
  float time = t * 0.5;

  // Get reaction-diffusion values
  vec2 react = reaction(uv, time);
  float a = react.x;
  float b = react.y;

  // Create patterns based on chemical interactions
  float pattern = smoothstep(0.4, 0.6, a - b);
  pattern *= smoothstep(0.0, 0.1, a) * smoothstep(0.0, 0.1, b);

  // Create color palette
  vec3 color1 = vec3(0.2, 0.1, 0.3); // Dark purple
  vec3 color2 = vec3(0.8, 0.2, 0.5); // Pink
  vec3 color3 = vec3(0.1, 0.4, 0.6); // Blue

  // Mix colors based on chemical concentrations
  vec3 color = mix(color1, color2, pattern);
  color = mix(color, color3, smoothstep(0.4, 0.6, b));

  // Add edge highlights
  float edge = length(vec2(dFdx(pattern), dFdy(pattern)));
  color += vec3(1.0) * edge * 2.0;

  // Add subtle pulsing
  color *= 0.8 + 0.2 * S(time * 2.0 + uv.x + uv.y);

  // Add glow at reaction centers
  float glow = max(a, b) * smoothstep(0.5, 0.0, length(uv));
  color += vec3(0.5, 0.2, 0.3) * glow;

  // Add vignette
  float vignette = 1.0 - length(uv) * 0.5;
  color *= vignette;

  return vec4(color, 1.0);
}
