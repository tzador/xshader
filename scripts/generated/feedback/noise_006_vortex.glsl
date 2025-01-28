// Vortex Effect with Matrix Transformations
// Creates swirling vortex patterns with noise distortion

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

mat2 rotate2d(float angle) {
  float s = sin(angle);
  float c = cos(angle);
  return mat2(c, -s, s, c);
}

vec4 f() {
    // Vortex parameters
  float fadeRate = 0.97;
  float rotationSpeed = 0.5;
  float spiralTightness = 10.0;
  float noiseScale = 3.0;

    // Center coordinates
  vec2 center = vec2(0.5);
  vec2 pos = p - center;

    // Calculate base rotation angle
  float dist = length(pos);
  float angle = atan(pos.y, pos.x);

    // Create spiral distortion
  float spiral = angle + dist * spiralTightness;

    // Create time-varying rotation matrix
  mat2 rot = rotate2d(t * rotationSpeed + spiral);

    // Apply rotation to position
  vec2 rotPos = rot * pos;

    // Add noise-based distortion
  vec2 noisePos = rotPos * noiseScale;
  float noise1 = snoise(noisePos + vec2(t * 0.3));
  float noise2 = snoise(noisePos + vec2(t * 0.5, 10.0));

    // Create distortion vector
  vec2 distortion = vec2(noise1, noise2) * 0.02 * dist;

    // Sample previous frame with spiral movement
  vec2 offset = normalize(rotPos) * 0.002 + distortion;
  vec4 previous = texture2D(b, p - offset) * fadeRate;

    // Create base vortex color
  float vortexIntensity = smoothstep(1.0, 0.0, dist * 2.0);
  vec4 vortexColor = vec4(0.5 + 0.5 * sin(spiral + t), 0.5 + 0.5 * cos(spiral * 0.7 - t), 0.8 + 0.2 * sin(dist * 5.0 + t), 1.0) * vortexIntensity;

    // Add energy field
  float energy = sin(spiral * 5.0 + t * 2.0) * 0.5 + 0.5;
  vec4 energyColor = vec4(energy * sin(t), energy * cos(t * 0.7), energy, 1.0) * smoothstep(0.5, 0.0, dist);

    // Add detail with transformed noise
  vec2 detailPos = rotate2d(spiral) * pos;
  float detail = snoise(detailPos * 20.0 + t) * 0.1 * vortexIntensity;

    // Combine everything
  vec4 current = vortexColor + energyColor * 0.3;
  current += detail;

  return max(current, previous);
}
