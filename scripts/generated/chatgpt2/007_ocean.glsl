float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);

  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));

  return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;
  float frequency = 1.0;

  for(float i = 0.0; i < 6.0; i++) {
    value += amplitude * noise(p * frequency);
    amplitude *= 0.5;
    frequency *= 2.0;
  }

  return value;
}

float wave(vec2 uv, float time) {
  // Create multiple layers of waves
  float waves = 0.0;

  for(float i = 1.0; i < 4.0; i++) {
    vec2 direction = vec2(1.0, 0.5) * i;
    float speed = 0.2 * i;
    waves += fbm(uv * (1.0 + i * 0.5) + direction * time * speed) * (1.0 / i);
  }

  return waves;
}

vec3 sky(vec2 uv, float time) {
  // Create sunset colors
  vec3 horizon = vec3(0.8, 0.3, 0.1);
  vec3 zenith = vec3(0.1, 0.2, 0.4);

  // Add clouds
  float clouds = fbm(uv * 2.0 + vec2(time * 0.1, 0.0));
  clouds = smoothstep(0.4, 0.6, clouds);

  // Mix colors based on height
  float sunsetGradient = smoothstep(-0.2, 0.5, uv.y);
  vec3 skyColor = mix(horizon, zenith, sunsetGradient);

  // Add sun
  vec2 sunPos = vec2(0.0, 0.1);
  float sun = exp(-length(uv - sunPos) * 5.0);
  skyColor += vec3(1.0, 0.6, 0.3) * sun;

  // Add clouds
  skyColor = mix(skyColor, vec3(0.8, 0.7, 0.6), clouds * (1.0 - sunsetGradient));

  return skyColor;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create waves
  float waves = wave(uv, t);

  // Create water surface
  float height = waves * 0.2;
  vec2 displacement = vec2(waves * 0.1, height);

  // Create water colors
  vec3 waterDeep = vec3(0.0, 0.1, 0.2);
  vec3 waterShallow = vec3(0.0, 0.3, 0.4);

  // Mix water colors based on height
  vec3 waterColor = mix(waterDeep, waterShallow, height + 0.5);

  // Add sky reflection
  vec2 reflectionUV = vec2(uv.x * 0.5 + displacement.x, 1.0 - displacement.y);
  vec3 reflection = sky(reflectionUV, t);

  // Fresnel effect
  float fresnel = pow(1.0 - max(0.0, uv.y + 0.5), 3.0);

  // Combine water and reflection
  vec3 color = mix(waterColor, reflection, fresnel * 0.6);

  // Add foam on wave peaks
  float foam = smoothstep(0.3, 0.4, waves);
  color = mix(color, vec3(1.0), foam * 0.3);

  // Add caustics
  float caustics = fbm(uv * 5.0 + t);
  color += vec3(0.0, 0.2, 0.3) * caustics * (1.0 - foam) * 0.2;

  // Split screen: sky above, water below
  vec3 skyColor = sky(uv, t);
  color = uv.y > 0.0 ? skyColor : color;

  return vec4(color, 1.0);
}
