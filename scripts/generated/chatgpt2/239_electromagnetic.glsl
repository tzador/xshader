/*
Electromagnetic Field Simulation
Visualizes electromagnetic wave propagation, field interactions,
and complex interference patterns in a 2D system.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 6.0;
  vec3 color = vec3(0.0);

    // Field parameters
  float wave_time = t * 2.0;
  float field_strength = 0.9;
  float interaction_strength = 0.8;

    // Wave parameters
  float wavelength = 1.0;
  float frequency = 2.0;
  float phase_velocity = 1.0;

    // Electric field sources
  vec2[6] sources;
  for(int i = 0; i < 6; i++) {
    float angle = float(i) * 1.0472;
    sources[i] = vec2(cos(angle + wave_time * 0.3), sin(angle + wave_time * 0.4)) * 2.0;
  }

    // Calculate electric field
  vec2 e_field = vec2(0.0);
  float charge_density = 0.0;

  for(int i = 0; i < 6; i++) {
    vec2 rel_pos = uv - sources[i];
    float dist = length(rel_pos);
    vec2 dir = normalize(rel_pos);

        // Coulomb field
    vec2 coulomb = dir / (dist * dist + 0.1);

        // Oscillating charge
    float charge = sin(wave_time * frequency + float(i) * 1.0472);

    e_field += coulomb * charge * field_strength;
    charge_density += charge * exp(-dist * 2.0);
  }

    // Calculate magnetic field (curl of vector potential)
  float b_field = 0.0;
  for(int i = 0; i < 6; i++) {
    vec2 rel_pos = uv - sources[i];
    float dist = length(rel_pos);
    float angle = atan(rel_pos.y, rel_pos.x);

        // Vector potential
    float a_field = sin(wave_time * frequency - dist * wavelength);
    a_field *= exp(-dist * 0.5);

        // Curl gives magnetic field
    b_field += a_field * sin(angle + wave_time);
  }

    // Generate wave propagation
  float waves = 0.0;
  for(int i = 0; i < 6; i++) {
    vec2 rel_pos = uv - sources[i];
    float dist = length(rel_pos);

        // Electromagnetic wave
    float wave = sin(dist * wavelength - wave_time * phase_velocity);
    wave *= exp(-dist * 0.5);

    waves += wave;
  }

    // Calculate interference patterns
  float interference = 0.0;
  for(int i = 0; i < 6; i++) {
    for(int j = i + 1; j < 6; j++) {
      vec2 pos_i = sources[i];
      vec2 pos_j = sources[j];

      float dist_i = length(uv - pos_i);
      float dist_j = length(uv - pos_j);

      float phase_diff = (dist_i - dist_j) * wavelength;
      interference += sin(phase_diff - wave_time * 2.0);
    }
  }

    // Add quantum effects
  float quantum_field = 0.0;
  for(int i = 0; i < 4; i++) {
    float scale = pow(2.0, float(i));
    vec2 qf_pos = uv * scale + vec2(cos(wave_time * 0.5 * scale), sin(wave_time * 0.7 * scale));

    float phase = dot(qf_pos, normalize(e_field));
    quantum_field += sin(phase * 4.0 - wave_time * 2.0) / scale;
  }

    // Combine field components
  float e_magnitude = length(e_field);
  float b_magnitude = abs(b_field) * 0.5 + 0.5;
  float wave_pattern = waves * 0.5 + 0.5;
  float interference_pattern = interference * 0.2 + 0.5;
  float quantum_pattern = quantum_field * 0.5 + 0.5;

    // Create color gradients for different field components
  vec3 electric_color = mix(vec3(0.1, 0.4, 0.7),  // Weak electric field
  vec3(0.7, 0.2, 0.3),  // Strong electric field
  e_magnitude);

  vec3 magnetic_color = mix(vec3(0.2, 0.5, 0.3),  // Weak magnetic field
  vec3(0.8, 0.7, 0.2),  // Strong magnetic field
  b_magnitude);

  vec3 wave_color = mix(vec3(0.2, 0.3, 0.5),  // Wave troughs
  vec3(0.6, 0.8, 0.9),  // Wave peaks
  wave_pattern);

    // Combine colors with field properties
  color = electric_color * (1.0 + e_magnitude * 0.5);
  color += magnetic_color * b_magnitude * interaction_strength;
  color += wave_color * wave_pattern * interaction_strength;

    // Add interference effects
  color = mix(color, vec3(0.8, 0.9, 1.0), interference_pattern * 0.3);

    // Add quantum effects
  color += vec3(0.6, 0.7, 0.9) * quantum_pattern * 0.2;

    // Add field lines
  float field_lines = sin(dot(normalize(e_field), uv) * 8.0 - wave_time * 2.0);
  field_lines = field_lines * 0.5 + 0.5;
  color += vec3(0.7, 0.8, 0.9) * field_lines * 0.1;

    // Add charge density visualization
  color = mix(color, vec3(0.9, 0.8, 0.7), charge_density * 0.2);

    // Add wave nodes
  float nodes = 1.0;
  for(int i = 0; i < 6; i++) {
    float dist = length(uv - sources[i]);
    nodes *= smoothstep(0.0, 0.2, dist);
  }
  color *= nodes;

    // Tone mapping and color adjustment
  color = pow(color, vec3(0.8));
  color = mix(color, vec3(length(color)), 0.1);

  return vec4(color, 1.0);
}
