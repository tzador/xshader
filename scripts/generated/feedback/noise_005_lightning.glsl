// Lightning Effect with Noise
// Creates branching lightning bolts with afterglow

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

float lightning(vec2 pos, float time, float scale) {
    // Create main bolt
  vec2 boltPos = pos * scale;
  float mainBolt = abs(boltPos.x - snoise(vec2(boltPos.y * 2.0 + time * 10.0, time)) * 0.2);
  mainBolt = smoothstep(0.02, 0.0, mainBolt);

    // Create branches
  float branches = 0.0;
  for(float i = 0.0; i < 3.0; i++) {
    float offset = snoise(vec2(boltPos.y * 3.0 + i, time)) * 0.3;
    float branch = abs(boltPos.x - offset - snoise(vec2(boltPos.y * 4.0 + time * 5.0 + i, time)) * 0.1);
    branch = smoothstep(0.01, 0.0, branch) * smoothstep(0.0, 0.2, boltPos.y);
    branches += branch;
  }

  return mainBolt + branches * 0.5;
}

vec4 f() {
    // Lightning parameters
  float fadeRate = 0.95;
  float boltScale = 2.0;

    // Transform coordinates
  vec2 pos = (p - 0.5) * 2.0;
  pos.y += 1.0;  // Start from bottom

    // Create time variation for lightning
  float strikeTime = floor(t * 0.5);
  float strikePhase = fract(t * 0.5);

    // Generate lightning
  float bolt = lightning(pos, strikeTime, boltScale);

    // Add intensity variation
  float intensity = (1.0 - strikePhase * 2.0);
  intensity = max(0.0, intensity);
  bolt *= intensity;

    // Create color with electric blue tint
  vec4 boltColor = vec4(1.0,                            // Red
  1.0,                            // Green
  1.0 + intensity * 0.5,          // Blue (extra intense)
  1.0) * bolt;

    // Add glow effect
  float glow = lightning(pos + vec2(0.02), strikeTime, boltScale) +
    lightning(pos - vec2(0.02), strikeTime, boltScale);
  vec4 glowColor = vec4(0.3, 0.5, 1.0, 1.0) * glow * 0.5;

    // Sample previous frame with slight distortion
  vec2 distortion = vec2(snoise(pos * 5.0 + strikeTime), snoise(pos * 5.0 + vec2(5.0, strikeTime))) * 0.002;
  vec4 previous = texture2D(b, p + distortion) * fadeRate;

    // Add atmospheric effect
  float atmosphere = snoise(pos * 3.0 + t) * 0.1;
  vec4 atmosphereColor = vec4(0.2, 0.3, 0.5, 1.0) * atmosphere * intensity;

    // Combine everything
  return max(max(boltColor + glowColor, atmosphereColor), previous);
}
