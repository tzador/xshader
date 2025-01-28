/*
Relativistic Spacetime
Visualizes relativistic effects including time dilation,
length contraction, and light cone dynamics.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Relativistic parameters
    float rel_time = t * 1.5;
    float velocity = 0.9; // As fraction of c
    float gamma = 1.0 / sqrt(1.0 - velocity * velocity);

    // System parameters
    const int WORLDLINES = 6;
    const float LIGHT_SPEED = 1.0;

    // Spacetime noise function
    float spacetime_noise(vec2 p, float freq) {
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

    // Generate worldlines
    float worldline_pattern = 0.0;
    vec2 spacetime_flow = vec2(0.0);

    for(int i = 0; i < WORLDLINES; i++) {
        float phase = float(i) * 6.28319 / float(WORLDLINES);

        // Worldline path
        vec2 worldline_pos = vec2(
            cos(phase + rel_time * 0.3),
            sin(phase + rel_time * 0.4)
        ) * 1.5;

        // Apply Lorentz transformation
        vec2 boosted_pos = vec2(
            gamma * (worldline_pos.x - velocity * rel_time),
            worldline_pos.y
        );

        // Calculate proper time
        float proper_time = sqrt(dot(boosted_pos, boosted_pos));

        // Time dilation effect
        float dilated_time = gamma * proper_time;

        // Length contraction
        vec2 contracted_pos = vec2(
            boosted_pos.x / gamma,
            boosted_pos.y
        );

        // Calculate worldline contribution
        vec2 rel_pos = uv - contracted_pos;
        float dist = length(rel_pos);

        float worldline = exp(-dist * 4.0);
        worldline *= sin(dilated_time * 4.0 - rel_time * 2.0);

        worldline_pattern += worldline;
        spacetime_flow += normalize(rel_pos) * worldline;
    }

    // Generate light cones
    float light_cones = 0.0;
    vec2 cone_center = vec2(
        cos(rel_time * 0.5),
        sin(rel_time * 0.7)
    );

    for(int i = 0; i < 4; i++) {
        float angle = float(i) * 1.5708;
        vec2 cone_dir = vec2(cos(angle), sin(angle));

        // Light cone equation
        float space_comp = dot(uv - cone_center, cone_dir);
        float time_comp = length(uv - cone_center);

        float cone = exp(-abs(abs(space_comp) - LIGHT_SPEED * time_comp) * 4.0);
        light_cones += cone;
    }

    // Calculate relativistic causality
    float causality = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 causal_pos = uv * scale + spacetime_flow * rel_time;

        float causal = spacetime_noise(causal_pos, 1.0);
        causality += causal / scale;
    }

    // Generate spacetime curvature
    float curvature = 0.0;
    for(int i = 0; i < WORLDLINES; i++) {
        float phase = float(i) * 6.28319 / float(WORLDLINES);
        vec2 mass_pos = vec2(
            cos(phase + rel_time * 0.2),
            sin(phase + rel_time * 0.3)
        ) * 1.5;

        // Gravitational time dilation
        float grav_potential = 1.0 / (length(uv - mass_pos) + 0.1);
        float time_dilation = sqrt(1.0 - grav_potential);

        curvature += grav_potential;
    }

    // Create relativistic Doppler effect
    float doppler = 0.0;
    vec2 observer_pos = vec2(
        cos(rel_time * 0.4),
        sin(rel_time * 0.6)
    );

    for(int i = 0; i < WORLDLINES; i++) {
        float phase = float(i) * 6.28319 / float(WORLDLINES);
        vec2 source_pos = vec2(cos(phase), sin(phase)) * 1.5;

        vec2 rel_vel = normalize(source_pos - observer_pos) * velocity;
        float doppler_factor = sqrt((1.0 + dot(normalize(uv - source_pos), rel_vel)) /
                                  (1.0 - dot(normalize(uv - source_pos), rel_vel)));

        doppler += doppler_factor;
    }

    // Create color gradients
    vec3 worldline_color = mix(
        vec3(0.2, 0.4, 0.8),  // Past
        vec3(0.8, 0.3, 0.2),  // Future
        worldline_pattern
    );

    vec3 lightcone_color = mix(
        vec3(0.3, 0.7, 0.2),  // Spacelike
        vec3(0.9, 0.8, 0.3),  // Timelike
        light_cones
    );

    vec3 causality_color = mix(
        vec3(0.2, 0.3, 0.5),  // Acausal
        vec3(0.7, 0.5, 0.8),  // Causal
        causality
    );

    // Combine visualization components
    color = worldline_color * (1.0 + worldline_pattern * 0.5);
    color += lightcone_color * light_cones * 0.3;
    color += causality_color * causality * 0.2;

    // Add curvature effects
    vec3 curvature_color = mix(
        vec3(0.4, 0.6, 0.8),  // Flat spacetime
        vec3(0.8, 0.7, 0.3),  // Curved spacetime
        curvature
    );
    color = mix(color, curvature_color, curvature * 0.3);

    // Add Doppler effects
    color *= mix(
        vec3(0.8, 0.2, 0.2),  // Redshift
        vec3(0.2, 0.2, 0.8),  // Blueshift
        doppler * 0.5 + 0.5
    );

    // Add relativistic aberration
    float aberration = atan(
        sin(atan(uv.y, uv.x)) * gamma,
        cos(atan(uv.y, uv.x))
    );
    color += vec3(0.5, 0.6, 0.7) * sin(aberration * 8.0) * 0.1;

    // Add quantum fluctuations
    vec2 quantum_uv = uv * 16.0;
    float quantum = spacetime_noise(quantum_uv + rel_time, 1.0);
    color += vec3(0.3, 0.4, 0.5) * quantum * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
