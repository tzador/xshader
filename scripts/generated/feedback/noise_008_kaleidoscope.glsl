// Kaleidoscope Effect with Noise
// Creates symmetric patterns with dynamic noise

// Simplex noise function
vec3 permute(vec3 x) {
  return mod(((x * 34.0) + 1.0) * x, 289.0);
}

float snoise(vec2 v) {
  const vec4 C = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);
  vec2 i = floor(v + dot(v, C.yy));
  vec2 x0 = v - i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0)) + i.x + vec3(0.0, i1.x, 1.0));
  vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
  m = m * m;
  m = m * m;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);
  vec3 g;
  g.x = a0.x * x0.x + h.x * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

// Kaleidoscope coordinate transform
vec2 kaleido(vec2 uv, float segments) {
  float angle = atan(uv.y, uv.x);
  float radius = length(uv);

    // Divide space into segments
  float segmentAngle = 3.14159 * 2.0 / segments;
  angle = mod(angle, segmentAngle);
  if(mod(angle, segmentAngle * 2.0) >= segmentAngle) {
    angle = segmentAngle - mod(angle, segmentAngle);
  }

  return vec2(cos(angle), sin(angle)) * radius;
}

vec4 f() {
    // Parameters
  float fadeRate = 0.97;
  float segments = 12.0;
  float noiseScale = 3.0;
  float rotationSpeed = 0.2;

    // Center and scale coordinates
  vec2 center = vec2(0.5);
  vec2 uv = (p - center) * 2.0;

    // Apply kaleidoscope transform
  vec2 kpos = kaleido(uv, segments);

    // Rotate pattern
  float angle = t * rotationSpeed;
  mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
  kpos = rot * kpos;

    // Create base pattern with noise
  vec2 noisePos = kpos * noiseScale;
  float pattern = snoise(noisePos + vec2(t * 0.2));
  pattern += snoise(noisePos * 2.0 - vec2(t * 0.3)) * 0.5;
  pattern += snoise(noisePos * 4.0 + vec2(t * 0.4)) * 0.25;
  pattern = pattern / 1.75;

    // Create color based on pattern and position
  float angle2 = atan(kpos.y, kpos.x);
  float radius = length(kpos);
  vec4 color = vec4(0.5 + 0.5 * sin(pattern * 5.0 + t), 0.5 + 0.5 * cos(pattern * 4.0 - t * 0.7), 0.5 + 0.5 * sin(pattern * 3.0 + t * 0.3), 1.0);

    // Add radial waves
  float waves = sin(radius * 20.0 - t * 2.0) * 0.5 + 0.5;
  vec4 waveColor = vec4(waves * sin(angle2 * 3.0), waves * cos(angle2 * 2.0), waves, 1.0);

    // Create movement offset
  vec2 offset = vec2(snoise(noisePos + t), snoise(noisePos + vec2(5.0, t))) * 0.002;

    // Sample previous frame with offset
  vec4 previous = texture2D(b, p - offset) * fadeRate;

    // Add edge highlights
  float edge = smoothstep(0.1, 0.0, abs(mod(angle2 * segments / 3.14159, 2.0) - 1.0));
  vec4 edgeColor = vec4(1.0, 0.8, 0.6, 1.0) * edge;

    // Combine everything
  vec4 current = color * 0.6 + waveColor * 0.4 + edgeColor * 0.2;
  current *= smoothstep(1.0, 0.8, radius);

  return max(current, previous);
}
