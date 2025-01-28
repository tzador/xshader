/*
Plasma Physics
Visualizes magnetohydrodynamics, plasma waves,
and electromagnetic interactions in plasma.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Plasma parameters
    float plasma_time = t * 1.2;
    float magnetic_strength = 0.8;
    float plasma_density = 0.7;

    // Physical constants
    const float ALFVEN_SPEED = 0.5;
    const float PLASMA_BETA = 0.1;
    const int WAVE_MODES = 6;

    // Plasma noise function
    float plasma_noise(vec2 p, float freq) {
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

    // Calculate magnetic field
    vec2 B_field = vec2(0.0);
    for(int i = 0; i < WAVE_MODES; i++) {
        float angle = float(i) * 6.28319 / float(WAVE_MODES);
        vec2 dir = vec2(cos(angle), sin(angle));

        float wave = sin(dot(uv, dir) * 4.0 - plasma_time * ALFVEN_SPEED);
        B_field += dir * wave * magnetic_strength;
    }

    // Calculate plasma density fluctuations
    float density = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 pos = uv * scale + B_field * plasma_time;

        float fluctuation = plasma_noise(pos, 2.0);
        fluctuation = pow(fluctuation, 1.5);

        density += fluctuation / scale;
    }
    density *= plasma_density;

    // Generate magnetosonic waves
    float fast_mode = 0.0;
    float slow_mode = 0.0;

    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 wave_pos = uv * scale;

        // Fast magnetosonic waves
        float fast_wave = sin(length(wave_pos) * 6.0 - plasma_time * 2.0);
        fast_mode += fast_wave / scale;

        // Slow magnetosonic waves
        float slow_wave = sin(length(wave_pos) * 3.0 - plasma_time);
        slow_mode += slow_wave / scale;
    }

    // Calculate current density
    vec2 J_field = vec2(0.0);
    float current = 0.0;

    for(int i = 0; i < 4; i++) {
        float angle = float(i) * 1.5708;
        vec2 dir = vec2(cos(angle), sin(angle));

        float j = exp(-abs(dot(uv, dir)) * 3.0);
        j *= sin(dot(uv, dir) * 8.0 - plasma_time * 1.5);

        J_field += dir * j;
        current += j;
    }

    // Generate plasma instabilities
    float instability = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 inst_pos = uv * scale + J_field * plasma_time;

        float inst = plasma_noise(inst_pos, 4.0);
        instability += inst / scale;
    }

    // Calculate electromagnetic interactions
    float em_interaction = 0.0;
    vec2 em_flow = vec2(0.0);

    for(int i = 0; i < WAVE_MODES; i++) {
        float angle = float(i) * 6.28319 / float(WAVE_MODES);
        vec2 dir = vec2(cos(angle), sin(angle));

        float force = dot(B_field, dir) * dot(J_field, dir);
        em_interaction += force;
        em_flow += dir * force;
    }

    // Create color gradients
    vec3 magnetic_color = mix(
        vec3(0.2, 0.4, 0.8),  // Weak field
        vec3(0.8, 0.3, 0.2),  // Strong field
        length(B_field) * 0.5
    );

    vec3 density_color = mix(
        vec3(0.3, 0.6, 0.2),  // Low density
        vec3(0.7, 0.8, 0.3),  // High density
        density
    );

    vec3 current_color = mix(
        vec3(0.2, 0.3, 0.7),  // Low current
        vec3(0.8, 0.5, 0.3),  // High current
        current * 0.5 + 0.5
    );

    // Combine visualization components
    color = magnetic_color;
    color = mix(color, density_color, 0.4);
    color = mix(color, current_color, 0.3);

    // Add wave effects
    color += vec3(0.6, 0.7, 0.8) * fast_mode * 0.2;
    color += vec3(0.7, 0.6, 0.5) * slow_mode * 0.15;

    // Add plasma flow
    float flow = sin(dot(normalize(em_flow), uv) * 6.0 - plasma_time * 2.0);
    flow = flow * 0.5 + 0.5;
    color += vec3(0.7, 0.8, 0.9) * flow * 0.15;

    // Add instability effects
    color += vec3(0.8, 0.7, 0.5) * instability * 0.2;

    // Add electromagnetic interactions
    color += vec3(0.6, 0.7, 0.8) * em_interaction * 0.15;

    // Add plasma oscillations
    vec2 osc_uv = uv * 12.0;
    float oscillation = plasma_noise(osc_uv + plasma_time, 1.0);
    color += vec3(0.5, 0.6, 0.7) * oscillation * 0.1;

    // Add magnetic reconnection
    float reconnection = atan(uv.y, uv.x) + plasma_time;
    color += vec3(0.6, 0.5, 0.8) * (sin(reconnection * 3.0) * 0.5 + 0.5) * 0.1;

    // Add plasma sheath
    float sheath = length(uv);
    sheath = sin(sheath * 8.0 - plasma_time * 1.5);
    color += vec3(0.7, 0.6, 0.5) * sheath * 0.1;

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
