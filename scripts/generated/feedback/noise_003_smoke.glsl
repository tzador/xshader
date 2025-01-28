// Smoke Simulation with Noise
// Creates realistic smoke effects using noise-based turbulence

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

vec4 f() {
    // Smoke parameters
  float riseSpeed = 0.001;
  float turbulenceScale = 3.0;
  float fadeRate = 0.99;

    // Base upward motion
  vec2 baseFlow = vec2(0.0, -riseSpeed);

    // Add turbulence from noise
  vec2 noisePos = p * turbulenceScale;
  vec2 turbulence = vec2(snoise(noisePos + vec2(t * 0.3, 0.0)), snoise(noisePos + vec2(0.0, t * 0.3))) * riseSpeed * 2.0;

    // Combined flow
  vec2 flow = baseFlow + turbulence;

    // Sample previous frame with flow
  vec4 previous = texture2D(b, p - flow) * fadeRate;

    // Generate new smoke at bottom
  float source = smoothstep(0.1, 0.0, length(p - vec2(0.5, 0.1)));
  float sourceNoise = snoise(vec2(p.x * 10.0 + t, t)) * 0.5 + 0.5;
  vec4 newSmoke = vec4(0.8 + 0.2 * sourceNoise, 0.8 + 0.2 * sourceNoise, 0.8 + 0.2 * sourceNoise, 1.0) * source;

    // Add temperature variation
  float temp = snoise(noisePos * 2.0 + t * 0.5) * 0.5 + 0.5;
  vec4 heatColor = vec4(temp, temp * 0.7, temp * 0.5, 1.0) * 0.2;

    // Add detail turbulence
  float detail = snoise(noisePos * 5.0 + t) * 0.1;

    // Combine everything
  vec4 result = max(previous, newSmoke);
  result += heatColor * length(flow) * 10.0;
  result += detail;
  result.a = min(result.a, 1.0);

  return result;
}
