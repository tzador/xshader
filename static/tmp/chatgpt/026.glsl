float noise(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float fbm(vec2 p) {
  float sum = 0.0;
  float amp = 0.5;
  float freq = 1.0;

  for(float i = 0.0; i < 6.0; i++) {
    sum += amp * noise(p * freq);
    amp *= 0.5;
    freq *= 2.0;
  }

  return sum;
}

vec3 aurora(vec2 uv) {
  // Create base aurora pattern
  float time = t * 0.2;
  vec2 movement = vec2(time * 0.5, time * 0.2);
  float f = fbm(uv * 3.0 + movement);
  f *= fbm(uv * 6.0 - movement);

  // Create vertical gradient
  float gradient = 1.0 - pow(uv.y + 0.5, 2.0);
  f *= gradient;

  // Create color variations
  vec3 col1 = vec3(0.0, 1.0, 0.4);  // Green
  vec3 col2 = vec3(0.2, 0.6, 1.0);  // Blue
  vec3 col3 = vec3(0.8, 0.4, 1.0);  // Purple

  // Mix colors based on height and noise
  vec3 color = mix(col1, col2, uv.y + 0.5);
  color = mix(color, col3, f);

  return color * f * 2.0;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  uv.x *= 2.0; // Wider aspect ratio

  // Create aurora layers
  vec3 color = vec3(0.0);
  for(float i = 0.0; i < 3.0; i++) {
    float scale = 1.0 + i * 0.3;
    vec2 offset = vec2(S(t * 0.5 + i), C(t * 0.3 + i)) * 0.2;
    color += aurora((uv + offset) * scale) * (1.0 - i * 0.2);
  }

  // Add stars
  float stars = pow(noise(uv * 50.0), 20.0);
  stars *= smoothstep(0.5, 1.0, S(t * 5.0 + noise(uv)));
  color += vec3(stars);

  // Add night sky background
  vec3 skyColor = vec3(0.0, 0.0, 0.1);
  float atmosphere = pow(1.0 - uv.y, 3.0);
  skyColor += vec3(0.0, 0.0, 0.2) * atmosphere;

  // Combine everything
  color = mix(skyColor, color, color);

  // Add subtle color variations over time
  color *= 0.8 + 0.2 * S(t + uv.y);

  return vec4(color, 1.0);
}
