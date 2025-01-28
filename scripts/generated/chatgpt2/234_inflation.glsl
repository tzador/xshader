/*
Cosmic Inflation
Creates a visualization of cosmic inflation with expanding
space, primordial fluctuations, and density perturbations.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 4.0;
  vec3 color = vec3(0.0);

    // Inflation parameters
  float inflation_time = mod(t, 8.0);
  float scale_factor = exp(inflation_time * 0.5);

    // Create quantum noise function
  float quantum_noise(vec2 p) {
    vec2 ip = floor(p);
    vec2 fp = fract(p);

    float n00 = fract(sin(dot(ip, vec2(127.1, 311.7))) * 43758.5453);
    float n01 = fract(sin(dot(ip + vec2(0.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);
    float n10 = fract(sin(dot(ip + vec2(1.0, 0.0), vec2(127.1, 311.7))) * 43758.5453);
    float n11 = fract(sin(dot(ip + vec2(1.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);

        // Add quantum fluctuations
    fp = fp * fp * (3.0 - 2.0 * fp + sin(t + dot(ip, fp)) * 0.1);

    return mix(mix(n00, n10, fp.x), mix(n01, n11, fp.x), fp.y);
  }

    // Create primordial fluctuations
  float fluctuations = 0.0;
  for(int i = 0; i < 4; i++) {
    float scale = pow(2.0, float(i));
    vec2 scaled_uv = uv * scale / scale_factor;
    fluctuations += quantum_noise(scaled_uv + t * scale) / scale;
  }

    // Create density field
  float density = 0.0;
  vec2 scaled_pos = uv / scale_factor;

  for(int i = 0; i < 6; i++) {
    float angle = float(i) * 1.0472;
    vec2 offset = vec2(cos(angle + t), sin(angle + t * 0.7));

    vec2 pos = scaled_pos + offset;
    float field = quantum_noise(pos * 4.0);

    density += field * exp(-length(pos));
  }

    // Create expanding space visualization
  float space_grid = 0.0;
  vec2 grid_uv = uv * 4.0 / scale_factor;

    // Grid lines
  float grid_x = abs(fract(grid_uv.x + 0.5) - 0.5);
  float grid_y = abs(fract(grid_uv.y + 0.5) - 0.5);
  space_grid = exp(-min(grid_x, grid_y) * 16.0);

    // Add expansion effects
  float expansion = exp(-length(uv) * 0.5);
  vec2 flow = normalize(uv) * inflation_time;
  float flow_lines = sin(dot(grid_uv, flow) * 2.0 - t * 4.0);
  flow_lines = flow_lines * 0.5 + 0.5;

    // Create horizon visualization
  float horizon = smoothstep(scale_factor, scale_factor - 0.5, length(uv));

    // Combine visual elements
  vec3 fluctuation_color = mix(vec3(0.2, 0.4, 0.8),  // Cold regions
  vec3(0.8, 0.4, 0.2),  // Hot regions
  fluctuations);

  vec3 density_color = mix(vec3(0.1, 0.2, 0.4),  // Void regions
  vec3(0.8, 0.6, 0.4),  // Dense regions
  density);

    // Add grid and expansion effects
  color = mix(fluctuation_color, density_color, 0.5);

  color += vec3(0.2, 0.4, 0.8) * space_grid * 0.2;
  color += vec3(0.4, 0.6, 1.0) * flow_lines * 0.1;

    // Add horizon effects
  color = mix(color, vec3(0.1, 0.2, 0.4), 1.0 - horizon);

    // Add quantum foam background
  vec2 foam_uv = uv * 16.0 / scale_factor;
  float foam = sin(foam_uv.x + t) * sin(foam_uv.y + t * 1.2);
  foam = foam * 0.5 + 0.5;

  color += vec3(0.2, 0.3, 0.5) * foam * 0.05;

    // Add glow at inflation boundary
  float boundary = exp(-pow(abs(length(uv) - scale_factor), 2.0) * 4.0);
  color += vec3(0.8, 0.6, 0.4) * boundary;

    // Tone mapping
  color = pow(color, vec3(0.8));

  return vec4(color, 1.0);
}
