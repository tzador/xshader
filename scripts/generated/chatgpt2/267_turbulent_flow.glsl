/*
Turbulent Flow Dynamics
Visualizes fluid instabilities, vortex shedding,
and turbulent energy cascades.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Flow parameters
    float flow_time = t * 1.2;
    float reynolds_number = 2000.0;
    float viscosity = 0.1;

    // System constants
    const int VORTEX_COUNT = 8;
    const float ENERGY_CASCADE_RATE = 0.7;
    const float KOLMOGOROV_SCALE = 0.05;

    // Turbulent noise function
    float turb_noise(vec2 p, float freq) {
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

    // Generate primary vortices
    float vorticity = 0.0;
    vec2 velocity_field = vec2(0.0);

    for(int i = 0; i < VORTEX_COUNT; i++) {
        float phase = float(i) * 6.28319 / float(VORTEX_COUNT);
        vec2 vortex_pos = vec2(
            cos(phase + flow_time * 0.3),
            sin(phase + flow_time * 0.4)
        ) * 1.5;

        // Calculate vortex contribution
        vec2 rel_pos = uv - vortex_pos;
        float dist = length(rel_pos);

        // Vortex strength with Reynolds number scaling
        float strength = exp(-dist * 2.0) / (1.0 + viscosity * reynolds_number);
        strength *= sin(dist * 8.0 + flow_time * (1.0 + float(i) * 0.1));

        vec2 rot_vel = vec2(-rel_pos.y, rel_pos.x) / (dist + 0.1);
        velocity_field += rot_vel * strength;
        vorticity += strength;
    }

    // Calculate energy cascade
    float energy_spectrum = 0.0;
    for(int i = 0; i < 5; i++) {
        float scale = pow(2.0, float(i));
        vec2 cascade_pos = uv * scale + velocity_field * flow_time;

        float energy = turb_noise(cascade_pos, 2.0);
        energy *= pow(ENERGY_CASCADE_RATE, float(i)); // Kolmogorov scaling

        energy_spectrum += energy;
    }

    // Generate instability patterns
    float instability = 0.0;
    vec2 instability_center = vec2(
        cos(flow_time * 0.5),
        sin(flow_time * 0.7)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 inst_dir = vec2(cos(angle), sin(angle));

        float pattern = exp(-abs(dot(uv - instability_center, inst_dir)) * 4.0);
        pattern *= sin(dot(uv - instability_center, inst_dir) * 12.0 - flow_time * 3.0);

        instability += pattern;
    }

    // Calculate strain rate tensor
    float strain = 0.0;
    for(int i = 0; i < 4; i++) {
        float angle = float(i) * 1.5708;
        vec2 strain_dir = vec2(cos(angle), sin(angle));

        float rate = exp(-abs(dot(uv, strain_dir)) * 3.0);
        rate *= sin(dot(uv, strain_dir) * 8.0 - flow_time * 2.0);

        strain += rate;
    }

    // Generate small-scale structures
    float small_scale = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(4.0, float(i));
        vec2 small_pos = uv * scale + velocity_field * flow_time * 0.5;

        float structure = turb_noise(small_pos, 2.0);
        structure *= exp(-float(i) / KOLMOGOROV_SCALE);

        small_scale += structure;
    }

    // Calculate pressure fluctuations
    float pressure = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 press_pos = uv * scale + velocity_field * flow_time;

        pressure += turb_noise(press_pos, 1.0) / scale;
    }

    // Create color gradients
    vec3 velocity_color = mix(
        vec3(0.2, 0.4, 0.8),  // Low velocity
        vec3(0.8, 0.3, 0.2),  // High velocity
        length(velocity_field) * 0.5
    );

    vec3 vorticity_color = mix(
        vec3(0.3, 0.6, 0.2),  // Weak vorticity
        vec3(0.7, 0.8, 0.3),  // Strong vorticity
        vorticity * 0.5 + 0.5
    );

    vec3 energy_color = mix(
        vec3(0.2, 0.3, 0.5),  // Low energy
        vec3(0.7, 0.5, 0.8),  // High energy
        energy_spectrum
    );

    // Combine visualization components
    color = velocity_color * (1.0 + length(velocity_field) * 0.3);
    color = mix(color, vorticity_color, 0.4);
    color = mix(color, energy_color, 0.3);

    // Add instability effects
    color += vec3(0.8, 0.7, 0.5) * instability * 0.3;

    // Add strain rate visualization
    color += vec3(0.6, 0.7, 0.8) * strain * 0.2;

    // Add small-scale structures
    color += vec3(0.7, 0.8, 0.9) * small_scale * 0.15;

    // Add pressure effects
    color = mix(
        color,
        vec3(0.4, 0.6, 0.8),
        pressure * 0.2
    );

    // Add flow streamlines
    float streamlines = sin(dot(normalize(velocity_field), uv) * 6.0 - flow_time * 2.0);
    streamlines = streamlines * 0.5 + 0.5;
    color += vec3(0.7, 0.8, 0.9) * streamlines * 0.1;

    // Add dissipation scales
    vec2 dissipation_uv = uv * 16.0;
    float dissipation = turb_noise(dissipation_uv + flow_time, 1.0);
    dissipation *= exp(-length(uv) / KOLMOGOROV_SCALE);
    color += vec3(0.5, 0.6, 0.7) * dissipation * 0.1;

    // Add intermittency effects
    float intermittency = atan(uv.y, uv.x) + flow_time;
    color += vec3(0.6, 0.5, 0.8) * (sin(intermittency * 4.0) * 0.5 + 0.5) * 0.1;

    // Add Reynolds number dependent effects
    float reynolds_effect = length(uv);
    reynolds_effect = sin(reynolds_effect * 8.0 - flow_time * 1.5);
    color += vec3(0.7, 0.6, 0.5) * reynolds_effect * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
