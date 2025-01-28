float circle(vec2 uv, vec2 center, float radius) {
  return smoothstep(radius, radius - 0.01, length(uv - center));
}

vec3 iridescence(float angle) {
  return vec3(0.5 + 0.5 * C(angle), 0.5 + 0.5 * S(angle), 0.5 + 0.5 * C(angle + P));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  vec2 center1 = vec2(0.3 * S(t), 0.3 * C(t));
  vec2 center2 = vec2(0.5 * C(t * 0.5), 0.5 * S(t * 0.5));
  vec2 center3 = vec2(-0.4 * S(t * 0.7), -0.4 * C(t * 0.7));

  float radius = 0.2 + 0.05 * S(t);

  float bubble1 = circle(uv, center1, radius);
  float bubble2 = circle(uv, center2, radius);
  float bubble3 = circle(uv, center3, radius);

  vec3 color1 = iridescence(length(uv - center1) * 10.0 + t);
  vec3 color2 = iridescence(length(uv - center2) * 10.0 - t * 0.5);
  vec3 color3 = iridescence(length(uv - center3) * 10.0 + t * 0.7);

  vec3 finalColor = bubble1 * color1 + bubble2 * color2 + bubble3 * color3;

  return vec4(finalColor, max(bubble1, max(bubble2, bubble3)));
}
