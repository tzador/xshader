/*
Traversable Wormhole
Creates a visualization of an Einstein-Rosen bridge with
relativistic effects and spacetime distortion.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 4.0;
  vec3 color = vec3(0.0);
  float r = length(uv);
  float theta = atan(uv.y, uv.x);

    // Wormhole parameters
  float throat_radius = 0.5;
  float throat_length = 2.0;

    // Calculate spacetime distortion
  float distortion = 1.0 / (1.0 + exp(-(r - throat_radius) * 8.0));
  float warp = exp(-pow(r - throat_radius, 2.0) * 4.0);

    // Create coordinate transformation for throat
  float z = throat_length * (1.0 - warp);
  vec3 pos = vec3(uv * mix(1.0, 0.2, warp), z);

    // Time dilation effect
  float time_dilation = sqrt(1.0 - warp);
  float local_time = t * time_dilation;

    // Create star field for both universes
  for(int i = 0; i < 2; i++) {
    float universe = float(i);
    float universe_time = local_time + universe * 10.0;

    for(int j = 0; j < 3; j++) {
      float layer = float(j) * 0.5;
      vec2 star_uv = uv * (1.0 + layer) * mix(1.0, -1.0, universe);

      vec2 offset = vec2(sin(universe_time * 0.1 + layer), cos(universe_time * 0.15 + layer));

      vec2 star_pos = star_uv + offset;
      vec2 star_id = floor(star_pos * 5.0);

      float star = fract(sin(dot(star_id, vec2(127.1, 311.7))) * 43758.5453);

      star = pow(star, 20.0) * exp(-layer);
      color += mix(vec3(1.0, 0.9, 0.8),  // Universe 1 stars
      vec3(0.8, 0.9, 1.0),  // Universe 2 stars
      universe) * star * (1.0 - warp);
    }
  }

    // Create throat visualization
  float throat = smoothstep(throat_radius * 1.1, throat_radius * 0.9, r);
  vec3 throat_color = mix(vec3(0.1, 0.2, 0.4),  // Outer throat
  vec3(0.8, 0.3, 0.1),  // Inner throat
  warp);

    // Add gravitational lensing
  float lensing = exp(-pow(abs(r - throat_radius), 2.0) * 16.0);
  vec2 lens_uv = normalize(uv) * mix(r, throat_radius, lensing);

    // Create event horizon glow
  float horizon = exp(-pow(abs(r - throat_radius), 2.0) * 4.0);
  vec3 horizon_color = mix(vec3(0.2, 0.5, 1.0),  // Blue shift
  vec3(1.0, 0.3, 0.1),  // Red shift
  smoothstep(-1.0, 1.0, z));

    // Add Hawking radiation
  float radiation = 0.0;
  for(int i = 0; i < 6; i++) {
    float angle = float(i) * 1.0472 + local_time;
    vec2 rad_pos = vec2(cos(angle), sin(angle)) * throat_radius;

    radiation += exp(-length(uv - rad_pos) * 8.0) *
      (0.5 + 0.5 * sin(local_time * 4.0 + float(i)));
  }

    // Add frame dragging effect
  float drag = atan(lens_uv.y, lens_uv.x) - theta;
  drag = smoothstep(0.0, 3.14159, abs(drag)) * warp;

    // Combine all effects
  color = mix(color, throat_color, throat);
  color += horizon_color * horizon * 0.5;
  color += vec3(1.0, 0.8, 0.6) * radiation * 0.2;
  color *= 1.0 - drag * 0.5;

    // Add relativistic beaming
  float beaming = pow(1.0 + dot(normalize(pos), vec3(1.0, 0.0, 0.0)), 4.0);
  color *= mix(1.0, beaming, warp * 0.3);

    // Tone mapping
  color = pow(color, vec3(0.8));

  return vec4(color, 1.0);
}
