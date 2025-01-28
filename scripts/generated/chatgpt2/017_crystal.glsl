float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float voronoi(vec2 x) {
  vec2 n = floor(x);
  vec2 f = fract(x);

  float minDist = 1.0;
  vec2 minPoint;

  for(float j = -1.0; j <= 1.0; j++) {
    for(float i = -1.0; i <= 1.0; i++) {
      vec2 neighbor = vec2(float(i), float(j));
      vec2 point = neighbor + hash(n + neighbor);

      // Add time variation to points
      point = 0.5 + 0.5 * S(t * 0.2 + hash(point) * Q) * point;

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

float crystallize(vec2 uv, vec2 mousePos) {
  float v = 0.0;
  float amp = 0.5;
  float freq = 1.0;

  // Add mouse influence on crystal formation
  float mouseEffect = exp(-length(uv - mousePos) * 2.0);
  freq += mouseEffect * 2.0;

  for(float i = 0.0; i < 3.0; i++) {
    float angle = t * (0.1 + 0.1 * i);
    vec2 rotated = vec2(uv.x * C(angle) - uv.y * S(angle), uv.x * S(angle) + uv.y * C(angle));
    v += voronoi(rotated * freq) * amp;
    amp *= 0.5;
    freq *= 2.0;
  }

  return v;
}

vec3 prismColor(float value) {
  // Create rainbow spectrum
  vec3 a = vec3(0.5, 0.5, 0.5);
  vec3 b = vec3(0.5, 0.5, 0.5);
  vec3 c = vec3(1.0, 1.0, 1.0);
  vec3 d = vec3(0.0, 0.33, 0.67);

  return a + b * C(Q * (c * value + d));
}

float facet(vec2 uv, float angle) {
  uv = vec2(uv.x * C(angle) - uv.y * S(angle), uv.x * S(angle) + uv.y * C(angle));

  return smoothstep(0.1, 0.0, A(uv.x)) * smoothstep(0.1, 0.0, A(uv.y));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create base crystal pattern
  float crystal = crystallize(uv, mousePos);

  // Create edges
  float edges = smoothstep(0.1, 0.0, crystal);
  float facets = smoothstep(0.2, 0.1, crystal);

  // Add crystal facets
  float facetPattern = 0.0;
  for(float i = 0.0; i < 6.0; i++) {
    float angle = i * Q / 6.0 + t * 0.2;
    facetPattern += facet(uv, angle) * (0.5 + 0.5 * S(t + i));
  }

  // Create heat distortion near mouse
  float heat = exp(-length(uv - mousePos) * 3.0);
  vec2 distortion = vec2(S(uv.y * 10.0 + t * 2.0), C(uv.x * 10.0 + t * 2.0)) * heat * 0.1;

  uv += distortion;

  // Create colors
  vec3 edgeColor = vec3(0.9, 0.9, 1.0);
  vec3 facetColor = prismColor(crystal + t * 0.1);
  vec3 deepColor = prismColor(crystal * 2.0 - t * 0.2);

  // Mix colors based on pattern
  vec3 color = mix(deepColor, facetColor, facets);
  color = mix(color, edgeColor, edges);
  color += facetPattern * prismColor(t * 0.1);

  // Add sparkle
  float sparkle = pow(facets, 10.0) * (0.5 + 0.5 * S(t * 10.0 + crystal * 20.0));
  color += vec3(1.0) * sparkle;

  // Add heat glow
  vec3 heatColor = mix(vec3(1.0, 0.2, 0.0), // Hot
  vec3(0.2, 0.4, 1.0), // Cold
  crystal);
  color += heatColor * heat * 0.5;

  // Add inner glow
  float glow = exp(-crystal * 5.0);
  color += vec3(0.2, 0.4, 0.8) * glow;

  // Add mouse proximity effect
  float mouseGlow = exp(-length(uv - mousePos) * 3.0);
  color += prismColor(mouseGlow + t * 0.2) * mouseGlow * 0.5;

  // Add subtle color variation
  color *= 0.8 + 0.2 * S(crystal * 10.0 + t);

  return vec4(color, 1.0);
}
