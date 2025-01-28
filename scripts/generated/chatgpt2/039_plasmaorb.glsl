float plasma(vec2 p) {
  p *= 2.0;
  return (S(p.x + t) + S(p.y + t) + S(length(p) * 2.0 - t * 2.0)) / 3.0;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mp = m * 2.0 - 1.0;

  float d = length(uv - mp);
  float orb = exp(-d * 3.0);

  float pl = plasma(uv + mp * 0.5);
  vec3 color = vec3(0.5, 0.8, 1.0) + vec3(1.0, 0.2, 0.1) * pl;
  color = mix(color, vec3(1.0), orb);

  // Add glow
  color += vec3(0.2, 0.4, 1.0) * exp(-d * 2.0);

  // Add electric arcs
  float arc = pow(0.5 + 0.5 * S(d * 10.0 - t * 5.0), 5.0);
  color += vec3(0.5, 0.7, 1.0) * arc;

  return vec4(color, 1.0);
}
