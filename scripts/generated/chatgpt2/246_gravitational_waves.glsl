/*
Gravitational Wave Patterns
Visualizes binary black hole mergers, spacetime ripples,
and gravitational wave interference patterns.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Gravitational parameters
    float grav_time = t * 1.5;
    float wave_strength = 0.9;
    float spacetime_curvature = 0.8;

    // Binary system parameters
    const int BINARY_PAIRS = 3;
    const float ORBITAL_DECAY = 0.2;

    // Gravitational wave function
    float grav_wave(vec2 pos, float freq, float phase) {
        float dist = length(pos);
        float angle = atan(pos.y, pos.x);

        // Quadrupole radiation pattern
        float pattern = cos(2.0 * angle);

        // Wave propagation
        float wave = sin(dist * freq - phase);
        wave *= exp(-dist * 0.5);

        return wave * pattern;
    }

    // Generate binary black hole systems
    float total_strain = 0.0;
    vec2 spacetime_flow = vec2(0.0);

    for(int i = 0; i < BINARY_PAIRS; i++) {
        float pair_phase = float(i) * 2.0944 + grav_time * 0.2;
        float orbital_radius = 1.0 - ORBITAL_DECAY * (1.0 - cos(grav_time * 0.1));

        // Binary center position
        vec2 binary_center = vec2(
            cos(pair_phase),
            sin(pair_phase)
        ) * 1.5;

        // Black hole positions
        vec2 bh1_pos = binary_center + vec2(
            cos(grav_time * 2.0) * orbital_radius,
            sin(grav_time * 2.0) * orbital_radius
        );

        vec2 bh2_pos = binary_center - vec2(
            cos(grav_time * 2.0) * orbital_radius,
            sin(grav_time * 2.0) * orbital_radius
        );

        // Calculate gravitational waves
        float strain1 = grav_wave(uv - bh1_pos, 4.0, grav_time * 4.0);
        float strain2 = grav_wave(uv - bh2_pos, 4.0, grav_time * 4.0 + 3.14159);

        // Combine strains
        float combined_strain = strain1 + strain2;
        total_strain += combined_strain;

        // Calculate spacetime distortion
        vec2 distortion1 = normalize(uv - bh1_pos) / pow(length(uv - bh1_pos) + 0.1, 2.0);
        vec2 distortion2 = normalize(uv - bh2_pos) / pow(length(uv - bh2_pos) + 0.1, 2.0);

        spacetime_flow += (distortion1 + distortion2) * orbital_radius;
    }

    // Generate gravitational wave interference
    float interference = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 wave_pos = uv * scale + spacetime_flow * grav_time;

        float wave = sin(wave_pos.x * 4.0 + grav_time) *
            sin(wave_pos.y * 4.0 + grav_time * 1.2);

        interference += wave / scale;
    }

    // Calculate spacetime curvature
    float curvature = 0.0;
    vec2 curve_center = vec2(
        cos(grav_time * 0.3),
        sin(grav_time * 0.4)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 offset = vec2(cos(angle), sin(angle));

        float curve = exp(-length(uv - curve_center - offset) * 2.0);
        curve *= sin(length(uv - curve_center) * 8.0 - grav_time * 2.0);

        curvature += curve;
    }

    // Generate gravitational lensing
    float lensing = 0.0;
    for(int i = 0; i < BINARY_PAIRS; i++) {
        float phase = float(i) * 2.0944 + grav_time * 0.2;
        vec2 lens_center = vec2(
            cos(phase),
            sin(phase)
        ) * 1.5;

        float lens = exp(-length(uv - lens_center) * 4.0);
        lens *= sin(length(uv - lens_center) * 16.0 - grav_time * 4.0);

        lensing += lens;
    }

    // Create color gradients
    vec3 wave_color = mix(
        vec3(0.1, 0.2, 0.4),  // Weak waves
        vec3(0.8, 0.7, 0.2),  // Strong waves
        abs(total_strain) * wave_strength
    );

    vec3 curvature_color = mix(
        vec3(0.2, 0.4, 0.6),  // Flat spacetime
        vec3(0.8, 0.3, 0.5),  // Curved spacetime
        curvature * spacetime_curvature
    );

    vec3 lensing_color = mix(
        vec3(0.3, 0.5, 0.7),  // Weak lensing
        vec3(0.9, 0.8, 0.4),  // Strong lensing
        lensing
    );

    // Combine visualization components
    color = wave_color * (1.0 + abs(total_strain) * 0.5);
    color += curvature_color * curvature * 0.5;
    color += lensing_color * lensing * 0.3;

    // Add interference patterns
    color += vec3(0.6, 0.7, 0.8) * interference * 0.2;

    // Add event horizon effects
    float horizon = 0.0;
    for(int i = 0; i < BINARY_PAIRS; i++) {
        float phase = float(i) * 2.0944 + grav_time * 0.2;
        vec2 horizon_center = vec2(cos(phase), sin(phase)) * 1.5;

        horizon += exp(-length(uv - horizon_center) * 8.0);
    }
    color = mix(color, vec3(0.0), horizon);

    // Add gravitational wave ripples
    vec2 ripple_uv = uv * 8.0;
    float ripples = sin(ripple_uv.x + grav_time) * sin(ripple_uv.y + grav_time * 1.2);
    color += vec3(0.5, 0.6, 0.7) * ripples * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
