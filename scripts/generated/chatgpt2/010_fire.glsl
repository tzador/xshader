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
  float lacunarity = 2.0;
  float gain = 0.5;

  for(float i = 0.0; i < 6.0; i++) {
    value += amplitude * noise(p * frequency);
    frequency *= lacunarity;
    amplitude *= gain;
  }

  return value;
}

vec3 fire(vec2 uv, float time) {
  // Create base fire shape
  float flame = 0.0;
  vec2 flameUV = uv * vec2(1.0, 2.0); // Stretch vertically

  // Add multiple layers of noise for realistic fire movement
  for(float i = 1.0; i < 5.0; i++) {
    float scale = 1.0 + i * 0.5;
    vec2 offset = vec2(time * (0.1 + 0.1 * i), time * (0.2 + 0.1 * i));

    float noise = fbm(flameUV * scale + offset);
    noise = pow(noise, 1.5); // Make fire sharper

    // Create flame shape
    float y = flameUV.y + 1.0;
    float flameShape = 1.0 - pow(y, 0.5 + 0.5 * i);

    flame += noise * flameShape * (1.0 / i);
  }

  // Create color gradient
  vec3 color1 = vec3(1.0, 0.2, 0.0); // Orange
  vec3 color2 = vec3(1.0, 0.5, 0.0); // Yellow
  vec3 color3 = vec3(0.2, 0.2, 0.2); // Smoke

  // Mix colors based on height and intensity
  vec3 fireColor = mix(color1, color2, flame);
  fireColor = mix(fireColor, color3, pow(flameUV.y + 1.0, 2.0));

  return fireColor * flame;
}

vec3 embers(vec2 uv, float time) {
  vec3 color = vec3(0.0);

  // Create multiple ember particles
  for(float i = 0.0; i < 20.0; i++) {
    float t = time + i * 1234.5678;
    float x = hash(vec2(i, t)) * 2.0 - 1.0;
    float y = -1.0 + mod(hash(vec2(t, i)) - time * (0.5 + hash(vec2(i)) * 0.5), 2.0);

    vec2 ember = vec2(x, y);
    float size = 0.002 + 0.003 * hash(vec2(i));

    // Add some swirling motion
    ember.x += 0.1 * S(time + i);

    float particle = exp(-length(uv - ember) / size);

    // Create ember color
    vec3 emberColor = mix(vec3(1.0, 0.3, 0.0), vec3(1.0, 0.5, 0.0), hash(vec2(i, 123.456)));

    color += emberColor * particle;
  }

  return color;
}

vec3 smoke(vec2 uv, float time) {
  vec3 smokeColor = vec3(0.0);

  // Create multiple layers of smoke
  for(float i = 1.0; i < 4.0; i++) {
    float scale = 0.5 + i * 0.5;
    vec2 offset = vec2(time * 0.1 * i, time * 0.2 * i);

    float noise = fbm(uv * scale + offset);
    noise = smoothstep(0.3, 0.7, noise);

    // Smoke dissipates as it rises
    float fadeout = smoothstep(1.0, -1.0, uv.y);

    smokeColor += vec3(0.2) * noise * fadeout * (0.5 / i);
  }

  return smokeColor;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create base fire
  vec3 color = fire(uv, t);

  // Add embers
  color += embers(uv, t);

  // Add smoke
  color += smoke(uv + vec2(0.0, 0.5), t);

  // Add heat distortion
  vec2 distortion = vec2(fbm(uv * 2.0 + t), fbm(uv * 2.0 + 100.0 + t)) * 0.02;

  color += fire(uv + distortion, t) * 0.5;

  // Add glow
  float glow = exp(-length(uv) * 1.5);
  color += vec3(1.0, 0.3, 0.0) * glow * 0.2;

  return vec4(color, 1.0);
}
