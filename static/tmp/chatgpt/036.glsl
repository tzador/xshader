vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

vec2 kaleidoscope(vec2 uv, float segments) {
  float angle = atan(uv.y, uv.x);
  float radius = length(uv);

  // Divide space into segments
  float segmentAngle = Q / segments;
  angle = mod(angle, segmentAngle);
  angle = min(angle, segmentAngle - angle);

  return vec2(C(angle), S(angle)) * radius;
}

float pattern(vec2 uv, float time) {
  vec2 p = uv;
  float v = 0.0;

  // Create multiple rotating layers
  for(float i = 0.0; i < 3.0; i++) {
    float scale = 1.0 + i * 0.5;
    float speed = (1.0 - i * 0.2) * time;
    p = rotate(p, speed);
    v += 0.5 + 0.5 * S(p.x * scale) * S(p.y * scale);
  }

  return v / 3.0;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create time-based animation
  float time = t * 0.2;

  // Apply kaleidoscope effect
  float segments = 8.0 + 4.0 * S(time * 0.5);
  vec2 kaleido = kaleidoscope(uv, segments);

  // Create base pattern
  float basePattern = pattern(kaleido, time);

  // Add mouse interaction
  vec2 mouseUV = kaleidoscope(uv - (m * 2.0 - 1.0), segments);
  float mouseDist = length(mouseUV);
  basePattern += smoothstep(0.2, 0.0, mouseDist) * S(time * 5.0);

  // Create color palette
  vec3 color1 = vec3(0.8, 0.2, 0.5);
  vec3 color2 = vec3(0.2, 0.5, 0.8);
  vec3 color3 = vec3(0.9, 0.8, 0.2);

  // Mix colors based on pattern
  vec3 color = mix(color1, color2, basePattern);
  color = mix(color, color3, pow(basePattern, 2.0));

  // Add shimmer effect
  float shimmer = 0.5 + 0.5 * S(length(kaleido) * 10.0 - time * 3.0);
  color *= 0.8 + 0.2 * shimmer;

  // Add radial gradient
  float radial = 1.0 - length(uv) * 0.5;
  color *= radial;

  // Add glow at pattern edges
  float edge = length(vec2(dFdx(basePattern), dFdy(basePattern)));
  color += vec3(1.0) * edge * 2.0;

  return vec4(color, 1.0);
}
