float branch(vec2 uv, float angle, float length, float thickness) {
  // Rotate point
  float c = C(angle);
  float s = S(angle);
  vec2 p = vec2(uv.x * c - uv.y * s, uv.x * s + uv.y * c);

  // Draw branch
  float line = smoothstep(thickness, 0.0, A(p.x));
  line *= smoothstep(length + thickness, length, p.y);
  line *= smoothstep(-thickness, 0.0, p.y);

  return line;
}

float tree(vec2 uv, float depth) {
  if(depth <= 0.0)
    return 0.0;

  float result = branch(uv, 0.0, 0.3, 0.02 / depth);

  // Calculate sub-branch positions
  vec2 tip = vec2(0.0, 0.3);
  vec2 subUV = uv - tip;
  subUV *= 0.7; // Scale down for sub-branches

  // Add sub-branches with animation
  float sway = S(t + depth) * 0.2;
  result += tree(subUV, depth - 1.0) * 0.8;
  result += tree(rotate(subUV, P * 0.2 + sway), depth - 1.0) * 0.6;
  result += tree(rotate(subUV, -P * 0.2 + sway), depth - 1.0) * 0.6;

  return min(result, 1.0);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  uv.y -= 0.5; // Move tree base up

  // Create animated tree
  float shape = tree(uv, 5.0);

  // Create color gradient
  vec3 treeColor = mix(vec3(0.4, 0.2, 0.1), // Brown
  vec3(0.2, 0.8, 0.1), // Green
  shape * (0.5 + 0.5 * S(uv.y + t)));

  // Add wind sway effect
  float wind = S(uv.y * 5.0 + t * 2.0) * 0.1;
  shape *= 1.0 + wind;

  // Add glow
  float glow = exp(-length(uv) * 2.0);
  vec3 finalColor = treeColor * shape + vec3(0.1, 0.2, 0.1) * glow;

  return vec4(finalColor, 1.0);
}
