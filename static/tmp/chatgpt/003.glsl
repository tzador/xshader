// Improved noise function for smoother results
float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);
  float a = fract(sin(dot(i, vec2(12.9898, 78.233))) * 43758.5453);
  float b = fract(sin(dot(i + vec2(1.0, 0.0), vec2(12.9898, 78.233))) * 43758.5453);
  float c = fract(sin(dot(i + vec2(0.0, 1.0), vec2(12.9898, 78.233))) * 43758.5453);
  float d = fract(sin(dot(i + vec2(1.0, 1.0), vec2(12.9898, 78.233))) * 43758.5453);
  return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal Brownian Motion for cloud-like structures
float fbm(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;
  float frequency = 1.0;
  for(int i = 0; i < 6; i++) {
    value += amplitude * noise(p * frequency);
    amplitude *= 0.5;
    frequency *= 2.0;
  }
  return value;
}

// Star field generation
float stars(vec2 p) {
  float n = noise(p * 50.0);
  return pow(n, 20.0);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create rotating coordinate system
  float angle = t * 0.1;
  vec2 rotUV = vec2(uv.x * C(angle) - uv.y * S(angle), uv.x * S(angle) + uv.y * C(angle));

  // Generate multiple layers of nebula
  float n1 = fbm(rotUV * 2.0 + vec2(t * 0.1, t * 0.05));
  float n2 = fbm(rotUV * 3.0 - vec2(t * 0.15, t * 0.07));
  float n3 = fbm(rotUV * 1.5 + vec2(t * 0.02, -t * 0.03));

  // Combine layers with different colors
  vec3 col1 = vec3(0.5, 0.2, 0.8); // Purple
  vec3 col2 = vec3(0.2, 0.5, 0.8); // Blue
  vec3 col3 = vec3(0.8, 0.2, 0.5); // Pink

  vec3 nebula = col1 * n1 + col2 * n2 + col3 * n3;

  // Add stars
  float starField = stars(uv + t * 0.1);
  vec3 stars = vec3(starField);

  // Add subtle movement to stars based on noise
  stars *= 1.0 + 0.2 * S(t + fbm(uv * 5.0));

  // Combine nebula and stars with a glow effect
  vec3 color = nebula;
  color += stars * 0.5;

  // Add center glow
  float centerGlow = exp(-length(uv) * 1.5);
  color += vec3(0.5, 0.3, 0.6) * centerGlow;

  // Add vignette effect
  float vignette = 1.0 - length(uv) * 0.5;
  color *= vignette;

  return vec4(color, 1.0);
}
