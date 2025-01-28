/*
Cosmic Strings
Creates a visualization of cosmic string networks with
string interactions and topological defects.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 4.0;
  vec3 color = vec3(0.0);

    // String network parameters
  const int STRING_COUNT = 8;
  const float TENSION = 2.0;
  const float INTERACTION_STRENGTH = 0.5;

    // String properties
  vec2 string_pos[STRING_COUNT];
  vec2 string_vel[STRING_COUNT];
  float string_phase[STRING_COUNT];

    // Initialize strings
  for(int i = 0; i < STRING_COUNT; i++) {
    float angle = float(i) * 6.28319 / float(STRING_COUNT);
    string_pos[i] = vec2(cos(angle) * (1.0 + 0.3 * sin(t * 0.5 + angle)), sin(angle) * (1.0 + 0.3 * cos(t * 0.7 + angle)));

    string_vel[i] = vec2(cos(t * 0.3 + angle * 1.5), sin(t * 0.4 + angle * 1.2)) * 0.2;

    string_phase[i] = fract(sin(float(i) * 45.67) * 43758.5453);
  }

    // Calculate string network
  for(int i = 0; i < STRING_COUNT; i++) {
    vec2 pos = string_pos[i];
    vec2 vel = string_vel[i];
    float phase = string_phase[i];

        // String core visualization
    float core = 0.0;
    vec2 string_uv = uv - pos;
    float string_angle = atan(string_uv.y, string_uv.x);

        // Create string field
    float field = sin(string_angle + phase * 6.28319);
    float amplitude = exp(-length(string_uv) * TENSION);

        // Add oscillations along string
    float oscillation = sin(dot(string_uv, vel) * 10.0 - t * 4.0);
    amplitude *= 1.0 + 0.2 * oscillation;

    core += field * amplitude;

        // String interactions
    for(int j = 0; j < STRING_COUNT; j++) {
      if(i != j) {
        vec2 other_pos = string_pos[j];
        float dist = length(pos - other_pos);

        if(dist < 1.0) {
                    // Calculate interaction region
          vec2 interaction_center = (pos + other_pos) * 0.5;
          float interaction = exp(-length(uv - interaction_center) * 4.0);

                    // Phase difference
          float phase_diff = abs(string_phase[i] - string_phase[j]);
          phase_diff = min(phase_diff, 1.0 - phase_diff);

                    // Create topological defect
          float defect = exp(-length(uv - interaction_center) * 8.0);
          defect *= sin(atan(uv.y - interaction_center.y, uv.x - interaction_center.x) *
            floor(1.0 / phase_diff));

                    // Add interaction effects
          core += defect * INTERACTION_STRENGTH;
          color += vec3(1.0, 0.5, 0.2) * defect * phase_diff;
        }
      }
    }

        // Add string color
    vec3 string_color = mix(vec3(0.2, 0.5, 1.0),  // Base color
    vec3(1.0, 0.8, 0.4),  // Excited state
    abs(core));

    color += string_color * abs(core);
  }

    // Add network energy visualization
  for(int i = 0; i < STRING_COUNT; i++) {
    for(int j = i + 1; j < STRING_COUNT; j++) {
      vec2 pos1 = string_pos[i];
      vec2 pos2 = string_pos[j];

            // Create energy connection
      vec2 connection = pos2 - pos1;
      float connection_length = length(connection);
      vec2 connection_dir = connection / connection_length;

            // Calculate energy field
      float energy = exp(-abs(dot(uv - pos1, vec2(connection_dir.y, -connection_dir.x))) * 8.0);

      energy *= smoothstep(connection_length + 0.1, connection_length - 0.1, length(connection * clamp(dot(uv - pos1, connection_dir) / connection_length, 0.0, 1.0)));

            // Add energy visualization
      color += vec3(0.2, 0.4, 0.8) * energy * 0.2;
    }
  }

    // Add background fluctuations
  vec2 fluct_uv = uv * 4.0;
  float fluctuation = sin(fluct_uv.x + t) * sin(fluct_uv.y + t * 1.2);
  fluctuation = fluctuation * 0.5 + 0.5;

  color += vec3(0.1, 0.2, 0.4) * fluctuation * 0.1;

    // Tone mapping
  color = pow(color, vec3(0.8));

  return vec4(color, 1.0);
}
