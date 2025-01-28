float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 noise2D(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);

  // Cubic Hermine Curve
  vec2 u = f * f * (3.0 - 2.0 * f);

  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));

  return vec2(mix(mix(a, b, u.x), mix(c, d, u.x), u.y), mix(mix(c - a, d - b, u.x), mix(0.0, 0.0, u.x), u.y));
}

vec2 curlNoise(vec2 p) {
  const float h = 0.01;

  float n1 = noise2D(p + vec2(0.0, h)).x;
  float n2 = noise2D(p - vec2(0.0, h)).x;
  float n3 = noise2D(p + vec2(h, 0.0)).x;
  float n4 = noise2D(p - vec2(h, 0.0)).x;

  return vec2((n1 - n2) / (2.0 * h), -(n3 - n4) / (2.0 * h));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create fluid motion
  float time = t * 0.2;
  vec2 flow = vec2(0.0);

  // Add multiple layers of curl noise
  for(float i = 1.0; i < 4.0; i++) {
    float scale = pow(2.0, i);
    vec2 offset = vec2(time * (0.5 + i * 0.1), time * (0.3 + i * 0.2));
    flow += curlNoise((uv + offset) * scale) / scale;
  }

  // Add mouse interaction
  vec2 mouseDir = uv - (m * 2.0 - 1.0);
  float mouseDist = length(mouseDir);
  flow += normalize(mouseDir) * smoothstep(0.5, 0.0, mouseDist) * 0.5;

  // Create color based on flow
  float flowLen = length(flow);
  vec3 color1 = vec3(0.1, 0.4, 0.7); // Blue
  vec3 color2 = vec3(0.7, 0.2, 0.4); // Red
  vec3 color = mix(color1, color2, flowLen);

  // Add swirl patterns
  float swirl = S(dot(normalize(flow), uv) * 5.0 + time * 2.0);
  color = mix(color, vec3(1.0), swirl * 0.2);

  // Add velocity-based brightness
  float speed = length(flow);
  color *= 0.8 + speed * 2.0;

  // Add subtle glow
  float glow = exp(-length(uv) * 2.0);
  color += vec3(0.2, 0.3, 0.4) * glow;

  return vec4(color, 1.0);
}
