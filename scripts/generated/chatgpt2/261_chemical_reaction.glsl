/*
Chemical Reaction Diffusion
Visualizes Turing patterns, chemical reactions,
and complex molecular interactions.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Reaction parameters
    float chem_time = t * 1.0;
    float diffusion_rate = 0.7;
    float reaction_rate = 0.8;

    // System constants
    const float FEED_RATE = 0.055;
    const float KILL_RATE = 0.062;
    const int ITERATIONS = 8;

    // Chemical noise function
    float chem_noise(vec2 p, float freq) {
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

    // Initialize chemical concentrations
    vec2 concentration = vec2(1.0, 0.0);
    vec2 laplacian = vec2(0.0);

    // Calculate Laplacian operator
    for(int i = 0; i < ITERATIONS; i++) {
        float angle = float(i) * 6.28319 / float(ITERATIONS);
        vec2 offset = vec2(cos(angle), sin(angle)) * 0.1;

        vec2 sample_pos = uv + offset;
        float sample = chem_noise(sample_pos + chem_time * 0.1, 4.0);

        laplacian += vec2(sample) - concentration;
    }
    laplacian /= float(ITERATIONS);

    // Calculate reaction-diffusion
    vec2 reaction = vec2(0.0);
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 pos = uv * scale + vec2(chem_time * 0.2);

        // Gray-Scott model
        float a = concentration.x;
        float b = concentration.y;

        float reaction_term = a * b * b;
        reaction.x = FEED_RATE * (1.0 - a) - reaction_term;
        reaction.y = -(FEED_RATE + KILL_RATE) * b + reaction_term;

        // Add diffusion
        reaction += laplacian * diffusion_rate * vec2(1.0, 0.5);

        concentration += reaction * reaction_rate / scale;
    }

    // Generate Turing patterns
    float turing = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 turing_pos = uv * scale + concentration * 0.5;

        float pattern = chem_noise(turing_pos, 2.0);
        pattern = pow(pattern, 1.5);

        turing += pattern / scale;
    }

    // Calculate molecular interactions
    float interaction = 0.0;
    vec2 flow = vec2(0.0);

    for(int i = 0; i < 4; i++) {
        float angle = float(i) * 1.5708;
        vec2 dir = vec2(cos(angle), sin(angle));

        float force = exp(-abs(dot(uv, dir)) * 3.0);
        force *= sin(dot(uv, dir) * 8.0 - chem_time * 2.0);

        interaction += force;
        flow += dir * force;
    }

    // Generate reaction waves
    float waves = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 wave_pos = uv * scale + flow * chem_time;

        float wave = sin(length(wave_pos) * 4.0 - chem_time * 2.0);
        waves += wave / scale;
    }

    // Create color gradients
    vec3 reaction_color = mix(
        vec3(0.2, 0.4, 0.8),  // Reactant A
        vec3(0.8, 0.3, 0.2),  // Reactant B
        concentration.x
    );

    vec3 turing_color = mix(
        vec3(0.3, 0.6, 0.2),  // Pattern valleys
        vec3(0.7, 0.8, 0.3),  // Pattern peaks
        turing
    );

    vec3 interaction_color = mix(
        vec3(0.2, 0.3, 0.7),  // Low interaction
        vec3(0.8, 0.5, 0.3),  // High interaction
        interaction * 0.5 + 0.5
    );

    // Combine visualization components
    color = reaction_color;
    color = mix(color, turing_color, 0.4);
    color = mix(color, interaction_color, 0.3);

    // Add wave effects
    color += vec3(0.6, 0.7, 0.8) * waves * 0.2;

    // Add molecular flow
    float flow_pattern = sin(dot(normalize(flow), uv) * 6.0 - chem_time * 2.0);
    flow_pattern = flow_pattern * 0.5 + 0.5;
    color += vec3(0.7, 0.8, 0.9) * flow_pattern * 0.15;

    // Add reaction boundaries
    float boundary = length(gradient(concentration.x));
    color += vec3(0.8, 0.7, 0.5) * boundary * 0.3;

    // Add diffusion effects
    vec2 diff_uv = uv * 12.0;
    float diff_pattern = chem_noise(diff_uv + chem_time, 1.0);
    color += vec3(0.5, 0.6, 0.7) * diff_pattern * 0.1;

    // Add catalyst effects
    float catalyst = atan(uv.y, uv.x) + chem_time;
    color += vec3(0.6, 0.5, 0.8) * (sin(catalyst * 3.0) * 0.5 + 0.5) * 0.1;

    // Add reaction zones
    float zones = length(uv);
    zones = sin(zones * 8.0 - chem_time * 1.5);
    color += vec3(0.7, 0.6, 0.5) * zones * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
