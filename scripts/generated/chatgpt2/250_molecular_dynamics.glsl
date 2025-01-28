/*
Molecular Dynamics Simulation
Visualizes molecular interactions, bond formation,
thermal motion, and conformational changes.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Molecular parameters
    float mol_time = t * 1.5;
    float temperature = 0.8;
    float bond_strength = 0.9;

    // System parameters
    const int MOLECULES = 8;
    const float INTERACTION_RADIUS = 0.4;

    // Molecular noise function
    float mol_noise(vec2 p, float freq) {
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

    // Generate molecular positions and velocities
    vec2[MOLECULES] positions;
    vec2[MOLECULES] velocities;
    float[MOLECULES] energies;

    for(int i = 0; i < MOLECULES; i++) {
        float phase = float(i) * 6.28319 / float(MOLECULES);

        // Position with thermal motion
        positions[i] = vec2(
            cos(phase + mol_time * 0.3) + 0.2 * sin(mol_time * (1.1 + float(i))),
            sin(phase + mol_time * 0.4) + 0.2 * cos(mol_time * (0.9 + float(i)))
        ) * 1.5;

        // Velocity based on temperature
        velocities[i] = vec2(
            cos(mol_time * (0.7 + float(i))),
            sin(mol_time * (0.8 + float(i)))
        ) * temperature;

        // Energy levels
        energies[i] = 0.5 + 0.5 * sin(mol_time * (0.5 + float(i) * 0.1));
    }

    // Calculate molecular interactions
    float interaction = 0.0;
    float bonding = 0.0;

    for(int i = 0; i < MOLECULES; i++) {
        for(int j = i + 1; j < MOLECULES; j++) {
            vec2 rel_pos = positions[j] - positions[i];
            float dist = length(rel_pos);

            // Lennard-Jones potential
            float r6 = pow(INTERACTION_RADIUS / dist, 6.0);
            float potential = r6 * (r6 - 1.0);

            // Bond formation
            float bond = exp(-pow(dist - INTERACTION_RADIUS, 2.0) * 8.0);
            bond *= bond_strength * (energies[i] + energies[j]) * 0.5;

            interaction += potential;
            bonding += bond;
        }
    }

    // Generate electron density
    float electron_density = 0.0;
    for(int i = 0; i < MOLECULES; i++) {
        vec2 rel_pos = uv - positions[i];
        float dist = length(rel_pos);

        // Electron cloud
        float density = exp(-dist * 4.0) * energies[i];
        electron_density += density;
    }

    // Create conformational changes
    float conformation = 0.0;
    vec2 conf_center = vec2(
        cos(mol_time * 0.5),
        sin(mol_time * 0.7)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 offset = vec2(cos(angle), sin(angle));

        float conf = exp(-length(uv - conf_center - offset) * 2.0);
        conf *= sin(length(uv - conf_center) * 8.0 - mol_time * 2.0);

        conformation += conf;
    }

    // Generate thermal fluctuations
    float thermal = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 thermal_pos = uv * scale + vec2(
            cos(mol_time * 0.3 * scale),
            sin(mol_time * 0.4 * scale)
        );

        thermal += mol_noise(thermal_pos, 1.0) / scale;
    }

    // Create color gradients
    vec3 molecule_color = mix(
        vec3(0.2, 0.4, 0.8),  // Low energy state
        vec3(0.8, 0.3, 0.2),  // High energy state
        electron_density
    );

    vec3 bond_color = mix(
        vec3(0.3, 0.7, 0.2),  // Weak bonds
        vec3(0.9, 0.8, 0.3),  // Strong bonds
        bonding
    );

    vec3 thermal_color = mix(
        vec3(0.2, 0.3, 0.5),  // Low temperature
        vec3(0.7, 0.5, 0.8),  // High temperature
        thermal * temperature
    );

    // Combine visualization components
    color = molecule_color * (1.0 + electron_density * 0.5);
    color += bond_color * bonding * bond_strength;
    color += thermal_color * thermal * 0.3;

    // Add interaction effects
    color = mix(
        color,
        vec3(0.4, 0.6, 0.8),
        abs(interaction) * 0.2
    );

    // Add conformational change effects
    color += vec3(0.8, 0.9, 1.0) * conformation * 0.2;

    // Add molecular orbitals
    float orbitals = 0.0;
    for(int i = 0; i < MOLECULES; i++) {
        vec2 rel_pos = uv - positions[i];
        float dist = length(rel_pos);
        float angle = atan(rel_pos.y, rel_pos.x);

        float orbital = sin(dist * 8.0 - mol_time) * sin(angle * 4.0);
        orbitals += orbital * energies[i];
    }
    color += vec3(0.5, 0.6, 0.7) * orbitals * 0.2;

    // Add quantum effects
    vec2 quantum_uv = uv * 16.0;
    float quantum = mol_noise(quantum_uv + mol_time, 1.0);
    color += vec3(0.3, 0.4, 0.5) * quantum * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
