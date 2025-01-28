// Voronoi Pattern with Dynamic Cells
// Creates organic cell patterns with noise-driven movement

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

// Hash function for cell positions
vec2 hash2(vec2 p) {
  vec2 k = vec2(0.3183099, 0.3678794);
  p = p * k + k.yx;
  return -1.0 + 2.0 * fract(16.0 * k * fract(p.x * p.y * (p.x + p.y)));
}

vec4 f() {
    // Parameters
  float fadeRate = 0.97;
  float cellScale = 8.0;
  float moveSpeed = 0.3;
  float noiseScale = 2.0;

    // Scale and get cell coordinate
  vec2 uv = p * cellScale;
  vec2 id = floor(uv);
  vec2 gv = fract(uv) - 0.5;

  float minDist = 1000.0;
  vec2 cellCenter;
  vec2 cellOffset;

    // Find closest cell center
  for(int y = -1; y <= 1; y++) {
    for(int x = -1; x <= 1; x++) {
      vec2 offset = vec2(float(x), float(y));
      vec2 h = hash2(id + offset);

            // Add noise-based movement to cell centers
      vec2 cellPos = offset + 0.5 + h * 0.5;
      cellPos += vec2(snoise(h + t * moveSpeed), snoise(h + vec2(5.0, t * moveSpeed))) * 0.3;

      float dist = length(gv - cellPos);
      if(dist < minDist) {
        minDist = dist;
        cellCenter = id + cellPos;
        cellOffset = offset;
      }
    }
  }

    // Create cell pattern
  float pattern = minDist;

    // Add noise detail to cells
  vec2 noisePos = cellCenter * noiseScale;
  float detail = snoise(noisePos + t * 0.2) * 0.5 + 0.5;

    // Create cell colors
  vec2 h = hash2(cellCenter);
  vec4 cellColor = vec4(0.5 + 0.5 * sin(h.x * 5.0 + t), 0.5 + 0.5 * cos(h.y * 4.0 - t), 0.5 + 0.5 * sin((h.x + h.y) * 3.0 + t), 1.0);

    // Add edge glow
  float edge = smoothstep(0.1, 0.0, abs(pattern - 0.5) - 0.1);
  vec4 edgeColor = vec4(1.0, 0.8, 0.6, 1.0) * edge;

    // Create movement based on cell position
  vec2 flow = normalize(cellCenter - p * cellScale) * 0.001;

    // Sample previous frame with flow
  vec4 previous = texture2D(b, p - flow) * fadeRate;

    // Add cell activity
  float activity = snoise(cellCenter + t * 0.5) * 0.5 + 0.5;
  vec4 activeColor = vec4(activity * sin(t), activity * cos(t * 0.7), activity, 1.0);

    // Combine everything
  vec4 current = mix(cellColor, edgeColor, edge) + activeColor * 0.3;
  current *= smoothstep(1.0, 0.0, pattern * 2.0);
  current += detail * 0.2;

  return max(current, previous);
}
