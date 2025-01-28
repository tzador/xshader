float grid(vec2 p) {
  vec2 g = abs(fract(p - 0.5) - 0.5) / fwidth(p);
  return min(g.x, g.y);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mp = m * 2.0 - 1.0;

  // Create warped grid
  vec2 gv = uv * 5.0;
  gv += vec2(S(gv.y + t), C(gv.x - t)) * 0.1;
  gv += mp * 0.2;
  float g = grid(gv);

  // Add pulse
  float pulse = 0.5 + 0.5 * S(t * 2.0);
  g = pow(0.1 / g, pulse);

  // Create neon colors
  vec3 color = vec3(0.0, 0.5, 1.0) * g;
  color += vec3(1.0, 0.2, 0.8) * pow(g, 2.0);
  color *= exp(-length(uv) * 0.5);

  return vec4(color, 1.0);
}
