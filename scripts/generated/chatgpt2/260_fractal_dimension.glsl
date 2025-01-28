/*
Fractal Dimension Explorer
Visualizes Mandelbrot/Julia set morphing,
fractal patterns, and dimensional transitions.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Fractal parameters
    float fractal_time = t * 0.5;
    float morph_factor = sin(fractal_time * 0.3) * 0.5 + 0.5;
    float iteration_limit = 100.0;
    float escape_radius = 4.0;

    // Complex number operations
    vec2 cmul(vec2 a, vec2 b) {
        return vec2(
            a.x * b.x - a.y * b.y,
            a.x * b.y + a.y * b.x
        );
    }

    vec2 cdiv(vec2 a, vec2 b) {
        float denom = dot(b, b);
        return vec2(
            (a.x * b.x + a.y * b.y) / denom,
            (a.y * b.x - a.x * b.y) / denom
        );
    }

    float cabs(vec2 z) {
        return length(z);
    }

    // Julia set parameters
    vec2 julia_c = vec2(
        cos(fractal_time * 0.5) * 0.7,
        sin(fractal_time * 0.4) * 0.3
    );

    // Calculate Mandelbrot/Julia hybrid
    vec2 z = uv;
    vec2 c = mix(uv, julia_c, morph_factor);
    float smooth_iter = 0.0;
    float escape_time = 0.0;

    for(float i = 0.0; i < iteration_limit; i++) {
        // Higher-order fractal iteration
        z = cmul(z, z) + c;

        // Add rotational component
        float angle = fractal_time * 0.1;
        vec2 rot = vec2(cos(angle), sin(angle));
        z = cmul(z, rot);

        if(cabs(z) > escape_radius) {
            escape_time = i;
            // Smooth coloring
            smooth_iter = i + 1.0 - log(log(cabs(z))) / log(2.0);
            break;
        }
    }

    // Calculate orbit traps
    float orbit_trap = 1e10;
    vec2 trap_point = vec2(
        cos(fractal_time),
        sin(fractal_time * 1.3)
    );

    z = uv;
    for(float i = 0.0; i < 30.0; i++) {
        z = cmul(z, z) + c;
        orbit_trap = min(orbit_trap, length(z - trap_point));
    }

    // Generate fractal noise
    float noise = 0.0;
    vec2 noise_uv = uv * 2.0;
    for(float i = 0.0; i < 4.0; i++) {
        float scale = pow(2.0, i);
        vec2 pos = noise_uv * scale + vec2(fractal_time * 0.1);

        float nx = fract(sin(dot(pos, vec2(127.1, 311.7))) * 43758.5453);
        float ny = fract(sin(dot(pos, vec2(269.5, 183.3))) * 28001.8384);

        noise += (nx * ny) / scale;
    }

    // Calculate dimensional transitions
    float dimension = 0.0;
    for(float i = 1.0; i < 5.0; i++) {
        float scale = pow(2.0, i);
        vec2 scaled_uv = uv * scale;
        vec2 cell = floor(scaled_uv);
        vec2 fract_uv = fract(scaled_uv);

        float cell_value = fract(sin(dot(cell, vec2(127.1, 311.7))) * 43758.5453);
        dimension += cell_value / scale;
    }

    // Create color gradients based on iteration count
    vec3 base_color = mix(
        vec3(0.2, 0.1, 0.3),  // Deep set
        vec3(0.8, 0.5, 0.2),  // Escape set
        smooth_iter / iteration_limit
    );

    // Add orbit trap coloring
    vec3 orbit_color = mix(
        vec3(0.3, 0.5, 0.7),  // Far from trap
        vec3(0.8, 0.3, 0.5),  // Near trap
        1.0 - smoothstep(0.0, 1.0, orbit_trap)
    );

    // Add dimensional coloring
    vec3 dim_color = mix(
        vec3(0.2, 0.4, 0.6),  // Lower dimension
        vec3(0.7, 0.8, 0.3),  // Higher dimension
        dimension
    );

    // Combine visualization components
    color = base_color;
    color = mix(color, orbit_color, 0.3);
    color = mix(color, dim_color, 0.2);

    // Add fractal boundary effects
    float boundary = exp(-smooth_iter * 0.1);
    color += vec3(0.8, 0.7, 0.5) * boundary * 0.3;

    // Add noise effects
    color += vec3(0.6, 0.7, 0.8) * noise * 0.15;

    // Add dimensional transition effects
    float trans = sin(dimension * 6.28319 + fractal_time);
    color += vec3(0.7, 0.6, 0.8) * trans * 0.1;

    // Add escape time effects
    float escape = smoothstep(0.0, iteration_limit, escape_time);
    color = mix(color, vec3(0.9, 0.8, 0.7), escape * 0.2);

    // Add morphing effects
    vec3 morph_color = mix(
        vec3(0.4, 0.6, 0.8),  // Mandelbrot colors
        vec3(0.8, 0.5, 0.3),  // Julia colors
        morph_factor
    );
    color = mix(color, morph_color, 0.2);

    // Add rotational symmetry
    float angle = atan(uv.y, uv.x);
    float symmetry = sin(angle * 6.0 + fractal_time * 2.0);
    color += vec3(0.7, 0.8, 0.9) * symmetry * 0.1;

    // Add fractal flow
    float flow = sin(dot(normalize(z), uv) * 4.0 - fractal_time * 2.0);
    color += vec3(0.6, 0.7, 0.8) * flow * 0.1;

    // Add dimensional boundaries
    vec2 dim_uv = uv * 8.0;
    float dim_boundary = fract(sin(dot(floor(dim_uv), vec2(127.1, 311.7))) * 43758.5453);
    color += vec3(0.5, 0.6, 0.7) * dim_boundary * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
