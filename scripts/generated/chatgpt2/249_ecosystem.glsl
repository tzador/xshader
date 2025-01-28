/*
Ecosystem Evolution
Visualizes predator-prey dynamics, species migration,
resource competition, and population density fluctuations.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Ecosystem parameters
    float eco_time = t * 1.5;
    float growth_rate = 0.8;
    float competition = 0.7;

    // Species parameters
    const int SPECIES = 4;
    const float INTERACTION_STRENGTH = 0.6;

    // Ecosystem noise function
    float eco_noise(vec2 p, float freq) {
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

    // Generate species populations
    float[SPECIES] populations;
    vec2[SPECIES] migration_flows;

    for(int i = 0; i < SPECIES; i++) {
        float phase = float(i) * 6.28319 / float(SPECIES);
        vec2 species_center = vec2(
            cos(phase + eco_time * 0.2),
            sin(phase + eco_time * 0.3)
        ) * 1.5;

        // Calculate population density
        vec2 rel_pos = uv - species_center;
        float dist = length(rel_pos);

        // Population growth and diffusion
        float population = exp(-dist * 2.0);
        population *= 1.0 + 0.3 * sin(eco_time * (1.0 + float(i) * 0.1));

        // Add environmental variation
        for(int j = 0; j < 3; j++) {
            float scale = pow(2.0, float(j));
            vec2 env_pos = uv * scale + species_center;

            population += eco_noise(env_pos, 1.0) / scale;
        }

        populations[i] = population;
        migration_flows[i] = normalize(rel_pos) * population;
    }

    // Calculate species interactions
    float interaction = 0.0;
    for(int i = 0; i < SPECIES; i++) {
        for(int j = 0; j < SPECIES; j++) {
            if(i != j) {
                // Predator-prey or competition interaction
                float interaction_strength = (i + 1) % SPECIES == j ? 1.0 : -competition;

                interaction += populations[i] * populations[j] * interaction_strength;
            }
        }
    }

    // Generate migration patterns
    float migration = 0.0;
    vec2 total_flow = vec2(0.0);

    for(int i = 0; i < SPECIES; i++) {
        // Calculate migration flow
        vec2 flow = migration_flows[i];
        total_flow += flow;

        // Create migration trails
        float trail = exp(-abs(dot(uv - flow, vec2(flow.y, -flow.x))) * 4.0);
        trail *= smoothstep(0.0, 1.0, populations[i]);

        migration += trail;
    }

    // Create resource distribution
    float resources = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 resource_pos = uv * scale + vec2(
            cos(eco_time * 0.3 * scale),
            sin(eco_time * 0.4 * scale)
        );

        resources += eco_noise(resource_pos, 1.0) / scale;
    }

    // Calculate population fluctuations
    float fluctuation = 0.0;
    vec2 fluct_center = vec2(
        cos(eco_time * 0.5),
        sin(eco_time * 0.7)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 offset = vec2(cos(angle), sin(angle));

        float pattern = exp(-length(uv - fluct_center - offset) * 2.0);
        pattern *= sin(length(uv - fluct_center) * 8.0 - eco_time * 2.0);

        fluctuation += pattern;
    }

    // Create color gradients for different species
    vec3[SPECIES] species_colors = vec3[](
        vec3(0.8, 0.3, 0.2),  // Predator 1
        vec3(0.2, 0.7, 0.3),  // Prey 1
        vec3(0.3, 0.2, 0.8),  // Predator 2
        vec3(0.7, 0.8, 0.2)   // Prey 2
    );

    // Combine species populations
    for(int i = 0; i < SPECIES; i++) {
        color += species_colors[i] * populations[i] * growth_rate;
    }

    // Add interaction effects
    vec3 interaction_color = mix(
        vec3(0.2, 0.4, 0.6),  // Competitive interaction
        vec3(0.8, 0.6, 0.2),  // Predatory interaction
        interaction * 0.5 + 0.5
    );
    color += interaction_color * abs(interaction) * INTERACTION_STRENGTH;

    // Add migration visualization
    vec3 migration_color = mix(
        vec3(0.3, 0.5, 0.7),  // Low migration
        vec3(0.7, 0.8, 0.9),  // High migration
        migration
    );
    color += migration_color * migration * 0.3;

    // Add resource distribution
    color = mix(
        color,
        vec3(0.4, 0.8, 0.3),  // Resource-rich areas
        resources * 0.2
    );

    // Add population fluctuation effects
    color += vec3(0.8, 0.9, 1.0) * fluctuation * 0.2;

    // Add ecosystem boundaries
    float boundary = exp(-length(uv) * 0.5);
    color = mix(color, vec3(0.2, 0.3, 0.4), 1.0 - boundary);

    // Add flow visualization
    float flow_lines = sin(dot(normalize(total_flow), uv) * 8.0 - eco_time * 2.0);
    flow_lines = flow_lines * 0.5 + 0.5;
    color += vec3(0.7, 0.8, 0.9) * flow_lines * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
