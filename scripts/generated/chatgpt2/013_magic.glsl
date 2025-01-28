float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float rune(vec2 uv, float seed) {
  // Create random rune pattern
  float pattern = 0.0;
  vec2 id = floor(uv * 4.0);
  vec2 local = fract(uv * 4.0) * 2.0 - 1.0;

  for(float i = 0.0; i < 4.0; i++) {
    float angle = hash(id + seed + i) * Q;
    vec2 dir = vec2(C(angle), S(angle));
    pattern += smoothstep(0.1, 0.0, A(dot(local, dir)));
  }

  return pattern;
}

float magicCircle(vec2 uv, float radius, float rotation) {
  float circle = smoothstep(radius + 0.01, radius, length(uv));
  circle *= smoothstep(radius - 0.1, radius - 0.09, length(uv));

  // Add rotating elements
  vec2 rotated = rotate(uv, rotation);
  float elements = 0.0;
  for(float i = 0.0; i < 8.0; i++) {
    float angle = i * Q / 8.0;
    vec2 pos = vec2(C(angle), S(angle)) * radius;
    elements += smoothstep(0.1, 0.0, length(rotated - pos));
  }

  return circle + elements;
}

float energyBeam(vec2 uv, vec2 start, vec2 end, float width) {
  vec2 dir = normalize(end - start);
  vec2 normal = vec2(-dir.y, dir.x);

  float projection = dot(uv - start, dir);
  float distance = dot(uv - start, normal);

  float beam = smoothstep(width, 0.0, A(distance)) *
    smoothstep(0.0, 0.1, projection) *
    smoothstep(length(end - start), length(end - start) - 0.1, projection);

  // Add energy fluctuations
  beam *= 0.5 + 0.5 * S(projection * 10.0 - t * 5.0);

  return beam;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create magic circle at mouse position
  float circle = magicCircle(uv - mousePos, 0.2, t);

  // Create orbiting runes
  float runes = 0.0;
  for(float i = 0.0; i < 6.0; i++) {
    float angle = i * Q / 6.0 + t;
    vec2 runePos = mousePos + vec2(C(angle), S(angle)) * 0.3;
    vec2 localUv = rotate(uv - runePos, angle + t);
    runes += rune(localUv * 2.0, i) * smoothstep(0.2, 0.0, length(uv - runePos));
  }

  // Create energy beams
  float beams = 0.0;
  for(float i = 0.0; i < 3.0; i++) {
    float angle = i * Q / 3.0 + t * 0.5;
    vec2 start = mousePos + vec2(C(angle), S(angle)) * 0.2;
    vec2 end = start + vec2(C(angle + S(t + i)), S(angle + S(t + i))) * 0.5;
    beams += energyBeam(uv, start, end, 0.02);
  }

  // Create colors
  vec3 circleColor = vec3(0.4, 0.2, 0.8);
  vec3 runeColor = vec3(0.8, 0.4, 0.1);
  vec3 beamColor = vec3(0.2, 0.8, 0.4);

  // Add time variations
  circleColor *= 0.8 + 0.2 * S(t * 2.0);
  runeColor *= 0.8 + 0.2 * S(t * 3.0);
  beamColor *= 0.8 + 0.2 * S(t * 4.0);

  // Combine elements
  vec3 color = circleColor * circle +
    runeColor * runes +
    beamColor * beams;

  // Add magical glow
  float glow = circle * 0.5 + runes * 0.3 + beams * 0.8;
  color += vec3(0.8, 0.6, 1.0) * glow * 0.5;

  // Add mouse proximity effect
  float mouseGlow = exp(-length(uv - mousePos) * 3.0);
  color += vec3(0.5, 0.3, 0.8) * mouseGlow;

  // Add magical particles
  for(float i = 0.0; i < 20.0; i++) {
    float t_offset = t + i * 1234.5678;
    vec2 particlePos = mousePos + vec2(C(t_offset * 2.0) * (0.1 + 0.1 * hash(vec2(i))), S(t_offset * 2.0) * (0.1 + 0.1 * hash(vec2(i + 1.0))));

    float particle = exp(-length(uv - particlePos) * 30.0);
    color += vec3(0.8, 0.6, 1.0) * particle;
  }

  return vec4(color, 1.0);
}
