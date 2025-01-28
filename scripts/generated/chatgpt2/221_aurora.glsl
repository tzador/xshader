/*
Aurora Borealis
Creates a realistic aurora simulation with volumetric
lighting, magnetic field dynamics, and atmospheric scattering.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * vec2(2.0, 4.0);
  vec3 color = vec3(0.0);

    // Sky gradient
  float sky = 1.0 - length(uv * vec2(0.5, 0.3));
  vec3 sky_color = mix(vec3(0.0, 0.0, 0.1),  // Dark sky
  vec3(0.1, 0.2, 0.4),  // Blue horizon
  pow(sky, 2.0));

    // Star field
  vec2 star_uv = uv * 20.0;
  vec2 star_id = floor(star_uv);
  vec2 star_fd = fract(star_uv) - 0.5;

  for(int i = -1; i <= 1; i++) {
    for(int j = -1; j <= 1; j++) {
      vec2 offset = vec2(float(i), float(j));
      vec2 pos = star_id + offset;

      float star = fract(sin(dot(pos, vec2(127.1, 311.7))) * 43758.5453);

      float twinkle = sin(star * 10.0 + t) * 0.5 + 0.5;
      star = pow(star, 20.0) * twinkle;

      vec2 delta = star_fd - offset;
      float dist = length(delta);

      color += vec3(1.0, 0.8, 0.6) * star *
        smoothstep(0.1, 0.0, dist);
    }
  }

    // Magnetic field
  float field_strength = 0.0;
  vec2 field_uv = uv;

  for(int i = 0; i < 5; i++) {
    float layer = float(i) * 0.2;

        // Field dynamics
    vec2 offset = vec2(sin(t * 0.5 + layer * 5.0), cos(t * 0.3 + layer * 3.0)) * 0.3;

        // Distort coordinates
    vec2 pos = field_uv + offset;
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);

        // Create field lines
    float field = sin(angle * 3.0 + t + layer * 2.0) *
      sin(radius * 4.0 - t * 2.0 + layer);

    field_strength += field * (1.0 - layer * 0.15);
  }

    // Aurora colors
  vec3 aurora_color = mix(vec3(0.1, 0.8, 0.2),  // Green
  vec3(0.2, 0.3, 0.9),  // Blue
  sin(field_strength * 2.0 + t) * 0.5 + 0.5);

    // Add purple highlights
  aurora_color += vec3(0.6, 0.1, 0.8) *
    pow(field_strength, 4.0);

    // Volumetric lighting
  float volume = exp(-abs(uv.y + 0.5) * 2.0);
  aurora_color *= volume;

    // Layer blending
  float aurora_mask = smoothstep(-0.2, 0.3, field_strength);
  color = mix(sky_color + color,  // Sky with stars
  aurora_color,       // Aurora
  aurora_mask * 0.7);

    // Add atmospheric glow
  color += aurora_color * 0.2 *
    smoothstep(0.5, 0.0, length(uv));

  return vec4(color, 1.0);
}
