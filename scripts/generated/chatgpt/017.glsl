float metaball(vec2 uv, vec2 center, float size) {
  float dist = length(uv - center);
  return size / dist;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  uv.x *= 0.6;  // Make it more vertical like a lava lamp

  // Create multiple metaballs with different movements
  float metaballs = 0.0;
  for(float i = 0.0; i < 5.0; i++) {
    float speed = 0.2 + i * 0.1;
    float yPos = S(t * speed + i * P) * 0.8;
    float xPos = C(t * speed * 0.5 + i * P) * 0.2;
    vec2 center = vec2(xPos, yPos);
    float size = 0.15 + 0.05 * S(t * speed + i);
    metaballs += metaball(uv, center, size);
  }

  // Create color gradient based on metaball field
  float threshold = 1.2;
  float field = smoothstep(threshold - 0.1, threshold + 0.1, metaballs);

  // Create lava colors
  vec3 backgroundColor = vec3(0.1, 0.0, 0.2);
  vec3 lavaColor1 = vec3(1.0, 0.2, 0.0);
  vec3 lavaColor2 = vec3(1.0, 0.5, 0.0);

  // Mix colors based on field and time
  vec3 lavaColor = mix(lavaColor1, lavaColor2, 0.5 + 0.5 * S(t + uv.y));
  vec3 finalColor = mix(backgroundColor, lavaColor, field);

  // Add inner glow to the lava
  finalColor += lavaColor * field * 0.5 * (0.5 + 0.5 * S(t * 2.0));

  // Add container edges
  float edge = smoothstep(0.6, 0.58, A(uv.x)) * smoothstep(1.0, 0.98, A(uv.y));
  finalColor += vec3(0.2) * edge;

  return vec4(finalColor, 1.0);
}
