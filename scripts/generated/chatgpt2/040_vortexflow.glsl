vec2 vortex(vec2 p, vec2 center, float strength) {
  vec2 d = p - center;
  float l = length(d);
  return vec2(d.y, -d.x) / (l * l + 0.1) * strength;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mp = m * 2.0 - 1.0;

  // Create multiple vortices
  vec2 flow = vortex(uv, mp, 0.3);
  flow += vortex(uv, vec2(S(t), C(t)) * 0.5, 0.2);

  // Distort space
  vec2 dist = uv + flow * 0.5;
  float pattern = S(dist.x + t) * S(dist.y + t * 0.7);

  // Create color
  vec3 color = vec3(0.5 + 0.5 * C(pattern * 8.0 + vec3(0, 2, 4)));
  color *= 1.0 - length(uv) * 0.5; // Vignette
  color += vec3(0.2, 0.4, 0.8) * exp(-length(uv - mp) * 3.0); // Mouse glow

  return vec4(color, 1.0);
}
