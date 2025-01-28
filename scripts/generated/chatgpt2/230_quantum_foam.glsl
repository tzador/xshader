/*
Quantum Foam
Creates a visualization of Planck-scale spacetime fluctuations
with virtual particle pairs and quantum uncertainty.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 3.0;
  vec3 color = vec3(0.0);

    // Quantum parameters
  const float PLANCK_SCALE = 20.0;
  const float UNCERTAINTY = 0.5;
  const int PARTICLE_PAIRS = 12;

    // Create quantum noise function
  float quantum_noise(vec2 p) {
    vec2 ip = floor(p);
    vec2 fp = fract(p);

    float n00 = fract(sin(dot(ip, vec2(127.1, 311.7))) * 43758.5453);
    float n01 = fract(sin(dot(ip + vec2(0.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);
    float n10 = fract(sin(dot(ip + vec2(1.0, 0.0), vec2(127.1, 311.7))) * 43758.5453);
    float n11 = fract(sin(dot(ip + vec2(1.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);

        // Quantum uncertainty
    fp = fp * fp * (3.0 - 2.0 * fp + sin(t + dot(ip, fp)) * UNCERTAINTY);

    return mix(mix(n00, n10, fp.x), mix(n01, n11, fp.x), fp.y);
  }

    // Create spacetime foam
  float foam = 0.0;
  for(int i = 0; i < 4; i++) {
    float scale = pow(2.0, float(i));
    foam += quantum_noise(uv * PLANCK_SCALE * scale + t * scale) / scale;
  }

    // Virtual particle pairs
  for(int i = 0; i < PARTICLE_PAIRS; i++) {
    float angle = float(i) * 6.28319 / float(PARTICLE_PAIRS);
    float time_offset = t + angle;

        // Particle positions with quantum jitter
    vec2 center = vec2(cos(angle), sin(angle)) * (0.5 + 0.3 * sin(time_offset * 2.0));

    vec2 particle1 = center + vec2(cos(time_offset * 3.0), sin(time_offset * 2.0)) * 0.1;

    vec2 particle2 = center - vec2(cos(time_offset * 3.0), sin(time_offset * 2.0)) * 0.1;

        // Quantum tunneling effect
    float tunnel = exp(-length(particle1 - particle2) * 4.0);

        // Heisenberg uncertainty visualization
    float uncertainty1 = quantum_noise(particle1 * 10.0 + t);
    float uncertainty2 = quantum_noise(particle2 * 10.0 + t);

        // Add particles with uncertainty clouds
    float p1 = exp(-length(uv - particle1) * (8.0 + uncertainty1 * 4.0));
    float p2 = exp(-length(uv - particle2) * (8.0 + uncertainty2 * 4.0));

        // Particle colors based on spin states
    vec3 particle_color1 = mix(vec3(0.2, 0.8, 1.0),  // Spin up
    vec3(1.0, 0.2, 0.8),  // Spin down
    uncertainty1);

    vec3 particle_color2 = mix(vec3(1.0, 0.2, 0.8),  // Spin down
    vec3(0.2, 0.8, 1.0),  // Spin up
    uncertainty2);

        // Add quantum entanglement effect
    float entanglement = exp(-length(uv - center) * 4.0) * tunnel;

    color += particle_color1 * p1 + particle_color2 * p2;
    color += vec3(0.5, 0.8, 1.0) * entanglement * 0.2;
  }

    // Add foam effect to final color
  color = mix(color, vec3(0.1, 0.3, 0.6) + vec3(foam * 0.5), 0.3);

    // Add quantum fluctuation glow
  float glow = exp(-length(uv) * 2.0);
  color += vec3(0.2, 0.4, 0.8) * glow * foam;

    // Add vacuum energy visualization
  vec2 vacuum_uv = uv * 8.0;
  float vacuum = sin(vacuum_uv.x + t) * sin(vacuum_uv.y + t * 1.2);
  vacuum = vacuum * 0.5 + 0.5;
  color += vec3(0.1, 0.2, 0.4) * vacuum * 0.1;

    // Tone mapping
  color = pow(color, vec3(0.8));

  return vec4(color, 1.0);
}
