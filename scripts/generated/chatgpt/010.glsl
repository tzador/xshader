vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mouseUV = m * 2.0 - 1.0;  // Convert mouse from [0,1] to [-1,1] space

  float distanceFromMouse = length(uv - mouseUV);
  float ripple = 0.5 + 0.5 * S(distanceFromMouse * 15.0 - t * 5.0);

  vec3 color = vec3(0.5 + 0.5 * S(t + ripple), 0.5 + 0.5 * C(t * 0.7 + ripple), 0.5 + 0.5 * S(t * 0.3 - ripple));

  return vec4(color, 1.0);
}
