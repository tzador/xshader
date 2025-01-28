/*
Modular Forms Clock
Advanced visualization demonstrating:
- Modular symmetries
- Complex lattices
- Theta functions
- Eisenstein series
- Fundamental domains

Mathematical concepts:
- Modular forms
- Complex analysis
- Lattice theory
- Automorphic forms
- Elliptic functions
*/

vec4 f() {
    // Initialize modular coordinates
  vec2 uv = (p * 2.0 - 1.0) * 2.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Time parameters
  float seconds = mod(t, 60.0);
  float minutes = mod(t / 60.0, 60.0);
  float hours = mod(t / 3600.0, 12.0);

    // Modular parameters
  vec2 tau = vec2(1.0, sqrt(3.0));  // Upper half-plane
  float q = exp(-2.0 * 3.14159 * tau.y);

    // Clock face (modular lattice)
  float face = 0.0;
  for(int i = 0; i < 12; i++) {
        // Create lattice points
    float theta = float(i) * 0.523598775598;
    vec2 z = vec2(cos(theta), sin(theta));

        // Modular transformation
    vec2 w = vec2((z.x * tau.x + z.y) / (z.x * tau.y), tau.y / (z.x * z.x + z.y * z.y));

        // Calculate lattice contribution
    float d = length(uv - w * 0.8);
    face += exp(-d * 10.0) *
      (1.0 + 0.2 * sin(dist * 8.0 - seconds * 0.2));
  }

    // Hour hand (theta function)
  float hour_hand = 0.0;
  float hour_angle = hours * 0.523598775598 - 1.57079632679;
  for(int i = 0; i < 8; i++) {
        // Create theta series
    float n = float(i) - 4.0;
    float phase = n * hour_angle;
    vec2 z = vec2(cos(phase), sin(phase)) *
      exp(-3.14159 * n * n * q);

        // Calculate theta contribution
    float d = length(uv - z * 0.6);
    hour_hand += exp(-d * 6.0) *
      (1.0 + 0.3 * sin(phase - seconds * 0.1));
  }

    // Minute hand (Eisenstein series)
  float minute_hand = 0.0;
  float minute_angle = minutes * 0.104719755119 - 1.57079632679;
  for(int i = 0; i < 10; i++) {
        // Create Eisenstein series
    float k = float(i) + 2.0;
    float phase = k * minute_angle;
    vec2 z = vec2(cos(phase) / pow(k, 2.0), sin(phase) / pow(k, 2.0));

        // Calculate Eisenstein contribution
    float d = length(uv - z * 0.8);
    minute_hand += exp(-d * 8.0) *
      (1.0 + 0.2 * sin(phase - seconds * 0.2));
  }

    // Second hand (j-function)
  float second_hand = 0.0;
  float second_angle = seconds * 0.104719755119 - 1.57079632679;
  for(int i = 0; i < 12; i++) {
        // Create j-invariant
    float phase = float(i) * 0.523598775598;
    vec2 z = vec2(cos(second_angle), sin(second_angle)) *
      (0.9 - 0.1 * cos(phase * 3.0));

        // Calculate j-function contribution
    float d = length(uv - z);
    second_hand += exp(-d * 10.0) *
      (1.0 + 0.4 * sin(phase + seconds * 2.0));
  }

    // Combine modular elements with complex colors
  vec3 faceColor = mix(vec3(0.1, 0.1, 0.3),  // Deep blue
  vec3(0.2, 0.2, 0.6),  // Light blue
  face) * face;

  vec3 hourColor = mix(vec3(0.5, 0.1, 0.1),  // Deep red
  vec3(0.7, 0.2, 0.2),  // Light red
  hour_hand) * hour_hand;

  vec3 minuteColor = mix(vec3(0.1, 0.4, 0.1),  // Deep green
  vec3(0.2, 0.6, 0.2),  // Light green
  minute_hand) * minute_hand;

  vec3 secondColor = mix(vec3(0.5, 0.5, 0.1),  // Deep yellow
  vec3(0.7, 0.7, 0.2),  // Light yellow
  second_hand) * second_hand;

    // Add modular invariant
  float invariant = exp(-dist * 2.0) *
    (1.0 + 0.2 * sin(angle * 6.0 - seconds));

  return vec4((faceColor + hourColor + minuteColor + secondColor) *
    invariant * 2.0,  // Boost brightness
  1.0);
}
