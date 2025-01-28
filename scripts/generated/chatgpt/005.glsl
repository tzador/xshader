float hash(float n) {
  return fract(S(n) * 43758.5453123);
}

float noise(vec2 pos) {
  vec2 i = floor(pos);
  vec2 f = fract(pos);
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(mix(hash(i.x + i.y * 57.0), hash(i.x + 1.0 + i.y * 57.0), u.x), mix(hash(i.x + (i.y + 1.0) * 57.0), hash(i.x + 1.0 + (i.y + 1.0) * 57.0), u.x), u.y);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  float spark = 0.0;
  float time = t * 0.5;

  for(float i = 0.0; i < 10.0; i++) {
    float offset = i * 0.1 + time;
    spark += exp(-30.0 * length(uv - vec2(S(offset), C(offset))) * noise(uv * 10.0 + time));
  }

  vec3 color = vec3(1.0, 0.8, 0.2) * spark;
  return vec4(color, 1.0);
}
