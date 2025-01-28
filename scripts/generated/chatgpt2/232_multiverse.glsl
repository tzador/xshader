/*
Multiverse Bubbles
Creates a visualization of colliding universe bubbles with
quantum tunneling and vacuum decay effects.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 4.0;
  vec3 color = vec3(0.0);

    // Universe parameters
  const int UNIVERSE_COUNT = 5;
  const float EXPANSION_RATE = 0.5;
  const float TUNNEL_STRENGTH = 0.3;

    // Universe centers and properties
  vec2 centers[UNIVERSE_COUNT];
  float phases[UNIVERSE_COUNT];
  vec3 vacuum_states[UNIVERSE_COUNT];

    // Initialize universes
  for(int i = 0; i < UNIVERSE_COUNT; i++) {
    float angle = float(i) * 6.28319 / float(UNIVERSE_COUNT);
    centers[i] = vec2(cos(angle) * (1.0 + sin(t * 0.5 + angle)), sin(angle) * (1.0 + cos(t * 0.4 + angle)));

    phases[i] = fract(sin(float(i) * 45.67) * 43758.5453);

        // Different vacuum states
    vacuum_states[i] = vec3(sin(phases[i] * 6.28319), sin(phases[i] * 6.28319 + 2.094), sin(phases[i] * 6.28319 + 4.189)) * 0.5 + 0.5;
  }

    // Calculate universe boundaries and interactions
  for(int i = 0; i < UNIVERSE_COUNT; i++) {
    vec2 pos = centers[i];
    float expansion = 1.0 + EXPANSION_RATE * t * (0.5 + 0.5 * sin(phases[i] * 10.0 + t));

        // Universe bubble
    float radius = length(uv - pos);
    float bubble = exp(-pow(radius - expansion, 2.0) * 2.0);

        // Vacuum energy visualization
    vec2 local_uv = (uv - pos) * 4.0;
    float vacuum = sin(local_uv.x + t * phases[i]) *
      sin(local_uv.y + t * (1.0 - phases[i]));
    vacuum = vacuum * 0.5 + 0.5;

        // Add universe color
    vec3 universe_color = vacuum_states[i];
    color += universe_color * bubble * (0.5 + 0.5 * vacuum);

        // Quantum tunneling between universes
    for(int j = 0; j < UNIVERSE_COUNT; j++) {
      if(i != j) {
        vec2 other_pos = centers[j];
        float dist = length(pos - other_pos);

                // Tunneling probability
        float tunnel = exp(-dist * 4.0) * TUNNEL_STRENGTH;

                // Create tunneling path
        vec2 tunnel_dir = normalize(other_pos - pos);
        vec2 tunnel_normal = vec2(-tunnel_dir.y, tunnel_dir.x);

        float tunnel_dist = abs(dot(uv - pos, tunnel_normal));
        float tunnel_proj = dot(uv - pos, tunnel_dir);

        float tunnel_effect = exp(-tunnel_dist * 8.0) *
          smoothstep(-0.2, 0.0, tunnel_proj) *
          smoothstep(dist + 0.2, dist, tunnel_proj);

                // Mix vacuum states in tunneling region
        vec3 mixed_state = mix(vacuum_states[i], vacuum_states[j], tunnel_effect);

        color += mixed_state * tunnel_effect * tunnel;

                // Add quantum fluctuations in tunneling region
        float fluctuation = sin(tunnel_proj * 20.0 + t * 10.0) *
          sin(tunnel_dist * 15.0 - t * 8.0);
        fluctuation = fluctuation * 0.5 + 0.5;

        color += vec3(0.5, 0.8, 1.0) * fluctuation *
          tunnel_effect * tunnel * 0.5;
      }
    }
  }

    // Add bubble collision effects
  for(int i = 0; i < UNIVERSE_COUNT; i++) {
    for(int j = i + 1; j < UNIVERSE_COUNT; j++) {
      vec2 pos1 = centers[i];
      vec2 pos2 = centers[j];
      float dist = length(pos1 - pos2);

      if(dist < 2.0) {
        vec2 collision_center = (pos1 + pos2) * 0.5;
        float collision = exp(-length(uv - collision_center) * 4.0);

                // Create collision shockwave
        float shockwave = sin(length(uv - collision_center) * 10.0 - t * 8.0);
        shockwave = shockwave * 0.5 + 0.5;

        color += vec3(1.0, 0.8, 0.6) * collision * shockwave;
      }
    }
  }

    // Add background quantum foam
  vec2 foam_uv = uv * 8.0;
  float foam = sin(foam_uv.x + t) * sin(foam_uv.y + t * 1.2);
  foam = foam * 0.5 + 0.5;
  color += vec3(0.1, 0.2, 0.4) * foam * 0.1;

    // Tone mapping
  color = pow(color, vec3(0.8));

  return vec4(color, 1.0);
}
