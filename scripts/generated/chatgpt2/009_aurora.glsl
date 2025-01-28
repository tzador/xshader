float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
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

  for(float i = 0.0; i < 6.0; i++) {
    value += amplitude * noise(p * frequency);
    amplitude *= 0.5;
    frequency *= 2.0;
  }

  return value;
}

vec3 aurora(vec2 uv, float time) {
  // Create base curtain shape
  float curtain = 0.0;

  for(float i = 1.0; i < 4.0; i++) {
    float scale = 1.0 + i * 0.5;
    vec2 offset = vec2(time * (0.1 + 0.1 * i), 0.0);

    // Create flowing movement
    float flow = fbm(vec2(uv.x * scale + offset.x, uv.y * 2.0 + offset.y));
    flow = pow(flow, 2.0);

    // Create curtain shape
    float height = 0.5 + 0.2 * S(uv.x * 2.0 + time + i);
    float curtainShape = smoothstep(height, height + 0.3, uv.y);

    curtain += flow * (1.0 - curtainShape) * (1.0 / i);
  }

  // Create color variations
  vec3 color1 = vec3(0.1, 0.8, 0.4); // Green
  vec3 color2 = vec3(0.1, 0.4, 0.8); // Blue
  vec3 color3 = vec3(0.8, 0.2, 0.8); // Purple

  float colorMix = S(time * 0.5 + uv.x);
  vec3 auroraColor = mix(mix(color1, color2, colorMix), color3, curtain);

  // Add vertical light rays
  float rays = pow(1.0 - A(uv.y), 5.0);
  auroraColor += vec3(0.2, 0.4, 0.3) * rays * curtain;

  return auroraColor * curtain;
}

vec3 stars(vec2 uv) {
  vec3 color = vec3(0.0);

  // Create multiple layers of stars
  for(float i = 0.0; i < 3.0; i++) {
    vec2 gridUV = uv * (100.0 + i * 50.0);
    vec2 id = floor(gridUV);
    float h = hash(id);

    float star = step(0.99, h);
    float twinkle = 0.5 + 0.5 * S(t * (1.0 + h) + h * Q);

    color += vec3(1.0) * star * twinkle * (0.5 / (i + 1.0));
  }

  return color;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create starry background
  vec3 color = stars(uv);

  // Add aurora
  color += aurora(uv, t);

  // Add atmospheric fog
  float fog = exp(-uv.y * 0.5);
  color = mix(color, vec3(0.0, 0.0, 0.1), fog * 0.5);

  // Add subtle color variations
  color *= 0.8 + 0.2 * S(length(uv) + t);

  return vec4(color, 1.0);
}
