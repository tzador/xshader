/*
Plasma Physics Simulation
Visualizes magnetohydrodynamics, plasma waves, particle
acceleration, and magnetic reconnection events.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Plasma parameters
    float plasma_time = t * 2.0;
    float magnetic_strength = 0.9;
    float plasma_density = 0.8;

    // Field parameters
    const int FIELD_LINES = 8;
    const float RECONNECTION_RATE = 0.3;

    // Plasma noise function
    float plasma_noise(vec2 p, float freq) {
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

    // Generate magnetic field lines
    float magnetic_field = 0.0;
    vec2 field_flow = vec2(0.0);

    for(int i = 0; i < FIELD_LINES; i++) {
        float angle = float(i) * 6.28319 / float(FIELD_LINES);
        vec2 field_center = vec2(
            cos(angle + plasma_time * 0.2),
            sin(angle + plasma_time * 0.3)
        ) * 1.5;

        // Calculate field strength
        vec2 rel_pos = uv - field_center;
        float dist = length(rel_pos);
        vec2 field_dir = normalize(rel_pos);

        // Add field contribution
        float field = exp(-dist * 2.0);
        field *= sin(angle + atan(rel_pos.y, rel_pos.x) * 2.0 + plasma_time);

        magnetic_field += field;
        field_flow += field_dir * field;
    }

    // Generate plasma density fluctuations
    float density = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 density_pos = uv * scale + field_flow * plasma_time;

        density += plasma_noise(density_pos, 1.0) / scale;
    }

    // Calculate plasma waves
    float waves = 0.0;
    vec2 wave_center = vec2(
        cos(plasma_time * 0.5),
        sin(plasma_time * 0.7)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 wave_dir = vec2(cos(angle), sin(angle));

        float wave = sin(dot(uv - wave_center, wave_dir) * 8.0 - plasma_time * 4.0);
        waves += wave;
    }

    // Simulate magnetic reconnection
    float reconnection = 0.0;
    vec2 x_point = vec2(
        cos(plasma_time * 0.3),
        sin(plasma_time * 0.4)
    );

    for(int i = 0; i < 4; i++) {
        float angle = float(i) * 1.5708;
        vec2 reconnection_dir = vec2(cos(angle), sin(angle));

        float current_sheet = exp(-abs(dot(uv - x_point, vec2(reconnection_dir.y, -reconnection_dir.x))) * 8.0);
        current_sheet *= exp(-abs(dot(uv - x_point, reconnection_dir)) * 2.0);

        reconnection += current_sheet;
    }

    // Particle acceleration
    float acceleration = 0.0;
    for(int i = 0; i < 6; i++) {
        float t_offset = plasma_time + float(i) * 1.0472;
        vec2 particle_pos = vec2(
            cos(t_offset * 1.2),
            sin(t_offset * 0.8)
        );

        float particle = exp(-length(uv - particle_pos) * 8.0);
        particle *= sin(length(uv - particle_pos) * 16.0 - plasma_time * 8.0);

        acceleration += particle;
    }

    // Create color gradients
    vec3 magnetic_color = mix(
        vec3(0.2, 0.4, 0.8),  // Weak field
        vec3(0.8, 0.3, 0.2),  // Strong field
        abs(magnetic_field)
    );

    vec3 plasma_color = mix(
        vec3(0.3, 0.5, 0.7),  // Low density
        vec3(0.9, 0.7, 0.3),  // High density
        density
    );

    vec3 wave_color = mix(
        vec3(0.2, 0.3, 0.5),  // Wave troughs
        vec3(0.6, 0.8, 0.9),  // Wave peaks
        waves * 0.5 + 0.5
    );

    // Combine visualization components
    color = magnetic_color * (1.0 + abs(magnetic_field) * 0.5);
    color += plasma_color * density * plasma_density;
    color += wave_color * waves * 0.3;

    // Add reconnection effects
    vec3 reconnection_color = mix(
        vec3(0.8, 0.4, 0.1),  // Cool plasma
        vec3(1.0, 0.8, 0.4),  // Hot plasma
        reconnection
    );
    color += reconnection_color * reconnection * RECONNECTION_RATE;

    // Add particle acceleration effects
    color += vec3(0.9, 0.8, 0.7) * acceleration * magnetic_strength;

    // Add plasma instabilities
    vec2 instability_uv = uv * 8.0;
    float instability = plasma_noise(instability_uv + plasma_time, 1.0);
    color += vec3(0.5, 0.6, 0.7) * instability * 0.2;

    // Add magnetic field lines
    float field_lines = sin(dot(normalize(field_flow), uv) * 8.0 - plasma_time * 2.0);
    field_lines = field_lines * 0.5 + 0.5;
    color += vec3(0.7, 0.8, 0.9) * field_lines * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
