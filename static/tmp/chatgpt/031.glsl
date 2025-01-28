vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float spiral(vec2 uv, float arms, float twist) {
  float angle = atan(uv.y, uv.x);
  float dist = length(uv);

  float spiral = angle * arms + dist * twist;
  spiral = mod(spiral, Q);

  return smoothstep(0.5, 0.0, A(spiral - P));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create time-based animation
  float time = t * 0.5;

  // Create multiple rotating coordinate systems
  vec2 uv1 = rotate(uv, time);
  vec2 uv2 = rotate(uv, -time * 0.7);
  vec2 uv3 = rotate(uv, time * 0.3);

  // Create multiple spiral layers
  float s1 = spiral(uv1, 5.0, 3.0 + S(time));
  float s2 = spiral(uv2, 3.0, 2.0 - C(time));
  float s3 = spiral(uv3, 7.0, 4.0 + S(time * 0.5));

  // Create color palette
  vec3 color1 = vec3(0.7, 0.2, 0.8); // Purple
  vec3 color2 = vec3(0.2, 0.8, 0.7); // Turquoise
  vec3 color3 = vec3(0.8, 0.7, 0.2); // Gold

  // Mix colors based on spiral patterns
  vec3 color = color1 * s1 + color2 * s2 + color3 * s3;

  // Add pulsing effect
  float pulse = 0.8 + 0.2 * S(time * 2.0);
  color *= pulse;

  // Add radial gradient
  float radial = 1.0 - length(uv) * 0.5;
  color *= radial;

  // Add center glow
  float glow = exp(-length(uv) * 3.0);
  color += vec3(1.0) * glow * pulse;

  // Add motion blur effect
  float blur = exp(-length(uv) * (2.0 + S(time * 3.0)));
  color = mix(color, vec3(0.5), blur * 0.3);

  // Add color cycling
  color *= 0.8 + 0.2 * vec3(S(time), S(time + Q / 3.0), S(time + Q * 2.0 / 3.0));

  return vec4(color, 1.0);
}
