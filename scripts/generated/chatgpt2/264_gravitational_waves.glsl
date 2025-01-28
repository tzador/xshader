/*
Gravitational Wave Patterns
Visualizes binary black hole mergers,
spacetime ripples, and gravitational radiation.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Gravitational parameters
    float grav_time = t * 0.6;
    float mass_ratio = 0.7;
    float orbital_frequency = 0.8;

    // System constants
    const float GRAVITATIONAL_CONSTANT = 0.1;
    const float SPEED_OF_LIGHT = 1.0;
    const int WAVE_MODES = 8;

    // Gravitational noise function
    float grav_noise(vec2 p, float freq) {
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

    // Calculate binary black hole positions
    vec2 bh1_pos = vec2(
        cos(grav_time * orbital_frequency),
        sin(grav_time * orbital_frequency)
    ) * 1.0;

    vec2 bh2_pos = -bh1_pos * mass_ratio;

    // Calculate gravitational potential
    float potential = 0.0;
    vec2 spacetime_curvature = vec2(0.0);

    // Primary black hole
    vec2 rel_pos1 = uv - bh1_pos;
    float dist1 = length(rel_pos1);
    float mass1 = 1.0;
    float potential1 = -GRAVITATIONAL_CONSTANT * mass1 / (dist1 + 0.1);
    spacetime_curvature += normalize(rel_pos1) * potential1;

    // Secondary black hole
    vec2 rel_pos2 = uv - bh2_pos;
    float dist2 = length(rel_pos2);
    float mass2 = mass_ratio;
    float potential2 = -GRAVITATIONAL_CONSTANT * mass2 / (dist2 + 0.1);
    spacetime_curvature += normalize(rel_pos2) * potential2;

    potential = potential1 + potential2;

    // Generate gravitational waves
    float wave_amplitude = 0.0;
    for(int i = 0; i < WAVE_MODES; i++) {
        float phase = float(i) * 6.28319 / float(WAVE_MODES);
        vec2 wave_dir = vec2(cos(phase), sin(phase));

        float wave = sin(dot(uv, wave_dir) * 4.0 - grav_time * SPEED_OF_LIGHT);
        wave *= exp(-dist1 * 0.5) + exp(-dist2 * 0.5); // Wave amplitude decay

        wave_amplitude += wave;
    }

    // Calculate event horizons
    float event_horizon = 0.0;
    float horizon_radius1 = 0.2;
    float horizon_radius2 = horizon_radius1 * mass_ratio;

    event_horizon += smoothstep(horizon_radius1, 0.0, dist1);
    event_horizon += smoothstep(horizon_radius2, 0.0, dist2);

    // Generate gravitational radiation
    float radiation = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 rad_pos = uv * scale + spacetime_curvature * grav_time;

        float rad = grav_noise(rad_pos, 2.0);
        rad = pow(rad, 1.5);

        radiation += rad / scale;
    }

    // Calculate frame dragging
    float frame_dragging = 0.0;
    vec2 drag_flow = vec2(0.0);

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 drag_dir = vec2(cos(angle), sin(angle));

        float drag = exp(-abs(dot(uv, drag_dir)) * 3.0);
        drag *= sin(dot(uv, drag_dir) * 8.0 - grav_time * 2.0);

        frame_dragging += drag;
        drag_flow += drag_dir * drag;
    }

    // Generate spacetime distortions
    float distortion = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 dist_pos = uv * scale + drag_flow * grav_time;

        float dist = grav_noise(dist_pos, 4.0);
        distortion += dist / scale;
    }

    // Create color gradients
    vec3 potential_color = mix(
        vec3(0.2, 0.4, 0.8),  // Weak gravity
        vec3(0.8, 0.3, 0.2),  // Strong gravity
        -potential * 2.0
    );

    vec3 wave_color = mix(
        vec3(0.3, 0.6, 0.2),  // Wave troughs
        vec3(0.7, 0.8, 0.3),  // Wave peaks
        wave_amplitude * 0.5 + 0.5
    );

    vec3 horizon_color = mix(
        vec3(0.1, 0.1, 0.2),  // Outside horizon
        vec3(0.0, 0.0, 0.0),  // Inside horizon
        event_horizon
    );

    // Combine visualization components
    color = potential_color;
    color = mix(color, wave_color, 0.4);
    color = mix(color, horizon_color, event_horizon);

    // Add radiation effects
    vec3 radiation_color = mix(
        vec3(0.4, 0.6, 0.8),  // Low radiation
        vec3(0.8, 0.7, 0.3),  // High radiation
        radiation
    );
    color += radiation_color * radiation * 0.3;

    // Add frame dragging visualization
    float drag_pattern = sin(dot(normalize(drag_flow), uv) * 6.0 - grav_time * 2.0);
    drag_pattern = drag_pattern * 0.5 + 0.5;
    color += vec3(0.7, 0.8, 0.9) * drag_pattern * 0.15;

    // Add spacetime distortions
    color += vec3(0.6, 0.7, 0.8) * distortion * 0.2;

    // Add orbital paths
    float orbital_path = 0.0;
    orbital_path += exp(-abs(length(uv) - 1.0) * 8.0);
    orbital_path += exp(-abs(length(uv) - mass_ratio) * 8.0);
    color += vec3(0.5, 0.6, 0.7) * orbital_path * 0.1;

    // Add gravitational lensing
    float lensing = length(spacetime_curvature);
    color = mix(
        color,
        vec3(0.8, 0.9, 1.0),
        lensing * 0.2
    );

    // Add quantum gravity fluctuations
    vec2 quantum_uv = uv * 32.0;
    float quantum = grav_noise(quantum_uv + grav_time, 1.0);
    color += vec3(0.3, 0.4, 0.5) * quantum * 0.05;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
