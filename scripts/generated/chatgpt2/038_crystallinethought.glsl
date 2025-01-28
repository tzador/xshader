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

float voronoi(vec2 p) {
  vec2 n = floor(p);
  vec2 f = fract(p);

  float md = 5.0;
  vec2 mr;

  for(int j = -1; j <= 1; j++) {
    for(int i = -1; i <= 1; i++) {
      vec2 g = vec2(float(i), float(j));
      vec2 o = hash(n + g);
      o = 0.5 + 0.5 * sin(t * 0.5 + 6.2831 * o);

      vec2 r = g + o - f;
      float d = dot(r, r);

      if(d < md) {
        md = d;
        mr = r;
      }
    }
  }

  return md;
}

float crystalPattern(vec2 p) {
  float pattern = 0.0;
  float scale = 1.0;

  for(int i = 0; i < 3; i++) {
    pattern += voronoi(p * scale) / scale;
    scale *= 2.0;
  }

  return pattern;
}

vec2 rotate2D(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float thoughtField(vec2 p) {
  float field = 0.0;

  // Create neural network-like connections
  for(float i = 0.0; i < 5.0; i++) {
    float angle = i * Q / 5.0 + t * 0.2;
    vec2 center = vec2(C(angle), S(angle)) * 0.5;

    // Create synaptic connections
    vec2 q = p - center;
    q = rotate2D(q, t * (0.1 + i * 0.05));

    float activation = exp(-length(q) * 5.0);
    activation *= S(t * 2.0 + i * 1234.5);

    field += activation;
  }

  return field;
}

vec3 crystalColor(float pattern, float thought) {
  // Create crystalline color palette
  vec3 crystal1 = vec3(0.1, 0.5, 0.8);   // Blue
  vec3 crystal2 = vec3(0.8, 0.2, 0.5);   // Pink
  vec3 crystal3 = vec3(0.2, 0.8, 0.5);   // Green
  vec3 glow = vec3(1.0, 0.8, 0.2);       // Yellow

  // Mix colors based on pattern and thought field
  float t1 = fract(pattern * 3.0);
  float t2 = fract(pattern * 2.0 + thought);

  vec3 color = mix(crystal1, crystal2, t1);
  color = mix(color, crystal3, t2);

  // Add thought-based glow
  color += glow * thought * thought;

  return color;
}

float crystallineEdge(vec2 p) {
  float pattern = crystalPattern(p);
  float edge = abs(pattern - crystalPattern(p + vec2(0.01, 0.0)));
  edge += abs(pattern - crystalPattern(p + vec2(0.0, 0.01)));
  return edge;
}

vec3 thoughtPatterns(vec2 p) {
  // Create base crystalline pattern
  float pattern = crystalPattern(p);

  // Add thought field influence
  float thought = thoughtField(p);

  // Calculate edges
  float edge = crystallineEdge(p);

  // Create base color
  vec3 color = crystalColor(pattern, thought);

  // Add edge highlighting
  vec3 edgeColor = vec3(0.9, 0.8, 1.0);
  color += edgeColor * edge * 2.0;

  // Add thought field glow
  vec3 thoughtColor = vec3(0.2, 0.5, 1.0);
  color += thoughtColor * thought;

  return color;
}

float neuralPulse(vec2 p, float time) {
  float pulse = 0.0;

  // Create neural pulses
  for(float i = 0.0; i < 3.0; i++) {
    vec2 center = vec2(C(time * (0.5 + i * 0.2)), S(time * (0.4 + i * 0.2))) * 0.5;

    float dist = length(p - center);
    float wave = S(dist * 10.0 - time * 5.0);
    pulse += wave / (1.0 + dist * 5.0);
  }

  return pulse;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create zoom and rotation based on mouse
  float zoom = 5.0 + mousePos.y * 2.0;
  float rotation = t * 0.1 + mousePos.x * Q;

  // Transform space
  vec2 pos = rotate2D(uv * zoom, rotation);

  // Get base patterns
  vec3 color = thoughtPatterns(pos);

  // Add neural pulses
  float pulse = neuralPulse(uv, t);
  color += vec3(0.5, 0.8, 1.0) * pulse;

  // Add mouse interaction
  float mouseInfluence = exp(-length(uv - mousePos) * 3.0);
  color += vec3(1.0, 0.8, 0.5) * mouseInfluence;

  // Add crystal facet highlights
  float facet = crystalPattern(pos * 2.0);
  color += vec3(1.0) * smoothstep(0.2, 0.3, facet) * 0.2;

  // Add thought connection lines
  float connections = thoughtField(pos);
  color += vec3(0.2, 0.5, 1.0) * connections * 0.5;

  // Add vignette
  float vignette = 1.0 - length(uv) * 0.5;
  color *= vignette;

  // Add subtle pulsing
  color *= 0.8 + 0.2 * S(t * 2.0);

  // Tone mapping and gamma correction
  color = color / (color + vec3(1.0));
  color = pow(color, vec3(0.4545));

  return vec4(color, 1.0);
}
