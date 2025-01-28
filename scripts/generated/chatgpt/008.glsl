float random(vec2 st) {
  return fract(S(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec3 color = vec3(0.0);

  for(float i = 0.0; i < 500.0; i++) {
    float depth = mod(-t * 0.1 + i * 0.02, 1.0);
    vec2 pos = vec2(random(vec2(i, i * 1.23)), random(vec2(i * 1.71, i)));
    pos = fract(pos) * 2.0 - 1.0;

    pos *= 1.0 / depth;

    float size = 0.002 + 0.01 * (1.0 - depth);
    float d = length(uv - pos);
    float intensity = smoothstep(size, size * 0.5, d);

    color += vec3(intensity * (1.0 - depth));
  }

  return vec4(color, 1.0);
}
