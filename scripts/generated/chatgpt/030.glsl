float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float voronoi(vec2 x) {
  vec2 n = floor(x);
  vec2 f = fract(x);

  float minDist = 1.0;
  vec2 minPoint;

  for(int j = -1; j <= 1; j++) {
    for(int i = -1; i <= 1; i++) {
      vec2 neighbor = vec2(float(i), float(j));
      vec2 point = neighbor + hash(n + neighbor);
      point = 0.5 + 0.5 * S(t * 0.5 + hash(point) * Q) * point;

      vec2 diff = neighbor + point - f;
      float dist = length(diff);

      if(dist < minDist) {
        minDist = dist;
        minPoint = point;
      }
    }
  }

  return minDist;
}

float crystallize(vec2 uv) {
  float v = 0.0;
  float amp = 0.5;
  float freq = 1.0;

  for(float i = 0.0; i < 3.0; i++) {
    float angle = t * (0.1 + 0.1 * i);
    vec2 rotated = vec2(uv.x * C(angle) - uv.y * S(angle), uv.x * S(angle) + uv.y * C(angle));
    v += voronoi(rotated * freq) * amp;
    amp *= 0.5;
    freq *= 2.0;
  }

  return v;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  uv *= 3.0; // Scale for more detail

  // Create crystal pattern
  float crystal = crystallize(uv);

  // Create edges
  float edges = smoothstep(0.1, 0.0, crystal);
  float facets = smoothstep(0.2, 0.1, crystal);

  // Create color palette
  vec3 edgeColor = vec3(0.9, 0.9, 1.0);
  vec3 facetColor1 = vec3(0.2, 0.5, 0.8);
  vec3 facetColor2 = vec3(0.1, 0.3, 0.6);

  // Mix colors based on pattern
  vec3 color = mix(facetColor2, facetColor1, facets);
  color = mix(color, edgeColor, edges);

  // Add sparkle
  float sparkle = pow(facets, 10.0) * S(t * 10.0 + crystal * 20.0);
  color += vec3(1.0) * sparkle;

  // Add inner glow
  float glow = exp(-crystal * 5.0);
  color += vec3(0.2, 0.4, 0.8) * glow;

  // Add subtle color variation
  color *= 0.8 + 0.2 * S(crystal * 10.0 + t);

  return vec4(color, 1.0);
}
