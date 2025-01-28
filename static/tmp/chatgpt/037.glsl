float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float bubble(vec2 uv, vec2 center, float radius) {
  float dist = length(uv - center);
  float circle = smoothstep(radius, radius - 0.01, dist);

  // Add highlight
  vec2 lightDir = normalize(vec2(0.2, 0.8));
  float highlight = smoothstep(0.05, 0.0, length(uv - center - lightDir * radius * 0.5));

  // Add rim
  float rim = smoothstep(radius * 0.8, radius, dist) * circle;

  return circle + highlight * 0.5 + rim * 0.3;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create time-based animation
  float time = t * 0.3;

  // Create multiple bubbles
  vec3 color = vec3(0.0);
  for(float i = 0.0; i < 30.0; i++) {
    // Create pseudo-random bubble parameters
    float randTime = hash(vec2(i, floor(time)));
    float speed = 0.2 + 0.3 * hash(vec2(i, 1.0));
    float size = 0.1 + 0.1 * hash(vec2(i, 2.0));

    // Calculate bubble position
    vec2 basePos = vec2(hash(vec2(i, 3.0)) * 2.0 - 1.0, mod(hash(vec2(i, 4.0)) - time * speed, 2.0) - 1.0);

    // Add wobble
    basePos += vec2(S(time * 2.0 + i), C(time * 1.5 + i)) * 0.02;

    // Create bubble
    float bub = bubble(uv, basePos, size);

    // Create iridescent colors
    vec3 bubbleColor = vec3(0.5 + 0.5 * S(time + i), 0.5 + 0.5 * S(time + i + Q / 3.0), 0.5 + 0.5 * S(time + i + Q * 2.0 / 3.0));

    color += bubbleColor * bub * 0.3;
  }

  // Add mouse interaction
  vec2 mousePos = m * 2.0 - 1.0;
  float mouseBubble = bubble(uv, mousePos, 0.2 + 0.05 * S(time * 3.0));
  color += vec3(0.8, 0.9, 1.0) * mouseBubble * 0.5;

  // Add background gradient
  vec3 bg = mix(vec3(0.1, 0.2, 0.3), vec3(0.2, 0.3, 0.4), uv.y * 0.5 + 0.5);
  color = mix(bg, color, color);

  // Add subtle caustics
  float caustics = 0.5 + 0.5 * S(uv.x * 5.0 + uv.y * 3.0 + time);
  color *= 0.9 + 0.1 * caustics;

  // Add vignette
  float vignette = 1.0 - length(uv) * 0.5;
  color *= vignette;

  return vec4(color, 1.0);
}
