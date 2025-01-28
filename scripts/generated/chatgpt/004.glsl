float wave(vec2 uv, vec2 origin, float frequency, float speed) {
  float distance = length(uv - origin);
  return S(frequency * distance - speed * t);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  vec2 origin1 = vec2(-0.5, 0.0);
  vec2 origin2 = vec2(0.5, 0.0);

  float wave1 = wave(uv, origin1, 10.0, 2.0);
  float wave2 = wave(uv, origin2, 10.0, 2.0);
  float interference = wave1 + wave2;

  vec3 color = vec3(0.5 + 0.5 * S(interference), 0.5 + 0.5 * C(interference), 0.5 - 0.5 * S(interference));

  return vec4(color, 1.0);
}
