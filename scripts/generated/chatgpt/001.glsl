vec4 f() {
  vec2 uv = p;
  uv *= 2.0;
  uv -= 1.0;

  // Apply tiling
  vec2 tiled = fract(uv * (10.0 + 5.0 * S(t * 0.5))) - 0.5;

  // Create a geometric pattern
  float dist = length(tiled);
  float lines = A(S(20.0 * dist - t));

  // Color based on pattern
  return vec4(vec3(lines), 1.0);
}
