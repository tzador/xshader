float hash(float n) {
  return fract(S(n) * 43758.5453123);
}

vec2 gravitationalLensing(vec2 uv) {
  float dist = length(uv);
  float strength = 0.3; // Gravitational strength
  float eventHorizon = 0.15; // Event horizon radius

  // Apply gravitational lensing effect
  float warp = 1.0 / (dist + 0.1) * strength;
  vec2 direction = normalize(uv);

  // More intense warping near event horizon
  warp *= smoothstep(eventHorizon * 2.0, eventHorizon, dist);

  return uv + direction * warp;
}

vec3 starField(vec2 uv) {
  vec3 color = vec3(0.0);

  // Create multiple layers of stars
  for(float i = 0.0; i < 3.0; i++) {
    vec2 gridUV = uv * (10.0 + i * 10.0);
    vec2 id = floor(gridUV);
    vec2 gv = fract(gridUV) - 0.5;

    for(float y = -1.0; y <= 1.0; y++) {
      for(float x = -1.0; x <= 1.0; x++) {
        vec2 offset = vec2(x, y);
        float h = hash(dot(id + offset, vec2(127.1, 311.7)));
        float star = smoothstep(0.9, 0.95, h);
        star *= 1.0 - length(gv - offset);
        color += star * vec3(h, h * h, h * h * h);
      }
    }
  }

  return color;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Apply gravitational lensing
  vec2 warpedUV = gravitationalLensing(uv);

  // Create accretion disk
  float angle = atan(warpedUV.y, warpedUV.x);
  float dist = length(warpedUV);
  float disk = smoothstep(0.3, 0.2, dist) * smoothstep(0.1, 0.15, dist);
  disk *= (0.5 + 0.5 * S(angle * 5.0 + t * 2.0));

  // Create disk color with temperature gradient
  vec3 diskColor = mix(vec3(1.0, 0.3, 0.1), // Hot inner disk
  vec3(0.8, 0.2, 0.1), // Cooler outer disk
  smoothstep(0.15, 0.3, dist));

  // Add star field with gravitational lensing
  vec3 stars = starField(warpedUV);

  // Create the black hole
  float blackHole = 1.0 - smoothstep(0.1, 0.15, dist);

  // Combine everything
  vec3 color = stars;
  color = mix(color, diskColor, disk);
  color = mix(color, vec3(0.0), blackHole);

  // Add blue-shifted and red-shifted regions
  float shift = S(angle + t);
  color *= 1.0 + 0.2 * vec3(shift, 0.0, -shift);

  // Add glow
  float glow = exp(-dist * 2.0);
  color += diskColor * glow * 0.5;

  return vec4(color, 1.0);
}
