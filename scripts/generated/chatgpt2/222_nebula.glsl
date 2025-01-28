/*
Cosmic Nebula
Creates a dynamic nebula simulation with gas dynamics,
light scattering, and stellar formation effects.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 3.0;
  vec3 color = vec3(0.0);

    // Create base noise function
  float noise(vec2 p) {
    vec2 ip = floor(p);
    vec2 fp = fract(p);

    float a = fract(sin(dot(ip, vec2(127.1, 311.7))) * 43758.5453);
    float b = fract(sin(dot(ip + vec2(1.0, 0.0), vec2(127.1, 311.7))) * 43758.5453);
    float c = fract(sin(dot(ip + vec2(0.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);
    float d = fract(sin(dot(ip + vec2(1.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);

    fp = fp * fp * (3.0 - 2.0 * fp);

    return mix(mix(a, b, fp.x), mix(c, d, fp.x), fp.y);
  }

    // Create fractal noise
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

    // Gas dynamics
  vec2 q = vec2(fbm(uv + vec2(0.0, t * 0.1)), fbm(uv + vec2(t * 0.15, 0.0)));

  vec2 r = vec2(fbm(uv + 4.0 * q + vec2(1.7, 9.2) + t * 0.15), fbm(uv + 4.0 * q + vec2(8.3, 2.8) + t * 0.126));

  float gas = fbm(uv + 4.0 * r);

    // Create color layers
  vec3 nebula_color = mix(vec3(0.5, 0.0, 0.0),    // Deep red
  vec3(0.9, 0.4, 0.1),    // Orange
  gas);

  nebula_color = mix(nebula_color, vec3(0.2, 0.1, 0.3),    // Purple
  fbm(uv + r));

    // Add stellar formations
  for(int i = 0; i < 3; i++) {
    float layer = float(i) * 0.3;
    vec2 star_uv = uv * (2.0 + layer);

    float star_field = fbm(star_uv + t * (0.1 + layer * 0.1));
    star_field = pow(star_field, 3.0);

    nebula_color = mix(nebula_color, vec3(1.0, 0.9, 0.8), star_field * (0.5 - layer * 0.3));
  }

    // Add light scattering
  float scatter = length(uv);
  scatter = 1.0 - scatter * scatter * 0.5;

    // Add glow points
  for(int i = 0; i < 5; i++) {
    float angle = float(i) * 1.257;
    vec2 glow_pos = vec2(cos(angle + t), sin(angle + t * 0.7)) * 0.7;

    float glow = length(uv - glow_pos);
    glow = exp(-glow * 4.0);

    nebula_color += vec3(0.8, 0.6, 0.4) * glow * 0.3;
  }

    // Final composition
  color = nebula_color * scatter;
  color += vec3(0.1, 0.2, 0.4) * (1.0 - scatter);

    // Tone mapping
  color = pow(color, vec3(0.8));

  return vec4(color, 1.0);
}
