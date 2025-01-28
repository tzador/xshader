/*
Chemical Reaction Diffusion
Visualizes Turing patterns, morphogenesis, and complex
chemical reaction dynamics with multiple species.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Reaction parameters
    float reaction_time = t * 1.5;
    float diffusion_rate = 0.8;
    float reaction_rate = 0.9;

    // Species parameters
    const int SPECIES = 3;
    const float INTERACTION_STRENGTH = 0.7;

    // Chemical noise function
    float chemical_noise(vec2 p, float freq) {
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

    // Generate chemical species concentrations
    float[SPECIES] concentrations;
    float total_concentration = 0.0;

    for(int i = 0; i < SPECIES; i++) {
        float phase = float(i) * 2.0944 + reaction_time * 0.2;
        vec2 species_center = vec2(
            cos(phase),
            sin(phase)
        ) * 1.5;

        // Calculate base concentration
        float base_conc = exp(-length(uv - species_center) * 2.0);

        // Add diffusion effects
        float diffusion = 0.0;
        for(int j = 0; j < 4; j++) {
            float scale = pow(2.0, float(j));
            vec2 diff_pos = uv * scale + vec2(
                cos(reaction_time * 0.3 * scale),
                sin(reaction_time * 0.4 * scale)
            );

            diffusion += chemical_noise(diff_pos, 1.0) / scale;
        }

        concentrations[i] = base_conc + diffusion * diffusion_rate;
        total_concentration += concentrations[i];
    }

    // Calculate reaction dynamics
    float reaction = 0.0;
    for(int i = 0; i < SPECIES; i++) {
        for(int j = 0; j < SPECIES; j++) {
            if(i != j) {
                // Reaction rate depends on both species
                float rate = concentrations[i] * concentrations[j];
                rate *= reaction_rate;

                // Add oscillatory behavior
                rate *= sin(reaction_time * (1.0 + float(i + j) * 0.1));

                reaction += rate;
            }
        }
    }

    // Generate Turing patterns
    float turing = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 turing_pos = uv * scale;

        // Activator-inhibitor dynamics
        float activator = chemical_noise(turing_pos + reaction_time * vec2(0.1), 2.0);
        float inhibitor = chemical_noise(turing_pos - reaction_time * vec2(0.1), 2.0);

        float pattern = activator * (1.0 - inhibitor);
        turing += pattern / scale;
    }

    // Create morphogen gradients
    float morphogen = 0.0;
    vec2 morph_center = vec2(
        cos(reaction_time * 0.3),
        sin(reaction_time * 0.4)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 offset = vec2(cos(angle), sin(angle));

        float gradient = exp(-length(uv - morph_center - offset) * 2.0);
        gradient *= sin(length(uv - morph_center) * 4.0 - reaction_time);

        morphogen += gradient;
    }

    // Create color gradients for different species
    vec3[SPECIES] species_colors = vec3[](
        vec3(0.8, 0.2, 0.2),  // Species 1 (red)
        vec3(0.2, 0.8, 0.2),  // Species 2 (green)
        vec3(0.2, 0.2, 0.8)   // Species 3 (blue)
    );

    // Combine species colors based on concentrations
    for(int i = 0; i < SPECIES; i++) {
        float normalized_conc = concentrations[i] / total_concentration;
        color += species_colors[i] * normalized_conc;
    }

    // Add reaction visualization
    vec3 reaction_color = mix(
        vec3(0.2, 0.3, 0.4),  // Low reaction rate
        vec3(0.8, 0.7, 0.2),  // High reaction rate
        reaction
    );
    color += reaction_color * reaction * INTERACTION_STRENGTH;

    // Add Turing pattern effects
    vec3 turing_color = mix(
        vec3(0.3, 0.5, 0.7),  // Pattern valleys
        vec3(0.7, 0.8, 0.9),  // Pattern peaks
        turing
    );
    color += turing_color * turing * 0.3;

    // Add morphogen effects
    color = mix(
        color,
        vec3(0.9, 0.8, 0.7),
        morphogen * 0.2
    );

    // Add diffusion boundaries
    float boundary = exp(-length(uv) * 2.0);
    color += vec3(0.8, 0.9, 1.0) * boundary * 0.2;

    // Add reaction-diffusion waves
    vec2 wave_uv = uv * 8.0;
    float waves = sin(wave_uv.x + reaction_time) * sin(wave_uv.y + reaction_time * 1.2);
    color += vec3(0.5, 0.6, 0.7) * waves * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
