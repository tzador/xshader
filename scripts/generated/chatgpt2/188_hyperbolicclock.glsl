/*
Hyperbolic Clock
Advanced visualization demonstrating:
- Hyperbolic geometry
- Möbius transformations
- Poincaré disk model
- Hyperbolic tessellations
- Non-Euclidean rotations

Mathematical concepts:
- Hyperbolic functions
- Complex analysis
- Conformal mappings
- Isometries
- Geodesic flows
*/

vec4 f() {
    // Initialize hyperbolic coordinates
  vec2 uv = (p * 2.0 - 1.0) * 2.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Time parameters
  float seconds = mod(t, 60.0);
  float minutes = mod(t / 60.0, 60.0);
  float hours = mod(t / 3600.0, 12.0);

    // Poincaré disk mapping
  vec2 z = uv / (1.0 + sqrt(1.0 - dist * dist));
  float hyp_dist = 2.0 * atanh(dist);

    // Clock face (hyperbolic tessellation)
  float face = 0.0;
  for(int i = 0; i < 12; i++) {
        // Create hyperbolic markers
    float marker_angle = float(i) * 0.523598775598;
    vec2 w = vec2(cos(marker_angle), sin(marker_angle));

        // Möbius transformation
    vec2 mobius = vec2((w.x * z.x + w.y * z.y), (w.y * z.x - w.x * z.y)) / (1.0 + length(w) * length(z));

        // Add tessellation pattern
    float d = length(mobius);
    face += exp(-d * 10.0) *
      (1.0 + 0.2 * sin(hyp_dist * 5.0 - seconds * 0.2));
  }

    // Hour hand (hyperbolic geodesics)
  float hour_hand = 0.0;
  float hour_angle = hours * 0.523598775598 - 1.57079632679;
  for(int i = 0; i < 8; i++) {
        // Create geodesic flow
    float phase = float(i) * 0.785398163397;
    vec2 h = vec2(cos(hour_angle), sin(hour_angle)) * tanh(phase);

        // Hyperbolic distance
    vec2 h_pos = (h + z) / (1.0 + dot(h, z));
    float d = 2.0 * atanh(length(h_pos));

    hour_hand += exp(-d * 3.0) *
      (1.0 + 0.3 * sin(phase - seconds * 0.1));
  }

    // Minute hand (conformal spirals)
  float minute_hand = 0.0;
  float minute_angle = minutes * 0.104719755119 - 1.57079632679;
  for(int i = 0; i < 10; i++) {
        // Create conformal mapping
    float phase = float(i) * 0.628318530718;
    vec2 m = vec2(cos(minute_angle + phase), sin(minute_angle + phase)) * tanh(phase * 0.3);

        // Complex multiplication
    vec2 m_pos = vec2(m.x * z.x - m.y * z.y, m.x * z.y + m.y * z.x);

    float d = 2.0 * atanh(length(m_pos));
    minute_hand += exp(-d * 4.0) *
      (1.0 + 0.2 * sin(phase - seconds * 0.2));
  }

    // Second hand (isometric flows)
  float second_hand = 0.0;
  float second_angle = seconds * 0.104719755119 - 1.57079632679;
  for(int i = 0; i < 12; i++) {
        // Create isometry
    float phase = float(i) * 0.523598775598;
    vec2 s = vec2(cos(second_angle), sin(second_angle)) *
      tanh(phase * 0.5);

        // Hyperbolic rotation
    vec2 s_pos = vec2(s.x * z.x + s.y * z.y, -s.x * z.y + s.y * z.x);

    float d = 2.0 * atanh(length(s_pos));
    second_hand += exp(-d * 5.0) *
      (1.0 + 0.4 * sin(phase + seconds * 2.0));
  }

    // Combine hyperbolic elements with mathematical colors
  vec3 faceColor = mix(vec3(0.1, 0.1, 0.3),  // Deep blue
  vec3(0.2, 0.2, 0.6),  // Medium blue
  face) * face;

  vec3 hourColor = mix(vec3(0.6, 0.1, 0.2),  // Deep red
  vec3(0.8, 0.2, 0.3),  // Medium red
  hour_hand) * hour_hand;

  vec3 minuteColor = mix(vec3(0.1, 0.5, 0.1),  // Deep green
  vec3(0.2, 0.7, 0.2),  // Medium green
  minute_hand) * minute_hand;

  vec3 secondColor = mix(vec3(0.6, 0.6, 0.1),  // Deep yellow
  vec3(0.8, 0.8, 0.2),  // Medium yellow
  second_hand) * second_hand;

    // Add hyperbolic depth
  float depth = (1.0 - dist * dist) *
    (1.0 + 0.2 * sin(hyp_dist * 3.0 - seconds));

  return vec4((faceColor + hourColor + minuteColor + secondColor) *
    depth * 2.0,  // Boost brightness
  1.0);
}
