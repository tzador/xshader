/*
3D DNA Molecule
Creates a visualization of DNA with protein interactions,
molecular dynamics, and base pair matching.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 3.0;
  vec3 color = vec3(0.0);

    // DNA parameters
  const float HELIX_RADIUS = 0.4;
  const float HELIX_PITCH = 2.0;
  const float BASE_PAIR_SPACING = 0.2;

    // Create rotation matrices
  float time = t * 0.2;
  mat2 rot = mat2(cos(time), -sin(time), sin(time), cos(time));
  uv = rot * uv;

    // Helix backbone positions
  float y_offset = mod(t, HELIX_PITCH);
  float z = uv.y + y_offset;

  vec2 helix1 = vec2(HELIX_RADIUS * cos(z * 3.14159), HELIX_RADIUS * sin(z * 3.14159));

  vec2 helix2 = vec2(HELIX_RADIUS * cos(z * 3.14159 + 3.14159), HELIX_RADIUS * sin(z * 3.14159 + 3.14159));

    // Draw DNA backbones
  float backbone1 = exp(-length(uv - helix1) * 16.0);
  float backbone2 = exp(-length(uv - helix2) * 16.0);

  vec3 backbone_color = vec3(0.8, 0.2, 0.2);  // Red backbone
  color += backbone_color * (backbone1 + backbone2);

    // Base pairs
  float base_z = floor(z / BASE_PAIR_SPACING) * BASE_PAIR_SPACING;
  for(int i = -2; i <= 2; i++) {
    float current_z = base_z + float(i) * BASE_PAIR_SPACING;

        // Base pair positions
    vec2 base1 = vec2(HELIX_RADIUS * cos(current_z * 3.14159), HELIX_RADIUS * sin(current_z * 3.14159));

    vec2 base2 = vec2(HELIX_RADIUS * cos(current_z * 3.14159 + 3.14159), HELIX_RADIUS * sin(current_z * 3.14159 + 3.14159));

        // Base pair connection
    vec2 base_dir = normalize(base2 - base1);
    vec2 base_center = (base1 + base2) * 0.5;

    float base_dist = abs(dot(uv - base_center, vec2(base_dir.y, -base_dir.x)));
    float base_proj = dot(uv - base_center, base_dir);

    float base_pair = exp(-base_dist * 16.0) *
      smoothstep(1.0, 0.8, abs(base_proj / HELIX_RADIUS));

        // Base pair coloring (AT/GC)
    float base_type = fract(sin(current_z * 45.67) * 43758.5453);
    vec3 base_color = mix(vec3(0.2, 0.8, 0.2),  // AT pair
    vec3(0.2, 0.2, 0.8),  // GC pair
    step(0.5, base_type));

    color += base_color * base_pair;
  }

    // Protein interaction sites
  for(int i = 0; i < 4; i++) {
    float angle = float(i) * 1.5708 + t;
    vec2 protein_pos = vec2(cos(angle), sin(angle)) * HELIX_RADIUS * 1.5;

        // Protein visualization
    float protein = exp(-length(uv - protein_pos) * 8.0);

        // Interaction dynamics
    float interaction = sin(length(uv - protein_pos) * 8.0 - t * 4.0);
    interaction = interaction * 0.5 + 0.5;

        // Add protein and interaction effects
    vec3 protein_color = mix(vec3(1.0, 0.8, 0.2),  // Protein
    vec3(0.2, 1.0, 0.8),  // Interaction
    interaction);

    color += protein_color * protein * 0.5;

        // Add connection lines to DNA
    float connect_dist = min(length(protein_pos - helix1), length(protein_pos - helix2));

    float connection = exp(-connect_dist * 2.0) *
      exp(-length(uv - protein_pos) * 2.0);

    color += vec3(0.5, 0.5, 0.8) * connection * interaction;
  }

    // Add molecular dynamics
  vec2 dynamics_uv = uv * 4.0;
  float dynamics = sin(dynamics_uv.x + t) * sin(dynamics_uv.y + t * 1.5);
  dynamics = dynamics * 0.5 + 0.5;

  color += vec3(0.2, 0.4, 0.8) * dynamics * 0.1;

    // Add glow
  float glow = exp(-length(uv) * 2.0);
  color += vec3(0.2, 0.3, 0.5) * glow;

    // Tone mapping
  color = pow(color, vec3(0.8));

  return vec4(color, 1.0);
}
