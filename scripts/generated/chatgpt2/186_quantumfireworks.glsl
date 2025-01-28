/*
Quantum Fireworks
Advanced visualization demonstrating:
- Quantum particle explosions
- Wave function collapse
- Probability field bursts
- Interference patterns
- Quantum tunneling trails

Physical concepts:
- Wave-particle duality
- Quantum superposition
- Coherent states
- Quantum interference
- Particle decay
*/

vec4 f() {
    // Initialize quantum coordinates
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Explosion parameters
  float burst_time = mod(t * 2.0, 8.0);  // Cycle every 4 seconds
  float decay = exp(-burst_time * 0.3);

    // Primary explosion waves
  float explosion = 0.0;
  for(int i = 0; i < 8; i++) {
        // Create quantum bursts
    float phase = float(i) * 0.785398163397;
    float radius = burst_time * (1.0 + 0.2 * sin(phase));
    vec2 center = vec2(cos(phase) * radius * 0.3, sin(phase) * radius * 0.3);

        // Calculate wave function
    float d = length(uv - center);
    float wave = exp(-pow(d - radius, 2.0) * 4.0) *
      decay *
      (1.0 + 0.5 * sin(d * 20.0 - burst_time * 10.0));

        // Add quantum interference
    explosion += wave * (1.0 + 0.3 * sin(angle * float(i) - burst_time));
  }

    // Particle trails
  float trails = 0.0;
  for(int i = 0; i < 6; i++) {
        // Create quantum particles
    float theta = float(i) * 1.04719755119;
    float speed = 1.0 + 0.3 * sin(theta);
    vec2 velocity = vec2(cos(theta), sin(theta)) * speed;
    vec2 pos = velocity * burst_time * 0.5;

        // Calculate trail intensity
    float d = length(uv - pos);
    float trail = exp(-d * 3.0) *
      exp(-burst_time * 0.5) *
      (0.5 + 0.5 * sin(d * 15.0 - burst_time * 8.0));

    trails += trail;
  }

    // Quantum sparkles
  float sparkles = 0.0;
  for(int i = 0; i < 12; i++) {
        // Create sparkle positions
    float phi = float(i) * 0.523598775598;
    float r = burst_time * (0.8 + 0.4 * sin(phi));
    vec2 pos = vec2(cos(phi + burst_time) * r, sin(phi + burst_time) * r) * 0.4;

        // Calculate sparkle intensity
    float d = length(uv - pos);
    sparkles += exp(-d * 20.0) *
      decay *
      (1.0 + sin(burst_time * 20.0 + phi));
  }

    // Secondary particles
  float particles = 0.0;
  for(int i = 0; i < 15; i++) {
        // Create particle cascade
    float phase = float(i) * 0.418879020479;
    float r = burst_time * (0.5 + 0.2 * sin(phase * 3.0));
    vec2 pos = vec2(cos(phase * 2.0 + burst_time) * r, sin(phase * 2.0 + burst_time) * r) * 0.6;

        // Calculate particle density
    float d = length(uv - pos);
    particles += exp(-d * 15.0) *
      decay *
      (0.5 + 0.5 * sin(d * 30.0 - burst_time * 15.0));
  }

    // Combine quantum firework effects with spectral colors
  vec3 explosionColor = mix(vec3(1.0, 0.2, 0.1),  // Red core
  vec3(1.0, 0.8, 0.1),  // Yellow outer
  explosion) * explosion;

  vec3 trailColor = mix(vec3(0.1, 0.4, 1.0),  // Blue base
  vec3(0.2, 0.8, 1.0),  // Cyan tip
  trails) * trails;

  vec3 sparkleColor = vec3(1.0, 0.9, 0.8) * sparkles;  // White sparkles

  vec3 particleColor = mix(vec3(0.9, 0.3, 0.9),  // Purple
  vec3(0.3, 0.9, 0.9),  // Turquoise
  particles) * particles;

    // Final composition with quantum glow
  float glow = exp(-dist * 0.4) *
    (1.0 + 0.2 * sin(angle * 4.0 - burst_time * 2.0));

  return vec4((explosionColor + trailColor + sparkleColor + particleColor) *
    glow * 2.0,  // Boost brightness
  1.0);
}
