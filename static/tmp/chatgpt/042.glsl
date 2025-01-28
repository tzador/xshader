vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float hexagon(vec2 p, float size) {
  p = abs(p);
  float hex = max(p.x * 0.866025 + p.y * 0.5, p.y);
  return smoothstep(size + 0.01, size, hex);
}

float triangle(vec2 p, float size) {
  float k = sqrt(3.0);
  p.x = abs(p.x) - 1.0;
  p.y = p.y + 1.0 / k;
  if(p.x + k * p.y > 0.0)
    p = vec2(p.x - k * p.y, -k * p.x - p.y) / 2.0;
  p.x -= clamp(p.x, -2.0, 0.0);
  return smoothstep(size + 0.01, size, length(p) * sign(p.y));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create time-based animation
  float time = t * 0.2;

  // Create multiple layers of patterns
  vec3 color = vec3(0.0);

  // Layer 1: Rotating hexagons
  for(float i = 0.0; i < 3.0; i++) {
    float scale = 1.0 + i * 0.5;
    float rotation = time * (1.0 - i * 0.3);
    vec2 hexUV = rotate(uv * scale, rotation);

    float hex = 0.0;
    for(float j = 0.0; j < 6.0; j++) {
      float angle = j * Q / 6.0;
      vec2 offset = vec2(C(angle), S(angle)) * 0.5;
      hex += hexagon(hexUV - offset, 0.1);
    }

    vec3 hexColor = vec3(0.5 + 0.5 * S(time + i), 0.5 + 0.5 * S(time + i + Q / 3.0), 0.5 + 0.5 * S(time + i + Q * 2.0 / 3.0));

    color += hexColor * hex * (1.0 - i * 0.2);
  }

  // Layer 2: Triangular grid
  vec2 triUV = rotate(uv * 3.0, -time * 0.5);
  float tri = 0.0;
  for(float i = 0.0; i < 3.0; i++) {
    float angle = i * Q / 3.0;
    vec2 offset = vec2(C(angle), S(angle)) * 0.3;
    tri += triangle(triUV - offset, 0.1);
  }

  vec3 triColor = vec3(0.9, 0.8, 0.2);
  color += triColor * tri * 0.5;

  // Add mouse interaction
  vec2 mouseUV = uv - (m * 2.0 - 1.0);
  float mouseDist = length(mouseUV);
  float mousePattern = hexagon(rotate(mouseUV * 2.0, time), 0.2);
  color += vec3(1.0) * mousePattern * smoothstep(0.5, 0.0, mouseDist);

  // Add edge glow
  float edge = length(vec2(dFdx(tri), dFdy(tri)));
  color += vec3(0.2, 0.5, 0.8) * edge * 2.0;

  // Add subtle pulsing
  color *= 0.8 + 0.2 * S(time * 2.0);

  // Add vignette
  float vignette = 1.0 - length(uv) * 0.5;
  color *= vignette;

  return vec4(color, 1.0);
}
