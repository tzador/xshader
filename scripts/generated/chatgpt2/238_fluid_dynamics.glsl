/*
Fluid Dynamics Simulation
Visualizes turbulent flow patterns, vortex interactions,
and complex fluid dynamics in a 2D system.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Fluid parameters
    float flow_time = t * 1.5;
    float viscosity = 0.8;
    float turbulence = 0.9;

    // Noise function for fluid motion
    float fluid_noise(vec2 p, float freq) {
        vec2 i = floor(p * freq);
        vec2 f = fract(p * freq);

        float a = fract(sin(dot(i, vec2(127.1, 311.7))) * 43758.5453);
        float b = fract(sin(dot(i + vec2(1.0, 0.0), vec2(127.1, 311.7))) * 43758.5453);
        float c = fract(sin(dot(i + vec2(0.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);
        float d = fract(sin(dot(i + vec2(1.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);

        f = f * f * (3.0 - 2.0 * f + sin(flow_time + dot(i, f)) * 0.1);

        return mix(
            mix(a, b, f.x),
            mix(c, d, f.x),
            f.y
        );
    }

    // Generate velocity field
    vec2 velocity = vec2(0.0);
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 offset = vec2(
            cos(flow_time * 0.3 * scale),
            sin(flow_time * 0.4 * scale)
        );

        vec2 pos = uv * scale + offset;
        float noise = fluid_noise(pos, 1.0);

        velocity += vec2(
            cos(noise * 6.283 + flow_time),
            sin(noise * 6.283 + flow_time)
        ) / scale;
    }

    // Generate vorticity field
    float vorticity = 0.0;
    for(int i = 0; i < 6; i++) {
        float angle = float(i) * 1.0472;
        vec2 center = vec2(
            cos(angle + flow_time * 0.5),
            sin(angle + flow_time * 0.7)
        ) * 1.5;

        vec2 rel_pos = uv - center;
        float dist = length(rel_pos);
        float rot = atan(rel_pos.y, rel_pos.x);

        float vortex = exp(-dist * 2.0);
        vortex *= sin(rot * 3.0 + flow_time * 2.0);

        vorticity += vortex;
    }

    // Add turbulent structures
    float turbulent_flow = 0.0;
    for(int i = 0; i < 5; i++) {
        float scale = pow(2.0, float(i));
        vec2 turb_pos = uv * scale + velocity * float(i);

        float turb = fluid_noise(turb_pos, 1.0);
        turb *= exp(-float(i) * 0.5);

        turbulent_flow += turb;
    }

    // Generate pressure field
    float pressure = 0.0;
    vec2 pressure_center = vec2(
        cos(flow_time * 0.3),
        sin(flow_time * 0.4)
    ) * 1.5;

    for(int i = 0; i < 8; i++) {
        float angle = float(i) * 0.785398;
        vec2 offset = vec2(
            cos(angle + flow_time),
            sin(angle + flow_time * 0.8)
        );

        vec2 pos = uv - pressure_center - offset;
        float field = exp(-length(pos) * 3.0);
        field *= sin(length(pos) * 8.0 - flow_time * 2.0);

        pressure += field;
    }

    // Add boundary layer effects
    float boundary = 0.0;
    float wall_dist = abs(uv.y);
    boundary = exp(-wall_dist * 4.0);
    boundary *= sin(uv.x * 16.0 - flow_time * 4.0);

    // Combine flow components
    float flow = length(velocity);
    float vort = vorticity * 0.5 + 0.5;
    float turb = turbulent_flow * 0.5 + 0.5;
    float press = pressure * 0.5 + 0.5;

    // Create color gradients for different flow phenomena
    vec3 velocity_color = mix(
        vec3(0.1, 0.3, 0.5),  // Slow flow
        vec3(0.5, 0.7, 0.9),  // Fast flow
        flow
    );

    vec3 vorticity_color = mix(
        vec3(0.2, 0.5, 0.3),  // Weak rotation
        vec3(0.8, 0.3, 0.2),  // Strong rotation
        vort
    );

    vec3 turbulence_color = mix(
        vec3(0.2, 0.2, 0.4),  // Laminar flow
        vec3(0.8, 0.7, 0.3),  // Turbulent flow
        turb
    );

    // Combine colors with flow properties
    color = velocity_color * (1.0 + flow * 0.5);
    color += vorticity_color * vort * turbulence;
    color += turbulence_color * turb * turbulence;

    // Add pressure visualization
    color = mix(
        color,
        vec3(0.7, 0.8, 0.9),
        press * 0.3
    );

    // Add boundary layer
    color += vec3(0.8, 0.9, 1.0) * boundary * 0.2;

    // Add small-scale structures
    vec2 detail_uv = uv * 32.0;
    float details = fluid_noise(detail_uv + flow_time, 1.0);
    color += vec3(0.5, 0.6, 0.7) * details * 0.05;

    // Add flow streaks
    float streaks = sin(dot(normalize(velocity), uv) * 16.0 - flow_time * 4.0);
    streaks = streaks * 0.5 + 0.5;
    color += vec3(0.7, 0.8, 0.9) * streaks * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.15);

    return vec4(color, 1.0);
}
