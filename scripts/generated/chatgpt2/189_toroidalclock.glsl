/*
Toroidal Clock
Advanced visualization demonstrating:
- Torus topology
- Principal curvatures
- Geodesic curves
- Parallel transport
- Periodic orbits

Mathematical concepts:
- Differential geometry
- Torus knots
- Parallel transport
- Killing vector fields
- Periodic functions
*/

vec4 f() {
    // Initialize toroidal coordinates
  vec2 uv = (p * 2.0 - 1.0) * 2.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Time parameters
  float seconds = mod(t, 60.0);
  float minutes = mod(t / 60.0, 60.0);
  float hours = mod(t / 3600.0, 12.0);

    // Torus parameters
  float R = 1.0;  // Major radius
  float r = 0.3;  // Minor radius
  vec2 torus_pos = vec2((R + r * cos(angle)) * cos(dist * 3.14159), (R + r * cos(angle)) * sin(dist * 3.14159));

    // Clock face (toroidal lattice)
  float face = 0.0;
  for(int i = 0; i < 12; i++) {
        // Create markers on torus
    float marker_angle = float(i) * 0.523598775598;
    vec2 w = vec2(cos(marker_angle) * (R + r * cos(dist * 6.28318)), sin(marker_angle) * (R + r * sin(dist * 6.28318)));

        // Calculate geodesic distance
    float d = length(torus_pos - w);
    face += exp(-d * 8.0) *
      (1.0 + 0.2 * sin(dist * 10.0 - seconds * 0.2));
  }

    // Hour hand (torus knot)
  float hour_hand = 0.0;
  float hour_angle = hours * 0.523598775598 - 1.57079632679;
  for(int i = 0; i < 8; i++) {
        // Create knot curve
    float phase = float(i) * 0.785398163397;
    vec2 h = vec2(cos(hour_angle + phase * 2.0), sin(hour_angle + phase * 3.0)) * (R + r * cos(phase));

    float d = length(torus_pos - h);
    hour_hand += exp(-d * 5.0) *
      (1.0 + 0.3 * sin(phase - seconds * 0.1));
  }

    // Minute hand (parallel transport)
  float minute_hand = 0.0;
  float minute_angle = minutes * 0.104719755119 - 1.57079632679;
  for(int i = 0; i < 10; i++) {
        // Create parallel vector field
    float phase = float(i) * 0.628318530718;
    vec2 m = vec2(cos(minute_angle) * (R + r * cos(phase)), sin(minute_angle) * (R + r * sin(phase)));

    float d = length(torus_pos - m);
    minute_hand += exp(-d * 6.0) *
      (1.0 + 0.2 * sin(phase - seconds * 0.2));
  }

    // Second hand (Killing field)
  float second_hand = 0.0;
  float second_angle = seconds * 0.104719755119 - 1.57079632679;
  for(int i = 0; i < 12; i++) {
        // Create Killing vector field
    float phase = float(i) * 0.523598775598;
    vec2 s = vec2(cos(second_angle) * (R + r * cos(phase * 2.0)), sin(second_angle) * (R + r * sin(phase * 2.0)));

    float d = length(torus_pos - s);
    second_hand += exp(-d * 7.0) *
      (1.0 + 0.4 * sin(phase + seconds * 2.0));
  }

    // Combine toroidal elements with geometric colors
  vec3 faceColor = mix(vec3(0.2, 0.1, 0.4),  // Deep purple
  vec3(0.4, 0.2, 0.8),  // Light purple
  face) * face;

  vec3 hourColor = mix(vec3(0.7, 0.1, 0.1),  // Deep red
  vec3(0.9, 0.2, 0.2),  // Light red
  hour_hand) * hour_hand;

  vec3 minuteColor = mix(vec3(0.1, 0.6, 0.1),  // Deep green
  vec3(0.2, 0.8, 0.2),  // Light green
  minute_hand) * minute_hand;

  vec3 secondColor = mix(vec3(0.7, 0.7, 0.1),  // Deep yellow
  vec3(0.9, 0.9, 0.2),  // Light yellow
  second_hand) * second_hand;

    // Add toroidal curvature effect
  float curvature = (1.0 - pow(dist, 2.0)) *
    (1.0 + 0.2 * sin(angle * 6.0 - seconds));

  return vec4((faceColor + hourColor + minuteColor + secondColor) *
    curvature * 2.0,  // Boost brightness
  1.0);
}
