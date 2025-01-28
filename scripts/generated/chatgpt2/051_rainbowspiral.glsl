vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  float r = length(uv);
  float a = atan(uv.y, uv.x);

  float spiral = S(mod(a * 2.0 + r * 8.0 - t * 2.0, Q) - 1.0);
  spiral *= smoothstep(1.0, 0.0, r);

  vec3 color = 0.5 + 0.5 * C(spiral * 5.0 + vec3(0, 2, 4));
  color *= spiral;

  return vec4(color, 1.0);
}
