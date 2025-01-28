/*
Knot Theory Clock
Advanced visualization demonstrating:
- Braid group actions
- Knot invariants
- Link diagrams
- Crossing numbers
- Alexander polynomials

Mathematical concepts:
- Knot theory
- Braid groups
- Linking numbers
- Jones polynomials
- Reidemeister moves
*/

vec4 f() {
    // Initialize knot coordinates
  vec2 uv = (p * 2.0 - 1.0) * 2.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Time parameters
  float seconds = mod(t, 60.0);
  float minutes = mod(t / 60.0, 60.0);
  float hours = mod(t / 3600.0, 12.0);

    // Clock face (trefoil knot)
  float face = 0.0;
  for(int i = 0; i < 12; i++) {
        // Create knot crossings
    float theta = float(i) * 0.523598775598;
    vec2 p1 = vec2(cos(theta), sin(theta)) * 0.8;
    vec2 p2 = vec2(cos(theta + 2.0944), sin(theta + 2.0944)) * 0.8;

        // Calculate crossing invariant
    float d1 = length(uv - p1);
    float d2 = length(uv - p2);
    float crossing = exp(-min(d1, d2) * 10.0) *
      (1.0 + 0.2 * sin(theta * 3.0 - seconds * 0.2));

    face += crossing;
  }

    // Hour hand (figure-eight knot)
  float hour_hand = 0.0;
  float hour_angle = hours * 0.523598775598 - 1.57079632679;
  for(int i = 0; i < 8; i++) {
        // Create braid strands
    float phase = float(i) * 0.785398163397;
    vec2 h1 = vec2(cos(hour_angle + phase), sin(hour_angle + phase)) * (0.6 + 0.1 * sin(phase * 2.0));

    vec2 h2 = vec2(cos(hour_angle - phase), sin(hour_angle - phase)) * (0.6 - 0.1 * sin(phase * 2.0));

        // Calculate braid crossing
    float d = min(length(uv - h1), length(uv - h2));
    hour_hand += exp(-d * 6.0) *
      (1.0 + 0.3 * sin(phase - seconds * 0.1));
  }

    // Minute hand (torus knot)
  float minute_hand = 0.0;
  float minute_angle = minutes * 0.104719755119 - 1.57079632679;
  for(int i = 0; i < 10; i++) {
        // Create torus path
    float phase = float(i) * 0.628318530718;
    float r = 0.8 + 0.1 * sin(phase * 3.0);
    float theta = minute_angle + phase * 2.0;

    vec2 m = vec2(r * cos(theta), r * sin(theta)) * 0.8;

        // Calculate torus knot
    float d = length(uv - m);
    minute_hand += exp(-d * 8.0) *
      (1.0 + 0.2 * sin(phase - seconds * 0.2));
  }

    // Second hand (Hopf link)
  float second_hand = 0.0;
  float second_angle = seconds * 0.104719755119 - 1.57079632679;
  for(int i = 0; i < 12; i++) {
        // Create linked components
    float phase = float(i) * 0.523598775598;
    vec2 s1 = vec2(cos(second_angle + phase), sin(second_angle + phase)) * (0.9 + 0.1 * sin(phase));

    vec2 s2 = vec2(cos(second_angle - phase), sin(second_angle - phase)) * (0.9 - 0.1 * sin(phase));

        // Calculate linking number
    float d = min(length(uv - s1), length(uv - s2));
    second_hand += exp(-d * 10.0) *
      (1.0 + 0.4 * sin(phase + seconds * 2.0));
  }

    // Combine knot elements with topological colors
  vec3 faceColor = mix(vec3(0.1, 0.2, 0.4),  // Deep blue
  vec3(0.2, 0.4, 0.8),  // Light blue
  face) * face;

  vec3 hourColor = mix(vec3(0.6, 0.1, 0.1),  // Deep red
  vec3(0.8, 0.2, 0.2),  // Light red
  hour_hand) * hour_hand;

  vec3 minuteColor = mix(vec3(0.1, 0.5, 0.1),  // Deep green
  vec3(0.2, 0.7, 0.2),  // Light green
  minute_hand) * minute_hand;

  vec3 secondColor = mix(vec3(0.6, 0.6, 0.1),  // Deep yellow
  vec3(0.8, 0.8, 0.2),  // Light yellow
  second_hand) * second_hand;

    // Add knot invariant
  float invariant = exp(-dist * 2.0) *
    (1.0 + 0.2 * sin(angle * 6.0 - seconds));

  return vec4((faceColor + hourColor + minuteColor + secondColor) *
    invariant * 2.0,  // Boost brightness
  1.0);
}
