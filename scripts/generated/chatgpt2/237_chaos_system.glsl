/*
Chaotic Attractor System
Visualizes multiple interacting chaotic attractors,
phase space trajectories, and dynamic bifurcations.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 6.0;
    vec3 color = vec3(0.0);

    // System parameters
    float chaos_time = t * 2.0;
    float bifurcation_param = sin(chaos_time * 0.2) * 0.5 + 0.5;
    float system_energy = 0.9;

    // Lorenz attractor parameters
    float sigma = 10.0;
    float rho = 28.0;
    float beta = 8.0 / 3.0;

    // Complex mapping function
    vec2 complex_map(vec2 z, float param) {
        float x = z.x;
        float y = z.y;

        // Polynomial mapping with parameter dependence
        return vec2(
            x*x - y*y + param * cos(chaos_time),
            2.0*x*y + param * sin(chaos_time)
        );
    }

    // Generate multiple attractors
    float attractors = 0.0;
    for(int i = 0; i < 8; i++) {
        float angle = float(i) * 0.785398;
        vec2 center = vec2(
            cos(angle + chaos_time * 0.3),
            sin(angle + chaos_time * 0.4)
        ) * 2.0;

        vec2 z = uv - center;
        float intensity = 0.0;

        // Iterate the map
        for(int j = 0; j < 8; j++) {
            z = complex_map(z, bifurcation_param);
            intensity += exp(-length(z) * 0.5);
        }

        attractors += intensity;
    }

    // Phase space trajectories
    float trajectories = 0.0;
    for(int i = 0; i < 6; i++) {
        float t_offset = chaos_time + float(i) * 1.0472;
        vec2 pos = vec2(
            sin(t_offset) * cos(t_offset * 0.7),
            cos(t_offset) * sin(t_offset * 0.5)
        ) * 2.0;

        vec2 velocity = vec2(
            cos(t_offset * 1.2),
            sin(t_offset * 0.9)
        );

        float trajectory = exp(-length(uv - pos) * 4.0);
        trajectory *= sin(dot(normalize(uv - pos), velocity) * 8.0 + chaos_time * 4.0);

        trajectories += trajectory;
    }

    // Lorenz attractor projection
    float lorenz = 0.0;
    vec2 lorenz_center = vec2(0.0);
    for(int i = 0; i < 12; i++) {
        float dt = 0.01;
        float x = cos(chaos_time + float(i) * 0.5);
        float y = sin(chaos_time + float(i) * 0.7);
        float z = cos(chaos_time + float(i) * 0.3);

        // Lorenz system equations
        float dx = sigma * (y - x);
        float dy = x * (rho - z) - y;
        float dz = x * y - beta * z;

        x += dx * dt;
        y += dy * dt;
        z += dz * dt;

        vec2 proj_pos = vec2(x, y) * 0.2;
        lorenz += exp(-length(uv - proj_pos - lorenz_center) * 8.0);
    }

    // Bifurcation diagram
    float bifurcation = 0.0;
    for(int i = 0; i < 10; i++) {
        float x = float(i) * 0.1;
        float r = 3.7 + 0.3 * sin(chaos_time * 0.1);

        // Logistic map iteration
        for(int j = 0; j < 50; j++) {
            x = r * x * (1.0 - x);
        }

        vec2 bif_pos = vec2(r - 3.7, x) * 2.0;
        bifurcation += exp(-length(uv - bif_pos) * 16.0);
    }

    // Combine dynamic components
    float chaos = attractors * 0.5 + 0.5;
    float phase_space = trajectories * 0.5 + 0.5;
    float strange_attractor = lorenz * 0.5 + 0.5;
    float bifurcation_diagram = bifurcation * 0.5 + 0.5;

    // Create color gradients for different dynamic phenomena
    vec3 attractor_color = mix(
        vec3(0.1, 0.4, 0.6),  // Stable regions
        vec3(0.8, 0.3, 0.2),  // Chaotic regions
        chaos
    );

    vec3 trajectory_color = mix(
        vec3(0.2, 0.5, 0.3),  // Regular trajectories
        vec3(0.7, 0.8, 0.2),  // Chaotic trajectories
        phase_space
    );

    vec3 lorenz_color = mix(
        vec3(0.3, 0.2, 0.5),  // Lower attractor
        vec3(0.8, 0.5, 0.7),  // Upper attractor
        strange_attractor
    );

    // Combine colors with dynamic weights
    color = attractor_color * (1.0 + chaos * 0.5);
    color += trajectory_color * phase_space * system_energy;
    color += lorenz_color * strange_attractor * system_energy;

    // Add bifurcation effects
    color += vec3(0.9, 0.8, 0.7) * bifurcation_diagram * 0.3;

    // Add phase space flow
    vec2 flow_uv = uv * 8.0;
    float flow = sin(flow_uv.x + chaos_time) * sin(flow_uv.y + chaos_time * 1.2);
    color += vec3(0.4, 0.6, 0.8) * flow * 0.05;

    // Add dynamic boundaries
    float boundary = exp(-pow(length(uv) - 2.5, 2.0) * 2.0);
    boundary *= sin(length(uv) * 16.0 - chaos_time * 4.0);
    color += vec3(0.7, 0.8, 0.9) * boundary * 0.2;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
