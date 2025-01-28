float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);

  // Cubic Hermine Curve
  vec2 u = f * f * (3.0 - 2.0 * f);

  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));

  return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
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

vec3 terrain(vec2 p, float height) {
  // Create color gradient based on height
  vec3 rock = vec3(0.4, 0.3, 0.2);
  vec3 grass = vec3(0.2, 0.5, 0.1);
  vec3 snow = vec3(0.9, 0.9, 1.0);

  vec3 color = mix(rock, grass, smoothstep(0.2, 0.4, height));
  color = mix(color, snow, smoothstep(0.6, 0.8, height));

  return color;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create time-based animation
  float time = t * 0.2;

  // Create landscape movement
  vec2 movement = vec2(time * 0.1, 0.0);

  // Generate fractal noise
  float height = fbm(uv * 3.0 + movement);
  height += 0.5 * fbm(uv * 6.0 - movement);
  height += 0.25 * fbm(uv * 12.0 + movement * 2.0);
  height = height / 1.75;

  // Create terrain color
  vec3 color = terrain(uv, height);

  // Add height-based shading
  float shade = 0.5 + 0.5 * S(height * 5.0 + time);
  color *= 0.8 + 0.2 * shade;

  // Add fog in valleys
  float fog = smoothstep(0.3, 0.0, height);
  color = mix(color, vec3(0.6, 0.7, 0.8), fog * 0.5);

  // Add directional lighting
  vec2 lightDir = normalize(vec2(1.0, 0.5));
  float light = dot(vec2(dFdx(height), dFdy(height)), lightDir);
  color *= 0.8 + 0.2 * smoothstep(-0.2, 0.2, light);

  // Add atmospheric perspective
  float atmosphere = smoothstep(0.0, 1.0, length(uv));
  color = mix(color, vec3(0.6, 0.7, 0.8), atmosphere * 0.5);

  // Add subtle animation to colors
  color *= 0.9 + 0.1 * S(time + uv.x + uv.y);

  return vec4(color, 1.0);
}
