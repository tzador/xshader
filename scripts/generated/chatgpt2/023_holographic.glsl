float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float grid(vec2 p, float scale) {
  vec2 grid = fract(p * scale) - 0.5;
  float lines = smoothstep(0.05, 0.0, abs(grid.x)) +
    smoothstep(0.05, 0.0, abs(grid.y));
  return lines;
}

float dataStream(vec2 p, float seed, float time) {
  // Create flowing data effect
  float stream = 0.0;
  float speed = time * 2.0;

  for(float i = 0.0; i < 3.0; i++) {
    float t = speed + i * 1234.5678 + seed;
    float y = fract(p.y - t);

    // Create binary-like pattern
    float data = step(0.5, hash(vec2(floor(p.x * 10.0), floor(t * 10.0))));
    stream += data * smoothstep(0.1, 0.0, abs(y - 0.5)) *
      smoothstep(0.1, 0.0, abs(p.x));
  }

  return stream;
}

vec2 spaceDistortion(vec2 p, vec2 mousePos, float time) {
  vec2 distortion = vec2(0.0);

  // Create rippling space-time effect
  for(float i = 1.0; i < 4.0; i++) {
    float angle = time * (0.2 + 0.1 * i);
    vec2 offset = vec2(C(angle), S(angle)) * 0.3;

    vec2 center = mousePos + offset;
    float dist = length(p - center);
    float wave = S(dist * 5.0 - time * i);

    distortion += normalize(p - center) * wave * (0.1 / i);
  }

  return distortion;
}

vec3 holographicColor(float value) {
  // Create holographic color palette
  vec3 col1 = vec3(0.0, 0.5, 1.0);  // Blue
  vec3 col2 = vec3(0.0, 1.0, 0.5);  // Cyan
  vec3 col3 = vec3(0.5, 1.0, 1.0);  // Light blue

  value = fract(value);
  float t1 = smoothstep(0.0, 0.5, value);
  float t2 = smoothstep(0.5, 1.0, value);

  return mix(mix(col1, col2, t1), col3, t2);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create space distortion
  vec2 distorted = uv + spaceDistortion(uv, mousePos, t);

  // Create perspective effect
  float perspective = 1.0 + dot(distorted, distorted) * 0.3;
  vec2 perspectiveUV = distorted * perspective;

  // Create multiple grid layers
  float gridPattern = 0.0;
  for(float i = 0.0; i < 3.0; i++) {
    float scale = 5.0 + i * 5.0;
    vec2 rotated = rotate(perspectiveUV, t * (0.1 + 0.05 * i));
    gridPattern += grid(rotated, scale) * (0.5 / (i + 1.0));
  }

  // Create base color from grid
  vec3 color = holographicColor(gridPattern + t * 0.1);

  // Add data streams
  float streams = 0.0;
  for(float i = 0.0; i < 5.0; i++) {
    float angle = i * Q / 5.0 + t * 0.2;
    vec2 rotated = rotate(perspectiveUV, angle);
    streams += dataStream(rotated, i, t) * (0.5 + 0.5 * S(t + i));
  }

  // Add stream colors
  vec3 streamColor = holographicColor(streams - t * 0.2);
  color += streamColor * streams;

  // Add holographic particles
  for(float i = 0.0; i < 20.0; i++) {
    float t_offset = t + i * 1234.5678;
    vec2 particlePos = vec2(hash(vec2(i, t_offset)), hash(vec2(t_offset, i))) * 2.0 - 1.0;

    // Move particles along grid lines
    particlePos = floor(particlePos * 5.0) / 5.0;
    particlePos += spaceDistortion(particlePos, mousePos, t) * 0.5;

    float particle = exp(-length(distorted - particlePos) * 10.0);
    particle *= 0.5 + 0.5 * S(t * 5.0 + hash(particlePos) * 10.0);

    color += holographicColor(particle + i * 0.1) * particle;
  }

  // Add mouse interaction effects
  float mouseGlow = exp(-length(distorted - mousePos) * 3.0);
  color += holographicColor(mouseGlow + t) * mouseGlow;

  // Add depth fade
  float depth = smoothstep(2.0, 0.0, length(perspectiveUV));
  color *= depth;

  // Add scan lines
  float scanLines = 0.5 + 0.5 * S(uv.y * 100.0 + t * 10.0);
  color *= 0.8 + 0.2 * scanLines;

  // Add edge glow
  float edge = smoothstep(1.0, 0.8, length(uv));
  color *= edge;

  // Add subtle noise
  color *= 0.9 + 0.1 * hash(uv + t);

  return vec4(color, 1.0);
}
