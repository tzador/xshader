// Flow Field with Simplex Noise
// Creates flowing patterns guided by noise-based vector field

// Simplex noise function from https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
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
    // Flow parameters
  float noiseScale = 3.0;
  float timeScale = 0.2;
  float flowStrength = 0.003;
  float fadeRate = 0.98;

    // Sample noise at different offsets for flow field
  vec2 noisePos = p * noiseScale;
  float noise1 = snoise(noisePos + vec2(t * timeScale, 0.0));
  float noise2 = snoise(noisePos + vec2(0.0, t * timeScale));

    // Create flow vector from noise
  vec2 flow = vec2(noise1, noise2) * flowStrength;

    // Add rotational component
  vec2 center = p - 0.5;
  float angle = atan(center.y, center.x);
  vec2 rotation = vec2(cos(angle), sin(angle)) * length(center) * flowStrength;
  flow += rotation;

    // Sample previous frame with flow offset
  vec4 previous = texture2D(b, p - flow) * fadeRate;

    // Create color based on noise and flow
  float flowLen = length(flow) / flowStrength;
  vec4 flowColor = vec4(0.5 + 0.5 * sin(noise1 * 5.0 + t), 0.5 + 0.5 * cos(noise2 * 4.0 - t), 0.7 + 0.3 * sin(flowLen * 10.0 + t * 2.0), 1.0);

    // Add detail noise for texture
  float detail = snoise(noisePos * 5.0 + t) * 0.1;

    // Combine with feedback
  return max(flowColor + detail, previous);
}
