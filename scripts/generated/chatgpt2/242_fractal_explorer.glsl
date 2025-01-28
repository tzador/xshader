/*
Fractal Dimension Explorer
Visualizes interactive fractal systems with morphing between
Mandelbrot and Julia sets, showing fractal dimension transitions.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Fractal parameters
    float fractal_time = t * 0.5;
    float morph_factor = sin(fractal_time * 0.2) * 0.5 + 0.5;
    float zoom = 2.0 + sin(fractal_time * 0.1) * 0.5;

    // Julia set parameters
    vec2 julia_c = vec2(
        0.7885 * cos(fractal_time * 0.3),
        0.7885 * sin(fractal_time * 0.4)
    );

    // Complex number operations
    vec2 cmul(vec2 a, vec2 b) {
        return vec2(
            a.x * b.x - a.y * b.y,
            a.x * b.y + a.y * b.x
        );
    }

    float cmod2(vec2 z) {
        return dot(z, z);
    }

    // Fractal iteration function
    vec2 iterate(vec2 z, vec2 c) {
        return cmul(z, z) + c;
    }

    // Calculate escape time and orbit trap
    float escape_time(vec2 c) {
        vec2 z = vec2(0.0);
        float trap = 1e10;
        float n = 0.0;

        for(int i = 0; i < 128; i++) {
            z = iterate(z, c);
            trap = min(trap, cmod2(z));

            if(cmod2(z) > 256.0) {
                n = float(i) - log2(log2(cmod2(z)));
                break;
            }
        }

        return n / 128.0;
    }

    // Calculate local fractal dimension
    float fractal_dimension(vec2 pos, float epsilon) {
        float count = 0.0;
        float size = epsilon * 2.0;

        for(int i = -1; i <= 1; i++) {
            for(int j = -1; j <= 1; j++) {
                vec2 offset = vec2(float(i), float(j)) * epsilon;
                vec2 sample_pos = pos + offset;

                float escape = escape_time(sample_pos);
                count += step(0.5, escape);
            }
        }

        return log(count) / log(1.0 / size);
    }

    // Generate multiple fractal layers
    float fractal = 0.0;
    float dimension = 0.0;

    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 scaled_uv = uv * zoom / scale;

        // Morph between Mandelbrot and Julia sets
        vec2 c = mix(scaled_uv, julia_c, morph_factor);
        float escape = escape_time(mix(c, scaled_uv, morph_factor));

        // Calculate local dimension
        float local_dim = fractal_dimension(c, 0.01 / scale);

        fractal += escape / scale;
        dimension += local_dim / scale;
    }

    // Generate orbit traps
    float traps = 0.0;
    vec2 trap_center = vec2(
        cos(fractal_time * 0.5),
        sin(fractal_time * 0.7)
    );

    for(int i = 0; i < 4; i++) {
        float angle = float(i) * 1.5708;
        vec2 offset = vec2(cos(angle), sin(angle)) * 0.5;
        vec2 trap_pos = trap_center + offset;

        float trap_dist = length(uv - trap_pos);
        traps += exp(-trap_dist * 8.0);
    }

    // Create interference patterns
    float interference = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 pos = uv * scale + vec2(
            cos(fractal_time * 0.3 * scale),
            sin(fractal_time * 0.4 * scale)
        );

        float pattern = sin(pos.x * 8.0 + fractal_time) *
            sin(pos.y * 8.0 + fractal_time * 1.2);
        interference += pattern / scale;
    }

    // Create color gradients
    vec3 fractal_color = mix(
        vec3(0.1, 0.2, 0.4),  // Inside set
        vec3(0.8, 0.7, 0.2),  // Outside set
        fractal
    );

    vec3 dimension_color = mix(
        vec3(0.2, 0.5, 0.3),  // Low dimension
        vec3(0.8, 0.3, 0.5),  // High dimension
        dimension
    );

    vec3 trap_color = mix(
        vec3(0.3, 0.4, 0.6),  // Far from traps
        vec3(0.9, 0.8, 0.4),  // Near traps
        traps
    );

    // Combine visualization components
    color = fractal_color * (1.0 + fractal * 0.5);
    color += dimension_color * dimension * 0.5;
    color += trap_color * traps * 0.3;

    // Add interference effects
    color += vec3(0.6, 0.7, 0.8) * interference * 0.2;

    // Add boundary highlighting
    float boundary = exp(-abs(fractal - 0.5) * 8.0);
    color += vec3(1.0) * boundary * 0.5;

    // Add glow effects
    float glow = exp(-length(uv) * 2.0) * fractal;
    color += vec3(0.8, 0.9, 1.0) * glow * 0.3;

    // Add detail enhancement
    vec2 detail_uv = uv * 32.0;
    float details = sin(detail_uv.x + fractal_time) *
        sin(detail_uv.y + fractal_time * 1.2);
    color += vec3(0.2) * details * 0.05;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
