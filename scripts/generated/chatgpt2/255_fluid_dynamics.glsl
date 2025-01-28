/*
Fluid Dynamics Simulation
Visualizes fluid flow, vorticity, turbulence patterns,
and pressure-velocity interactions.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Fluid parameters
    float fluid_time = t * 1.5;
    float viscosity = 0.8;
    float pressure = 0.9;

    // System parameters
    const int VORTICES = 6;
    const float REYNOLDS_NUMBER = 2000.0;

    // Fluid noise function
    float fluid_noise(vec2 p, float freq) {
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

    // Generate velocity field
    vec2 velocity = vec2(0.0);
    float vorticity_field = 0.0;

    for(int i = 0; i < VORTICES; i++) {
        float phase = float(i) * 6.28319 / float(VORTICES);
        vec2 vortex_pos = vec2(
            cos(phase + fluid_time * 0.3),
            sin(phase + fluid_time * 0.4)
        ) * 1.5;

        // Calculate vortex contribution
        vec2 rel_pos = uv - vortex_pos;
        float dist = length(rel_pos);
        vec2 tangent = vec2(-rel_pos.y, rel_pos.x) / (dist + 0.1);

        // Vortex strength with time variation
        float strength = sin(phase + fluid_time) * exp(-dist * 1.5);
        velocity += tangent * strength;

        // Calculate vorticity (curl of velocity field)
        vorticity_field += strength / (dist + 0.1);
    }

    // Calculate pressure field
    float pressure_field = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 pressure_pos = uv * scale + velocity * fluid_time;

        pressure_field += fluid_noise(pressure_pos, 1.0) / scale;
    }

    // Generate turbulent structures
    float turbulence = 0.0;
    for(int i = 0; i < 5; i++) {
        float scale = pow(2.0, float(i));
        vec2 turb_pos = uv * scale + vec2(
            cos(fluid_time * 0.2 * scale),
            sin(fluid_time * 0.3 * scale)
        );

        float turb = fluid_noise(turb_pos, 2.0);
        turbulence += turb / scale;
    }

    // Calculate boundary layer effects
    float boundary = 0.0;
    vec2 boundary_center = vec2(
        cos(fluid_time * 0.5),
        sin(fluid_time * 0.7)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 boundary_dir = vec2(cos(angle), sin(angle));

        float layer = exp(-abs(dot(uv - boundary_center, boundary_dir)) * 8.0);
        layer *= sin(dot(uv - boundary_center, boundary_dir) * 16.0 - fluid_time * 4.0);

        boundary += layer;
    }

    // Generate small-scale structures
    float small_scale = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(4.0, float(i));
        vec2 small_pos = uv * scale + velocity * fluid_time * 0.5;

        small_scale += fluid_noise(small_pos, 2.0) / scale;
    }

    // Calculate strain rate tensor
    float strain = 0.0;
    for(int i = 0; i < VORTICES; i++) {
        float phase = float(i) * 6.28319 / float(VORTICES);
        vec2 strain_pos = vec2(cos(phase), sin(phase)) * 1.5;

        vec2 rel_pos = uv - strain_pos;
        float dist = length(rel_pos);

        strain += exp(-dist * 4.0) * sin(dist * 8.0 - fluid_time * 2.0);
    }

    // Create color gradients
    vec3 velocity_color = mix(
        vec3(0.2, 0.4, 0.8),  // Low velocity
        vec3(0.8, 0.3, 0.2),  // High velocity
        length(velocity) * 0.5
    );

    vec3 vorticity_color = mix(
        vec3(0.3, 0.7, 0.2),  // Clockwise rotation
        vec3(0.9, 0.8, 0.3),  // Counter-clockwise rotation
        vorticity_field * 0.5 + 0.5
    );

    vec3 pressure_color = mix(
        vec3(0.2, 0.3, 0.5),  // Low pressure
        vec3(0.7, 0.5, 0.8),  // High pressure
        pressure_field * 0.5 + 0.5
    );

    // Combine visualization components
    color = velocity_color * (1.0 + length(velocity) * 0.5);
    color += vorticity_color * abs(vorticity_field) * viscosity;
    color += pressure_color * pressure_field * pressure;

    // Add turbulence effects
    vec3 turbulence_color = mix(
        vec3(0.4, 0.6, 0.8),  // Laminar flow
        vec3(0.8, 0.7, 0.3),  // Turbulent flow
        turbulence
    );
    color += turbulence_color * turbulence * (1.0 - viscosity);

    // Add boundary layer visualization
    color = mix(
        color,
        vec3(0.9, 0.8, 0.7),
        boundary * 0.3
    );

    // Add small-scale structure effects
    color += vec3(0.7, 0.8, 0.9) * small_scale * 0.2;

    // Add strain rate visualization
    color = mix(
        color,
        vec3(0.8, 0.6, 0.4),
        abs(strain) * 0.2
    );

    // Add streamlines
    float streamlines = sin(dot(normalize(velocity), uv) * 8.0 - fluid_time * 2.0);
    streamlines = streamlines * 0.5 + 0.5;
    color += vec3(0.6, 0.7, 0.8) * streamlines * 0.1;

    // Add Reynolds number dependent effects
    float reynolds_effect = exp(-length(uv) * 2.0) * sin(length(uv) * REYNOLDS_NUMBER * 0.001 - fluid_time);
    color = mix(
        color,
        vec3(0.7, 0.8, 0.9),
        reynolds_effect * 0.1
    );

    // Add cavitation bubbles
    vec2 bubble_uv = uv * 16.0;
    float bubbles = fluid_noise(bubble_uv + fluid_time, 1.0);
    bubbles *= step(0.7, bubbles); // Threshold for bubble formation
    color += vec3(0.9, 0.9, 1.0) * bubbles * 0.2;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
