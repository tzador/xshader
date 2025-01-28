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

float plasma(vec2 p, vec2 mousePos, float time) {
  float plasma = 0.0;

  // Create multiple plasma layers
  for(float i = 1.0; i < 4.0; i++) {
    vec2 offset = vec2(S(time * i * 0.5), C(time * i * 0.5)) * 0.3;

    // Add mouse influence
    offset += (mousePos - vec2(0.0)) * 0.5;

    // Rotate and distort
    vec2 uv = rotate(p - offset, time * i * 0.2);
    float scale = 2.0 + i;

    // Create plasma pattern
    plasma += fbm(uv * scale + fbm(uv * scale * 0.5 + time));
  }

  return plasma;
}

float lightning(vec2 p, vec2 start, vec2 end, float time, float seed) {
  vec2 dir = end - start;
  float len = length(dir);
  dir = dir / len;

  // Create lightning path
  vec2 normal = vec2(-dir.y, dir.x);
  float d = dot(p - start, normal);
  float proj = dot(p - start, dir);

  // Add random displacement
  float displacement = fbm(vec2(proj * 2.0 + time * 5.0 + seed, seed)) * 0.1;
  d += displacement;

  // Create lightning effect
  float bolt = smoothstep(0.02, 0.0, A(d)) *
    smoothstep(0.0, 0.1, proj) *
    smoothstep(len, len - 0.1, proj);

  return bolt;
}

vec3 neonColor(float value) {
  // Create vibrant neon palette
  vec3 col1 = vec3(0.5, 0.0, 1.0);  // Purple
  vec3 col2 = vec3(0.0, 1.0, 1.0);  // Cyan
  vec3 col3 = vec3(1.0, 0.0, 0.5);  // Pink

  value = fract(value);
  float t1 = smoothstep(0.0, 0.33, value);
  float t2 = smoothstep(0.33, 0.66, value);
  float t3 = smoothstep(0.66, 1.0, value);

  return col1 * (1.0 - t1) + col2 * t2 + col3 * t3;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create base plasma
  float plasmaValue = plasma(uv, mousePos, t);

  // Create color
  vec3 color = neonColor(plasmaValue + t * 0.1);

  // Add lightning bolts
  float bolts = 0.0;
  for(float i = 0.0; i < 5.0; i++) {
    float angle = t * (1.0 + i * 0.2) + i * Q / 5.0;
    vec2 start = vec2(C(angle), S(angle)) * 0.5;
    vec2 end = mousePos;

    bolts += lightning(uv, start, end, t, i * 1234.5678);
  }

  // Add electric glow
  float glow = exp(-length(uv - mousePos) * 2.0);
  color += vec3(0.5, 0.8, 1.0) * glow;

  // Add lightning color
  vec3 boltColor = neonColor(bolts + t * 0.2);
  color += boltColor * bolts * 2.0;

  // Add energy particles
  for(float i = 0.0; i < 10.0; i++) {
    float t_offset = t + i * 1234.5678;
    vec2 particlePos = vec2(hash(vec2(i, t_offset)), hash(vec2(t_offset, i))) * 2.0 - 1.0;

    // Move particles along plasma field
    particlePos += vec2(fbm(particlePos + t), fbm(particlePos + t + 999.0)) * 0.1;

    float particle = exp(-length(uv - particlePos) * 10.0);
    color += neonColor(particle + i * 0.1) * particle;
  }

  // Add edge glow
  float edge = smoothstep(1.0, 0.8, length(uv));
  color *= edge;

  return vec4(color, 1.0);
}
