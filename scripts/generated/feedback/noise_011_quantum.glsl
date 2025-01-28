// Quantum Wave Function Visualization
// Creates complex interference patterns with fluid dynamics

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

// Complex number operations
vec2 cmul(vec2 a, vec2 b) {
  return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

vec2 cdiv(vec2 a, vec2 b) {
  float denom = dot(b, b);
  return vec2(dot(a, b), a.y * b.x - a.x * b.y) / denom;
}

vec2 cexp(vec2 z) {
  return exp(z.x) * vec2(cos(z.y), sin(z.y));
}

// Quantum wave packet
vec2 wavePacket(vec2 pos, vec2 k, float width, float phase) {
  float gauss = exp(-dot(pos, pos) / (2.0 * width * width));
  return gauss * vec2(cos(dot(k, pos) + phase), sin(dot(k, pos) + phase));
}

// Fluid dynamics
vec2 curl(vec2 p, float eps) {
  float n1 = snoise(p + vec2(0.0, eps));
  float n2 = snoise(p - vec2(0.0, eps));
  float n3 = snoise(p + vec2(eps, 0.0));
  float n4 = snoise(p - vec2(eps, 0.0));

  return vec2((n1 - n2) / (2.0 * eps), -(n3 - n4) / (2.0 * eps));
}

vec4 f() {
    // System parameters
  float fadeRate = 0.98;
  float timeScale = 0.2;
  float noiseScale = 3.0;
  float fluidScale = 2.0;
  float quantumScale = 5.0;

    // Center coordinates
  vec2 center = vec2(0.5);
  vec2 pos = (p - center) * 2.0;

    // Create quantum wave function
  vec2 k1 = vec2(cos(t * 0.5), sin(t * 0.7));
  vec2 k2 = vec2(cos(t * 0.3), sin(t * 0.4));
  vec2 psi1 = wavePacket(pos, k1, 0.5, t);
  vec2 psi2 = wavePacket(pos, k2, 0.3, t * 1.5);

    // Combine wave functions with interference
  vec2 psi = cmul(psi1, psi2);
  float probability = dot(psi, psi);

    // Add fluid dynamics
  vec2 fluidPos = pos * fluidScale;
  vec2 velocity = curl(fluidPos + t * 0.1, 0.1);

    // Create quantum potential
  vec2 potentialPos = pos * quantumScale;
  float potential = snoise(potentialPos + t * 0.2);
  potential += 0.5 * snoise(potentialPos * 2.0 - t * 0.3);

    // Apply quantum tunneling effect
  vec2 tunnel = cexp(vec2(0.0, potential * probability));
  psi = cmul(psi, tunnel);

    // Create visualization color
  vec4 waveColor = vec4(0.5 + 0.5 * psi.x, 0.5 + 0.5 * psi.y, 0.5 + 0.5 * probability, 1.0);

    // Add fluid-based distortion
  vec2 distortion = velocity * 0.01;
  vec2 noisePos = (pos + distortion) * noiseScale;
  float detail = snoise(noisePos + t * timeScale) * 0.2;

    // Add quantum interference patterns
  float interference = length(cdiv(psi1, psi2));
  vec4 interferenceColor = vec4(0.5 + 0.5 * sin(interference * 10.0 + t), 0.5 + 0.5 * cos(interference * 8.0 - t), 0.5 + 0.5 * sin(interference * 6.0 + t * 0.7), 1.0);

    // Add energy field visualization
  float energy = potential * probability;
  vec4 energyColor = vec4(energy * sin(t), energy * cos(t * 0.7), energy, 1.0) * smoothstep(1.0, 0.0, length(pos));

    // Sample previous frame with quantum-fluid movement
  vec2 offset = distortion + normalize(psi) * 0.001;
  vec4 previous = texture2D(b, p - offset) * fadeRate;

    // Add quantum vortices
  float vortex = atan(velocity.y, velocity.x) / 6.28318 + 0.5;
  vec4 vortexColor = vec4(vortex * sin(t * 2.0), vortex * cos(t * 1.5), vortex, 1.0) * length(velocity);

    // Combine everything with sophisticated blending
  vec4 current = waveColor * 0.4 + interferenceColor * 0.3 + energyColor * 0.2 + vortexColor * 0.1;
  current += detail;

    // Add quantum tunneling glow
  float glow = exp(-length(pos) * probability);
  current += vec4(0.2, 0.4, 0.8, 1.0) * glow;

  return max(current, previous);
}
