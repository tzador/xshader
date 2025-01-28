/*
Plasma Physics
Creates a simulation of plasma dynamics with magnetic
reconnection, particle acceleration, and field lines.
*/

vec4 f(){
    vec2 uv = (p - 0.5) * 3.0;
    vec3 color = vec3(0.0);

    // Magnetic field configuration
    vec2 field(vec2 p, float t){
        vec2 field = vec2(0.0);

        // Create X-point configuration
        field.x = p.y;
        field.y = -p.x;

        // Add time-dependent perturbation
        float perturb = sin(t * 0.5);
        field += vec2(
            sin(p.y * 3.0 + t) * perturb,
            cos(p.x * 3.0 + t) * perturb
        ) * 0.3;

        return field;
    }

    // Particle tracer
    vec2 trace_particle(vec2 pos, float dt){
        vec2 velocity = field(pos, t);
        return pos + velocity * dt;
    }

    // Magnetic field visualization
    float field_strength = 0.0;
    vec2 field_lines = vec2(0.0);

    // Calculate field lines
    const int FIELD_STEPS = 10;
    vec2 pos = uv;

    for(int i=0; i<FIELD_STEPS; i++){
        vec2 f = field(pos, t);
        float strength = length(f);

        // Accumulate field strength
        field_strength += strength * exp(-float(i) * 0.2);
        field_lines += normalize(f) * exp(-float(i) * 0.2);

        // Move along field line
        pos = trace_particle(pos, 0.1);
    }

    // Normalize accumulated values
    field_strength *= 0.2;
    field_lines *= 0.2;

    // Create reconnection regions
    float reconnection = 0.0;

    for(int i=0; i<4; i++){
        float angle = float(i) * 1.5708;
        vec2 center = vec2(
            cos(angle + t * 0.2),
            sin(angle + t * 0.3)
        ) * 0.8;

        vec2 rel = uv - center;
        float dist = length(rel);

        // Calculate current sheet
        float sheet = exp(-dist * 8.0) *
                     abs(dot(normalize(rel), field(center, t)));

        reconnection += sheet;
    }

    // Particle acceleration
    float particles = 0.0;

    for(int i=0; i<6; i++){
        float phase = float(i) * 1.0472 + t;
        vec2 particle_pos = vec2(
            cos(phase),
            sin(phase)
        ) * 0.5;

        // Trace particle path
        for(int j=0; j<8; j++){
            float time = float(j) * 0.1;
            vec2 pos = trace_particle(particle_pos, time);

            particles += exp(-length(uv - pos) * 16.0) *
                        exp(-time * 2.0);
        }
    }

    // Combine visual elements
    vec3 field_color = mix(
        vec3(0.1, 0.2, 0.8),  // Weak field
        vec3(0.5, 0.7, 1.0),  // Strong field
        field_strength
    );

    vec3 reconnection_color = vec3(1.0, 0.3, 0.1);
    vec3 particle_color = vec3(1.0, 0.8, 0.4);

    color = field_color;
    color += reconnection_color * reconnection;
    color += particle_color * particles;

    // Add glow effects
    float glow = exp(-length(uv) * 2.0);
    color += vec3(0.1, 0.2, 0.4) * glow;

    // Tone mapping
    color = pow(color, vec3(0.8));

    return vec4(color, 1.0);
}
