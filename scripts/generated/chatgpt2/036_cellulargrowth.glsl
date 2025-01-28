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

struct Cell {
  vec2 position;
  float size;
  float age;
  float energy;
};

Cell createCell(float index, float time) {
  Cell cell;

  // Initialize cell properties with some randomness
  float angle = index * Q / 10.0 + time * 0.1;
  float radius = 1.0 + hash(vec2(index)) * 0.5;

  cell.position = vec2(radius * C(angle), radius * S(angle));

  cell.size = 0.2 + 0.1 * S(time + index * 1234.5);
  cell.age = mod(time + index * 987.6, 10.0);
  cell.energy = 0.5 + 0.5 * S(time * 2.0 + index * 345.6);

  return cell;
}

float cellField(vec2 p, Cell cell) {
  float d = length(p - cell.position) - cell.size;

  // Add membrane fluctuation
  float membrane = 0.02 * S(cell.age * 5.0 + length(p) * 10.0);
  d -= membrane;

  // Add energy pulse
  float pulse = 0.05 * cell.energy * S(cell.age * 10.0);
  d -= pulse;

  return d;
}

vec3 cellColor(Cell cell, float d) {
  // Create organic color palette
  vec3 membraneColor = vec3(0.1, 0.8, 0.4);  // Green
  vec3 nucleusColor = vec3(0.0, 0.5, 1.0);   // Blue
  vec3 energyColor = vec3(1.0, 0.8, 0.2);    // Yellow

  // Mix colors based on distance and cell properties
  float membrane = smoothstep(-0.05, 0.05, d);
  float nucleus = smoothstep(0.1, -0.1, d);

  vec3 color = mix(membraneColor, nucleusColor, nucleus);
  color += energyColor * cell.energy * (1.0 - membrane) * 0.5;

  return color;
}

float growthPattern(vec2 p, float time) {
  float pattern = 0.0;

  // Create organic growth pattern
  for(float i = 0.0; i < 3.0; i++) {
    float scale = pow(2.0, i);
    vec2 q = p * scale;
    q += vec2(S(time * (0.5 + i * 0.1)), C(time * (0.4 + i * 0.1)));
    pattern += fbm(q) / scale;
  }

  return pattern;
}

vec3 bioluminescence(vec2 p, float time) {
  // Create bioluminescent glow
  vec3 color = vec3(0.0);

  float pattern = growthPattern(p, time);
  float glow = exp(-pattern * 5.0);

  color += vec3(0.0, 0.5, 1.0) * glow;          // Blue
  color += vec3(0.0, 1.0, 0.5) * glow * glow;   // Green
  color += vec3(1.0, 0.8, 0.0) * pow(glow, 3.0);// Yellow

  return color;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create cells
  const float NUM_CELLS = 10.0;
  Cell[10] cells;
  for(float i = 0.0; i < NUM_CELLS; i++) {
    cells[int(i)] = createCell(i, t);
  }

  // Calculate minimum distance to cells
  float minDist = 1e10;
  Cell nearestCell;

  for(float i = 0.0; i < NUM_CELLS; i++) {
    float d = cellField(uv, cells[int(i)]);
    if(d < minDist) {
      minDist = d;
      nearestCell = cells[int(i)];
    }
  }

  // Create base color from nearest cell
  vec3 color = cellColor(nearestCell, minDist);

  // Add cell interaction glow
  for(float i = 0.0; i < NUM_CELLS; i++) {
    for(float j = i + 1.0; j < NUM_CELLS; j++) {
      vec2 midpoint = (cells[int(i)].position + cells[int(j)].position) * 0.5;
      float interaction = exp(-length(uv - midpoint) * 5.0);
      interaction *= cells[int(i)].energy * cells[int(j)].energy;
      color += vec3(0.2, 0.5, 1.0) * interaction;
    }
  }

  // Add growth pattern
  float growth = growthPattern(uv, t);
  color *= 0.8 + 0.2 * growth;

  // Add bioluminescence
  color += bioluminescence(uv, t) * 0.5;

  // Add mouse interaction
  float mouseInfluence = exp(-length(uv - mousePos) * 3.0);
  color += vec3(1.0, 0.8, 0.5) * mouseInfluence * 0.5;

  // Add edge glow
  float edge = abs(minDist);
  color += vec3(0.0, 1.0, 0.5) * exp(-edge * 10.0);

  // Add vignette
  float vignette = 1.0 - length(uv) * 0.5;
  color *= vignette;

  // Tone mapping and gamma correction
  color = color / (color + vec3(1.0));
  color = pow(color, vec3(0.4545));

  return vec4(color, 1.0);
}
