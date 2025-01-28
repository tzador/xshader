float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  f = f * f * (3.0 - 2.0 * f);

  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));

  return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;
  float frequency = 1.0;
  for(float i = 0.0; i < 5.0; i++) {
    value += amplitude * noise(p * frequency);
    amplitude *= 0.5;
    frequency *= 2.0;
  }
  return value;
}

vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float probabilityCloud(vec2 p, vec2 center, float time) {
  // Create quantum probability distribution
  float dist = length(p - center);
  float wave = S(dist * 10.0 - time * 2.0);
  float probability = exp(-dist * 3.0) * (0.5 + 0.5 * wave);

  // Add quantum fluctuations
  probability *= 1.0 + 0.2 * fbm(p * 5.0 + time);

  return probability;
}

vec2 quantumField(vec2 p, vec2 mousePos, float time) {
  vec2 field = vec2(0.0);

  // Create quantum field distortions
  for(float i = 1.0; i < 4.0; i++) {
    float angle = time * (0.2 + 0.1 * i);
    vec2 offset = vec2(C(angle), S(angle)) * 0.3;

    vec2 center = mousePos + offset;
    float probability = probabilityCloud(p, center, time * i);

    // Add field vectors
    vec2 direction = normalize(p - center);
    field += direction * probability * (0.5 / i);
  }

  return field;
}

vec3 quantumColor(float value) {
  // Create quantum-inspired color palette
  vec3 col1 = vec3(0.1, 0.2, 0.8);  // Deep blue
  vec3 col2 = vec3(0.8, 0.1, 0.8);  // Purple
  vec3 col3 = vec3(0.1, 0.8, 0.8);  // Cyan

  value = fract(value * 2.0);
  float t1 = smoothstep(0.0, 0.5, value);
  float t2 = smoothstep(0.5, 1.0, value);

  return mix(mix(col1, col2, t1), col3, t2);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Calculate quantum field
  vec2 field = quantumField(uv, mousePos, t);

  // Create probability distribution
  float probability = 0.0;
  for(float i = 0.0; i < 3.0; i++) {
    float angle = t * (0.3 + 0.2 * i);
    vec2 offset = rotate(vec2(0.3, 0.0), angle);
    probability += probabilityCloud(uv + field * 0.2, mousePos + offset, t * (1.0 + i * 0.5));
  }

  // Create base color from probability
  vec3 color = quantumColor(probability + t * 0.1);

  // Add quantum tunneling effect
  float tunnel = 0.0;
  vec2 tunnelDir = normalize(mousePos);
  float tunnelDist = dot(uv - mousePos, tunnelDir);
  tunnel = exp(-abs(tunnelDist) * 5.0) *
    exp(-abs(dot(uv - mousePos, vec2(-tunnelDir.y, tunnelDir.x))) * 10.0);

  // Add tunnel color
  vec3 tunnelColor = quantumColor(tunnel - t * 0.2);
  color = mix(color, tunnelColor, tunnel);

  // Add quantum particles
  for(float i = 0.0; i < 30.0; i++) {
    float t_offset = t + i * 1234.5678;
    vec2 particlePos = vec2(hash(vec2(i, t_offset)), hash(vec2(t_offset, i))) * 2.0 - 1.0;

    // Move particles along quantum field
    particlePos += field * (hash(particlePos + t) * 0.5);

    float particle = exp(-length(uv - particlePos) * 10.0);
    particle *= 0.5 + 0.5 * S(t * 10.0 + hash(particlePos) * 10.0);

    color += quantumColor(particle + i * 0.1) * particle;
  }

  // Add interference patterns
  float interference = 0.0;
  for(float i = 0.0; i < 3.0; i++) {
    float angle = t * 0.2 + i * Q / 3.0;
    vec2 dir = vec2(C(angle), S(angle));
    interference += S(dot(uv, dir) * 20.0 + t * 2.0) * 0.1;
  }
  color += vec3(0.5, 0.8, 1.0) * interference;

  // Add edge effects
  float edge = smoothstep(1.0, 0.8, length(uv));
  color *= edge;

  // Add quantum glow
  float glow = exp(-length(uv - mousePos) * 2.0);
  color += quantumColor(glow + t) * glow;

  return vec4(color, 1.0);
}
