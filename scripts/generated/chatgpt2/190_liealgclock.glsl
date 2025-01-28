/*
Lie Algebra Clock
Advanced visualization demonstrating:
- Lie group orbits
- Root systems
- Weight lattices
- Cartan subalgebra
- Exponential map

Mathematical concepts:
- Lie theory
- Group actions
- Root decomposition
- Weyl chambers
- Representation theory
*/

vec4 f() {
    // Initialize Lie algebra coordinates
  vec2 uv = (p * 2.0 - 1.0) * 2.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Time parameters
  float seconds = mod(t, 60.0);
  float minutes = mod(t / 60.0, 60.0);
  float hours = mod(t / 3600.0, 12.0);

    // Root system parameters
  vec2 alpha1 = vec2(1.0, 0.0);  // Simple root
  vec2 alpha2 = vec2(-0.5, 0.866);  // Simple root
  vec2 alpha3 = vec2(-0.5, -0.866);  // Simple root

    // Clock face (root lattice)
  float face = 0.0;
  for(int i = 0; i < 12; i++) {
        // Create root vectors
    float theta = float(i) * 0.523598775598;
    vec2 root = vec2(cos(theta), sin(theta));

        // Weyl reflection
    vec2 refl = root - 2.0 * dot(root, alpha1) * alpha1;
    float d1 = length(uv - root * 0.8);
    float d2 = length(uv - refl * 0.8);

        // Add root contribution
    face += exp(-min(d1, d2) * 10.0) *
      (1.0 + 0.2 * sin(dist * 8.0 - seconds * 0.2));
  }

    // Hour hand (Cartan flow)
  float hour_hand = 0.0;
  float hour_angle = hours * 0.523598775598 - 1.57079632679;
  for(int i = 0; i < 8; i++) {
        // Create Cartan element
    float phase = float(i) * 0.785398163397;
    vec2 H = vec2(cos(hour_angle), sin(hour_angle)) *
      exp(phase * 0.3);

        // Exponential map
    vec2 exp_H = vec2(H.x * cos(phase) - H.y * sin(phase), H.x * sin(phase) + H.y * cos(phase));

    float d = length(uv - exp_H * 0.6);
    hour_hand += exp(-d * 6.0) *
      (1.0 + 0.3 * sin(phase - seconds * 0.1));
  }

    // Minute hand (weight lattice)
  float minute_hand = 0.0;
  float minute_angle = minutes * 0.104719755119 - 1.57079632679;
  for(int i = 0; i < 10; i++) {
        // Create weight vector
    float phase = float(i) * 0.628318530718;
    vec2 weight = vec2(cos(minute_angle + phase), sin(minute_angle + phase));

        // Highest weight orbit
    vec2 orbit = weight * (0.8 - 0.1 * sin(phase));
    float d = length(uv - orbit);
    minute_hand += exp(-d * 8.0) *
      (1.0 + 0.2 * sin(phase - seconds * 0.2));
  }

    // Second hand (nilpotent flow)
  float second_hand = 0.0;
  float second_angle = seconds * 0.104719755119 - 1.57079632679;
  for(int i = 0; i < 12; i++) {
        // Create nilpotent element
    float phase = float(i) * 0.523598775598;
    vec2 N = vec2(cos(second_angle + phase), sin(second_angle + phase));

        // Nilpotent orbit
    vec2 orbit = N * (0.9 - 0.1 * cos(phase * 2.0));
    float d = length(uv - orbit);
    second_hand += exp(-d * 10.0) *
      (1.0 + 0.4 * sin(phase + seconds * 2.0));
  }

    // Combine Lie algebra elements with algebraic colors
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

    // Add Lie group invariant
  float invariant = exp(-dist * 2.0) *
    (1.0 + 0.2 * sin(angle * 6.0 - seconds));

  return vec4((faceColor + hourColor + minuteColor + secondColor) *
    invariant * 2.0,  // Boost brightness
  1.0);
}
