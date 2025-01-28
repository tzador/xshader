float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 voronoi(vec2 x) {
  vec2 n = floor(x);
  vec2 f = fract(x);

  vec2 mg, mr;
  float md = 8.0;

  for(int j = -1; j <= 1; j++) {
    for(int i = -1; i <= 1; i++) {
      vec2 g = vec2(float(i), float(j));
      vec2 o = hash(n + g);
      o = 0.5 + 0.5 * S(t + 6.2831 * o);

      vec2 r = g + o - f;
      float d = dot(r, r);

      if(d < md) {
        md = d;
        mr = r;
        mg = g;
      }
    }
  }
  return vec2(md, hash(n + mg));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  uv *= 5.0; // Scale for more cells

  // Get voronoi pattern
  vec2 c = voronoi(uv);
  float pattern = c.y; // Random value per cell
  float cell = c.x;    // Distance to cell center

  // Create organic-looking colors
  vec3 color1 = vec3(0.2, 0.5, 0.3);
  vec3 color2 = vec3(0.7, 0.9, 0.2);
  vec3 baseColor = mix(color1, color2, pattern);

  // Add cell boundaries
  float edge = 1.0 - smoothstep(0.0, 0.05, cell);
  baseColor *= 1.0 - edge * 0.5;

  // Add pulsing effect
  float pulse = 0.5 + 0.5 * S(t * 2.0 + pattern * Q);
  baseColor *= 0.8 + 0.2 * pulse;

  // Add subtle glow at cell centers
  float glow = exp(-cell * 10.0);
  baseColor += vec3(0.2, 0.3, 0.1) * glow * pulse;

  return vec4(baseColor, 1.0);
}
