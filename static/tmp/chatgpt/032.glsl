float hash(float n) {
  return fract(S(n) * 43758.5453123);
}

vec2 hash2(float n) {
  return vec2(hash(n), hash(n + 1.234));
}

vec2 getParticlePos(float id, float time) {
  vec2 basePos = hash2(id) * 2.0 - 1.0;

  // Create circular motion
  float angle = time * (0.1 + hash(id + 1.0) * 0.2);
  float radius = 0.3 + 0.2 * hash(id + 2.0);
  vec2 orbit = vec2(C(angle), S(angle)) * radius;

  // Add flocking behavior
  vec2 center = vec2(0.0);
  vec2 avgPos = vec2(0.0);
  vec2 avgVel = vec2(0.0);
  float separation = 0.0;

  for(float i = 0.0; i < 10.0; i++) {
    if(i == id)
      continue;
    vec2 otherPos = getParticlePos(i, time - 0.016);
    float dist = length(otherPos - basePos);

    // Cohesion
    avgPos += otherPos;

    // Alignment
    avgVel += (otherPos - getParticlePos(i, time - 0.032)) * 30.0;

    // Separation
    if(dist < 0.2) {
      separation += (basePos - otherPos) / (dist * dist + 0.001);
    }
  }

  avgPos /= 9.0;
  avgVel /= 9.0;

  vec2 cohesion = (avgPos - basePos) * 0.1;
  vec2 alignment = avgVel * 0.1;
  vec2 separate = separation * 0.01;

  return basePos + orbit + cohesion + alignment + separate;
}

float particle(vec2 uv, vec2 pos, float size) {
  float dist = length(uv - pos);
  return smoothstep(size, 0.0, dist);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create particles
  vec3 color = vec3(0.0);
  for(float i = 0.0; i < 50.0; i++) {
    vec2 pos = getParticlePos(i, t);
    float size = 0.02 + 0.01 * S(t * 2.0 + i);

    // Create particle color
    vec3 particleColor = vec3(0.5 + 0.5 * S(t + i), 0.5 + 0.5 * S(t + i + Q / 3.0), 0.5 + 0.5 * S(t + i + Q * 2.0 / 3.0));

    float part = particle(uv, pos, size);
    color += particleColor * part;

    // Add particle trail
    for(float j = 1.0; j <= 5.0; j++) {
      vec2 prevPos = getParticlePos(i, t - 0.02 * j);
      float trail = particle(uv, prevPos, size * (1.0 - j / 5.0));
      color += particleColor * trail * 0.2;
    }
  }

  // Add glow
  float glow = 0.0;
  for(float i = 0.0; i < 50.0; i++) {
    vec2 pos = getParticlePos(i, t);
    glow += exp(-length(uv - pos) * 5.0) * 0.2;
  }
  color += vec3(0.2, 0.4, 0.8) * glow;

  // Add subtle background
  float bg = exp(-length(uv) * 0.5);
  color += vec3(0.0, 0.1, 0.2) * bg;

  return vec4(color, 1.0);
}
