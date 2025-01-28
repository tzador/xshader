float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  f = f * f * (3.0 - 2.0 * f);

  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));

  return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;
  float frequency = 1.0;
  for(float i = 0.0; i < 5.0; i++) {
    value += amplitude * noise(p * frequency);
    amplitude *= 0.5;
    frequency *= 2.0;
  }
  return value;
}

vec3 auroraColor(float value) {
  // Create aurora color palette
  vec3 col1 = vec3(0.0, 0.3, 0.0);    // Dark green
  vec3 col2 = vec3(0.0, 1.0, 0.5);    // Bright green
  vec3 col3 = vec3(0.2, 0.5, 1.0);    // Blue
  vec3 col4 = vec3(0.8, 0.0, 0.8);    // Purple

  value = fract(value);
  float t1 = smoothstep(0.0, 0.33, value);
  float t2 = smoothstep(0.33, 0.66, value);
  float t3 = smoothstep(0.66, 1.0, value);

  vec3 color = col1;
  color = mix(color, col2, t1);
  color = mix(color, col3, t2);
  color = mix(color, col4, t3);

  return color;
}

float aurora(vec2 p, vec2 mousePos, float time) {
  float curtain = 0.0;

  // Create multiple aurora curtains
  for(float i = 1.0; i < 4.0; i++) {
    float scale = 2.0 + i;

    // Create base wave motion
    float wave = p.x * scale +
      S(p.x * 2.0 + time * i * 0.5) * 0.5 +
      C(p.x * 1.5 - time * i * 0.3) * 0.3;

    // Add mouse influence
    wave += (mousePos.x - 0.5) * 2.0;

    // Create vertical curtain effect
    float height = 0.3 + 0.2 * S(p.x * 3.0 + time * i);
    float curtainShape = smoothstep(height, height - 0.3, p.y);

    // Add noise to create texture
    float noise = fbm(vec2(wave, p.y * scale + time * i * 0.2));
    curtain += noise * curtainShape * (0.5 / i);
  }

  return curtain;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  uv.y += 0.5; // Shift aurora up
  vec2 mousePos = m;

  // Create base aurora effect
  float auroraValue = aurora(uv, mousePos, t);

  // Create dynamic color
  vec3 color = auroraColor(auroraValue + t * 0.1);

  // Add vertical rays
  float rays = 0.0;
  for(float i = 0.0; i < 5.0; i++) {
    float x = uv.x + S(t * (1.0 + i * 0.2)) * 0.2;
    float ray = exp(-abs(x - (i / 4.0 - 0.5) * 2.0) * 5.0);
    ray *= smoothstep(0.5, -0.5, uv.y);
    rays += ray * (0.5 + 0.5 * S(t * 2.0 + i));
  }

  // Add ray colors
  color += auroraColor(rays + t * 0.2) * rays * 0.5;

  // Add stars
  for(float i = 0.0; i < 50.0; i++) {
    vec2 starPos = vec2(hash(vec2(i, 1.234)), hash(vec2(i, 5.678))) * 2.0 - 1.0;

    float star = exp(-length(uv - starPos) * 50.0);
    star *= 0.5 + 0.5 * S(t * 5.0 + hash(starPos) * 10.0);
    color += vec3(1.0) * star;
  }

  // Add mouse interaction glow
  float mouseGlow = exp(-length(uv - (mousePos * 2.0 - 1.0)) * 2.0);
  color += auroraColor(mouseGlow + t) * mouseGlow * 0.5;

  // Add atmospheric fade
  float atmosphere = smoothstep(1.5, -0.5, uv.y);
  color *= atmosphere;

  // Add subtle color variations
  color *= 0.8 + 0.2 * S(uv.y * 5.0 + t);

  // Add background stars
  float stars = smoothstep(0.98, 0.99, hash(floor(uv * 50.0)));
  color += vec3(stars) * atmosphere;

  return vec4(color, 1.0);
}
