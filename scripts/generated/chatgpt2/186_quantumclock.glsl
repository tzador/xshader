/*
Quantum Clock
Advanced visualization demonstrating:
- Quantum probability wave hands
- Time dilation effects
- Uncertainty principle visualization
- Quantum state transitions
- Temporal interference patterns

Physical concepts:
- Wave function collapse
- Time evolution
- Quantum superposition
- Phase transitions
- Temporal coherence
*/

vec4 f() {
    // Initialize clock coordinates
  vec2 uv = (p * 2.0 - 1.0) * 2.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Time parameters
  float seconds = mod(t, 60.0);
  float minutes = mod(t / 60.0, 60.0);
  float hours = mod(t / 3600.0, 12.0);

    // Clock face
  float face = 0.0;
  for(int i = 0; i < 12; i++) {
        // Create hour markers
    float marker_angle = float(i) * 0.523598775598;
    vec2 marker = vec2(cos(marker_angle), sin(marker_angle)) * 0.9;
    float d = length(uv - marker);

        // Add marker glow
    face += exp(-d * 20.0) *
      (1.0 + 0.2 * sin(seconds * 0.1));
  }

    // Hour hand (quantum probability wave)
  float hour_hand = 0.0;
  float hour_angle = hours * 0.523598775598 - 1.57079632679;
  for(int i = 0; i < 8; i++) {
    float phase = float(i) * 0.785398163397;
    vec2 h_pos = vec2(cos(hour_angle + phase * 0.1), sin(hour_angle + phase * 0.1)) * (0.5 + 0.1 * sin(phase));

    float d = length(uv - h_pos * 0.6);
    hour_hand += exp(-d * 8.0) *
      (1.0 + 0.3 * sin(phase - seconds * 0.1));
  }

    // Minute hand (probability distribution)
  float minute_hand = 0.0;
  float minute_angle = minutes * 0.104719755119 - 1.57079632679;
  for(int i = 0; i < 10; i++) {
    float phase = float(i) * 0.628318530718;
    vec2 m_pos = vec2(cos(minute_angle + phase * 0.05), sin(minute_angle + phase * 0.05)) * (0.7 + 0.1 * sin(phase));

    float d = length(uv - m_pos * 0.8);
    minute_hand += exp(-d * 10.0) *
      (1.0 + 0.2 * sin(phase - seconds * 0.2));
  }

    // Second hand (quantum tunneling effect)
  float second_hand = 0.0;
  float second_angle = seconds * 0.104719755119 - 1.57079632679;
  for(int i = 0; i < 12; i++) {
    float phase = float(i) * 0.523598775598;
    vec2 s_pos = vec2(cos(second_angle + phase * 0.02), sin(second_angle + phase * 0.02)) * (0.9 + 0.1 * sin(phase));

    float d = length(uv - s_pos * 0.9);
    second_hand += exp(-d * 15.0) *
      (1.0 + 0.4 * sin(phase + seconds * 2.0));
  }

    // Center quantum vortex
  float center = exp(-dist * 20.0) *
    (2.0 + sin(seconds * 2.0));

    // Combine clock elements with quantum colors
  vec3 faceColor = mix(vec3(0.1, 0.2, 0.4),  // Dark blue base
  vec3(0.2, 0.4, 0.8),  // Light blue markers
  face) * face;

  vec3 hourColor = mix(vec3(0.8, 0.2, 0.1),  // Red core
  vec3(1.0, 0.4, 0.2),  // Orange glow
  hour_hand) * hour_hand;

  vec3 minuteColor = mix(vec3(0.1, 0.8, 0.2),  // Green core
  vec3(0.2, 1.0, 0.4),  // Light green glow
  minute_hand) * minute_hand;

  vec3 secondColor = mix(vec3(0.8, 0.8, 0.1),  // Yellow core
  vec3(1.0, 1.0, 0.2),  // Bright yellow glow
  second_hand) * second_hand;

  vec3 centerColor = vec3(1.0, 1.0, 1.0) * center;  // White center

    // Add quantum uncertainty blur
  float uncertainty = 0.1 * sin(seconds * 0.5);
  float blur = exp(-dist * (4.0 + uncertainty));

  return vec4((faceColor + hourColor + minuteColor + secondColor + centerColor) *
    blur * 1.5,  // Boost brightness
  1.0);
}
