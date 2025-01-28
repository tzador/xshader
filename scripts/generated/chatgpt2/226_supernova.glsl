/*
Supernova Explosion
Creates a visualization of a supernova with shock waves,
element synthesis, and expanding stellar material.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 3.0;
  vec3 color = vec3(0.0);
  float r = length(uv);
  float theta = atan(uv.y, uv.x);

    // Explosion timing
  float explosion_time = mod(t, 8.0);
  float explosion_phase = explosion_time / 8.0;

    // Shock wave parameters
  float shock_radius = explosion_phase * 2.0;
  float shock_width = 0.1 + explosion_phase * 0.2;

    // Create base star
  float core = exp(-r * r * 4.0);
  vec3 star_color = mix(vec3(1.0, 0.8, 0.6),  // Core
  vec3(1.0, 0.6, 0.2),  // Surface
  r) * core;

    // Shock wave dynamics
  float shock = exp(-pow(abs(r - shock_radius), 2.0) / shock_width);
  shock *= 1.0 + 0.5 * sin(theta * 16.0 + explosion_time * 4.0);

    // Element synthesis regions
  for(int i = 0; i < 4; i++) {
    float layer = float(i) * 0.3;
    float element_r = shock_radius * (0.5 + layer);

        // Create element shell
    float shell = exp(-pow(abs(r - element_r), 2.0) / (0.1 + layer * 0.1));

        // Element-specific patterns
    float pattern = sin(theta * (8.0 + float(i) * 4.0) +
      r * 20.0 + explosion_time * 2.0);
    pattern = pattern * 0.5 + 0.5;

        // Element colors (Fe -> Si -> O -> He)
    vec3 element_color = mix(vec3(0.8, 0.4, 0.2),  // Iron (inner)
    vec3(0.2, 0.8, 1.0),  // Helium (outer)
    layer);

    color += element_color * shell * pattern * (1.0 - layer * 0.5);
  }

    // Add shock wave
  vec3 shock_color = mix(vec3(1.0, 0.2, 0.1),  // Hot shock
  vec3(1.0, 0.8, 0.4),  // Cooling shock
  explosion_phase);
  color += shock_color * shock;

    // Expanding debris
  for(int i = 0; i < 32; i++) {
    float angle = float(i) * 0.196;
    float debris_r = shock_radius * (0.8 + sin(angle * 3.0) * 0.2);

    vec2 debris_pos = vec2(cos(angle + explosion_time), sin(angle + explosion_time)) * debris_r;

    float debris = exp(-length(uv - debris_pos) * 8.0);
    color += vec3(1.0, 0.6, 0.3) * debris;
  }

    // Add core collapse
  if(explosion_phase < 0.1) {
    float collapse = explosion_phase / 0.1;
    float implosion = exp(-r * r / (0.1 * collapse));
    color = mix(vec3(0.1, 0.2, 1.0),  // Neutron star formation
    color, collapse) * implosion;
  }

    // Add neutrino burst
  float neutrino_burst = exp(-pow(explosion_phase - 0.1, 2.0) * 200.0);
  color += vec3(0.5, 1.0, 0.5) * neutrino_burst *
    exp(-r * r * 2.0);

    // Add stellar wind
  vec2 wind_uv = uv * (1.0 + explosion_phase * 0.5);
  float wind = sin(length(wind_uv) * 10.0 - explosion_time * 4.0);
  wind = wind * 0.5 + 0.5;
  color += vec3(1.0, 0.9, 0.8) * wind * 0.2 *
    smoothstep(2.0, 0.0, r);

    // Tone mapping
  color = pow(color, vec3(0.8));

  return vec4(color, 1.0);
}
