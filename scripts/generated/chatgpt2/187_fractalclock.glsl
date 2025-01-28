/*
Fractal Clock
Advanced visualization demonstrating:
- Self-similar time markers
- Recursive hand patterns
- Mandelbrot-based face
- Julia set transitions
- Fractal dimension shifts

Mathematical concepts:
- Complex dynamics
- Iterative systems
- Self-similarity
- Fractal geometry
- Dynamic recursion
*/

vec4 f() {
    // Initialize complex coordinates
  vec2 uv = (p * 2.0 - 1.0) * 2.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Time parameters
  float seconds = mod(t, 60.0);
  float minutes = mod(t / 60.0, 60.0);
  float hours = mod(t / 3600.0, 12.0);

    // Fractal clock face (Mandelbrot-inspired)
  float face = 0.0;
  vec2 z = uv;
  vec2 c = vec2(0.7 * cos(seconds * 0.1), 0.7 * sin(seconds * 0.1));
  for(int i = 0; i < 8; i++) {
        // Mandelbrot iteration
    z = vec2(z.x * z.x - z.y * z.y + c.x, 2.0 * z.x * z.y + c.y) * 0.5;

        // Add fractal detail
    float d = length(z);
    face += exp(-d * 3.0) *
      (1.0 + 0.2 * sin(float(i) * 0.5 - seconds * 0.2));
  }

    // Hour markers (Julia set variations)
  float markers = 0.0;
  for(int i = 0; i < 12; i++) {
        // Create fractal markers
    float marker_angle = float(i) * 0.523598775598;
    vec2 marker = vec2(cos(marker_angle), sin(marker_angle)) * 0.9;

        // Julia set for each marker
    vec2 w = uv - marker * 0.8;
    for(int j = 0; j < 4; j++) {
      w = vec2(w.x * w.x - w.y * w.y, 2.0 * w.x * w.y) + marker * 0.2;
    }

    markers += exp(-length(w) * 10.0);
  }

    // Hour hand (recursive spiral)
  float hour_hand = 0.0;
  float hour_angle = hours * 0.523598775598 - 1.57079632679;
  vec2 h = vec2(cos(hour_angle), sin(hour_angle));
  for(int i = 0; i < 6; i++) {
        // Create recursive branches
    float scale = pow(0.7, float(i));
    vec2 h_pos = h * (0.6 * scale);
    float d = length(uv - h_pos);

        // Add spiral detail
    hour_hand += exp(-d * (10.0 + float(i) * 5.0)) *
      scale *
      (1.0 + 0.3 * sin(float(i) * 1.0 - seconds * 0.1));
  }

    // Minute hand (fractal branches)
  float minute_hand = 0.0;
  float minute_angle = minutes * 0.104719755119 - 1.57079632679;
  vec2 m = vec2(cos(minute_angle), sin(minute_angle));
  for(int i = 0; i < 8; i++) {
        // Create branching pattern
    float scale = pow(0.8, float(i));
    float branch_angle = float(i) * 0.2;
    vec2 m_pos = vec2(cos(minute_angle + branch_angle), sin(minute_angle + branch_angle)) * (0.8 * scale);

    float d = length(uv - m_pos);
    minute_hand += exp(-d * (12.0 + float(i) * 4.0)) *
      scale *
      (1.0 + 0.2 * sin(float(i) * 1.5 - seconds * 0.2));
  }

    // Second hand (fractal dust)
  float second_hand = 0.0;
  float second_angle = seconds * 0.104719755119 - 1.57079632679;
  vec2 s = vec2(cos(second_angle), sin(second_angle));
  for(int i = 0; i < 10; i++) {
        // Create dust particles
    float scale = pow(0.9, float(i));
    float dust_angle = float(i) * 0.1;
    vec2 s_pos = vec2(cos(second_angle + dust_angle), sin(second_angle + dust_angle)) * (0.9 * scale);

    float d = length(uv - s_pos);
    second_hand += exp(-d * (15.0 + float(i) * 3.0)) *
      scale *
      (1.0 + 0.4 * sin(float(i) * 2.0 + seconds * 2.0));
  }

    // Combine fractal elements with iridescent colors
  vec3 faceColor = mix(vec3(0.1, 0.0, 0.2),  // Deep purple
  vec3(0.2, 0.0, 0.4),  // Royal purple
  face) * (face + markers);

  vec3 hourColor = mix(vec3(0.8, 0.1, 0.1),  // Deep red
  vec3(1.0, 0.3, 0.1),  // Orange-red
  hour_hand) * hour_hand;

  vec3 minuteColor = mix(vec3(0.1, 0.6, 0.1),  // Deep green
  vec3(0.2, 0.8, 0.2),  // Bright green
  minute_hand) * minute_hand;

  vec3 secondColor = mix(vec3(0.8, 0.6, 0.1),  // Gold
  vec3(1.0, 0.8, 0.2),  // Yellow
  second_hand) * second_hand;

    // Add fractal glow
  float glow = exp(-dist * 2.0) *
    (1.0 + 0.2 * sin(angle * 8.0 - seconds));

  return vec4((faceColor + hourColor + minuteColor + secondColor) *
    glow * 2.0,  // Boost brightness
  1.0);
}
