/*
Cosmological Evolution
Visualizes cosmic expansion, structure formation,
dark energy effects, and galaxy clustering.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Cosmic parameters
    float cosmic_time = t * 1.0;
    float expansion_rate = 0.8;
    float dark_energy = 0.7;

    // System parameters
    const int GALAXIES = 8;
    const float GRAVITATIONAL_CONSTANT = 0.1;

    // Cosmic noise function
    float cosmic_noise(vec2 p, float freq) {
        vec2 i = floor(p * freq);
        vec2 f = fract(p * freq);

        float a = fract(sin(dot(i, vec2(127.1, 311.7))) * 43758.5453);
        float b = fract(sin(dot(i + vec2(1.0, 0.0), vec2(127.1, 311.7))) * 43758.5453);
        float c = fract(sin(dot(i + vec2(0.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);
        float d = fract(sin(dot(i + vec2(1.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);

        f = f * f * (3.0 - 2.0 * f);

        return mix(
            mix(a, b, f.x),
            mix(c, d, f.x),
            f.y
        );
    }

    // Generate galaxy distribution
    float matter_density = 0.0;
    vec2 gravitational_flow = vec2(0.0);

    for(int i = 0; i < GALAXIES; i++) {
        float phase = float(i) * 6.28319 / float(GALAXIES);

        // Galaxy position with cosmic expansion
        vec2 galaxy_pos = vec2(
            cos(phase + cosmic_time * 0.2),
            sin(phase + cosmic_time * 0.3)
        ) * (1.5 + expansion_rate * cosmic_time * 0.1);

        // Calculate gravitational effects
        vec2 rel_pos = uv - galaxy_pos;
        float dist = length(rel_pos);

        // Matter distribution
        float mass = 1.0 + 0.5 * sin(cosmic_time * (0.5 + float(i) * 0.1));
        float density = mass * exp(-dist * 2.0);
        matter_density += density;

        // Gravitational field
        gravitational_flow += normalize(rel_pos) * (GRAVITATIONAL_CONSTANT * mass / (dist * dist + 0.1));
    }

    // Calculate cosmic expansion
    float expansion = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 exp_pos = uv * scale * (1.0 + expansion_rate * cosmic_time * 0.05);

        expansion += cosmic_noise(exp_pos, 1.0) / scale;
    }

    // Generate dark energy effects
    float dark_field = 0.0;
    vec2 dark_center = vec2(
        cos(cosmic_time * 0.4),
        sin(cosmic_time * 0.5)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 dark_dir = vec2(cos(angle), sin(angle));

        float field = exp(-length(uv - dark_center - dark_dir) * 2.0);
        field *= sin(length(uv - dark_center) * 4.0 - cosmic_time);

        dark_field += field;
    }

    // Calculate structure formation
    float structure = 0.0;
    for(int i = 0; i < 5; i++) {
        float scale = pow(2.0, float(i));
        vec2 struct_pos = uv * scale + gravitational_flow * cosmic_time;

        float pattern = cosmic_noise(struct_pos, 2.0);
        pattern = pow(pattern, 1.5); // Non-linear structure growth

        structure += pattern / scale;
    }

    // Generate cosmic web
    float cosmic_web = 0.0;
    for(int i = 0; i < GALAXIES; i++) {
        for(int j = i + 1; j < GALAXIES; j++) {
            float phase_i = float(i) * 6.28319 / float(GALAXIES);
            float phase_j = float(j) * 6.28319 / float(GALAXIES);

            vec2 pos_i = vec2(cos(phase_i), sin(phase_i)) * 1.5;
            vec2 pos_j = vec2(cos(phase_j), sin(phase_j)) * 1.5;

            vec2 filament_dir = normalize(pos_j - pos_i);
            float filament = exp(-abs(dot(uv - pos_i, vec2(filament_dir.y, -filament_dir.x))) * 4.0);

            cosmic_web += filament;
        }
    }

    // Calculate redshift effects
    float redshift = 0.0;
    for(int i = 0; i < GALAXIES; i++) {
        float phase = float(i) * 6.28319 / float(GALAXIES);
        vec2 galaxy_pos = vec2(cos(phase), sin(phase)) * 1.5;

        float doppler = dot(normalize(uv - galaxy_pos),
                          vec2(cos(cosmic_time), sin(cosmic_time)));
        redshift += doppler * exp(-length(uv - galaxy_pos) * 2.0);
    }

    // Create color gradients
    vec3 matter_color = mix(
        vec3(0.2, 0.4, 0.8),  // Low density
        vec3(0.8, 0.3, 0.2),  // High density
        matter_density
    );

    vec3 expansion_color = mix(
        vec3(0.3, 0.7, 0.2),  // Early universe
        vec3(0.9, 0.8, 0.3),  // Late universe
        expansion
    );

    vec3 dark_color = mix(
        vec3(0.2, 0.3, 0.5),  // Weak dark energy
        vec3(0.7, 0.5, 0.8),  // Strong dark energy
        dark_field
    );

    // Combine visualization components
    color = matter_color * (1.0 + matter_density * 0.5);
    color += expansion_color * expansion * expansion_rate;
    color += dark_color * dark_field * dark_energy;

    // Add structure formation effects
    vec3 structure_color = mix(
        vec3(0.4, 0.6, 0.8),  // Uniform matter
        vec3(0.8, 0.7, 0.3),  // Clustered matter
        structure
    );
    color += structure_color * structure * 0.3;

    // Add cosmic web visualization
    color = mix(
        color,
        vec3(0.6, 0.8, 0.9),
        cosmic_web * 0.2
    );

    // Add redshift effects
    color *= mix(
        vec3(1.0, 0.8, 0.6),  // Blueshift
        vec3(0.6, 0.8, 1.0),  // Redshift
        redshift * 0.5 + 0.5
    );

    // Add cosmic microwave background
    vec2 cmb_uv = uv * 16.0;
    float cmb = cosmic_noise(cmb_uv + cosmic_time, 1.0);
    color += vec3(0.6, 0.5, 0.4) * cmb * 0.1;

    // Add gravitational lensing
    float lensing = length(gravitational_flow);
    color = mix(
        color,
        vec3(0.8, 0.9, 1.0),
        lensing * 0.2
    );

    // Add quantum fluctuations
    vec2 quantum_uv = uv * 32.0;
    float quantum = cosmic_noise(quantum_uv + cosmic_time, 1.0);
    color += vec3(0.3, 0.4, 0.5) * quantum * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
