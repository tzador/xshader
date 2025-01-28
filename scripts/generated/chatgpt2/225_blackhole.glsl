/*
Black Hole
Creates a visualization of a black hole with gravitational
lensing, accretion disk, and relativistic effects.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 4.0;
  vec3 color = vec3(0.0);

    // Black hole parameters
  float black_hole_radius = 0.4;
  float accretion_inner = 0.8;
  float accretion_outer = 2.0;

    // Calculate gravitational distortion
  float r = length(uv);
  float theta = atan(uv.y, uv.x);

    // Gravitational lensing
  float distortion = 1.0 / (1.0 + exp(-(r - black_hole_radius) * 8.0));
  vec2 distorted_uv = uv * mix(0.0, 1.0, distortion);

    // Create star background
  vec2 star_uv = distorted_uv * 2.0;
  for(int i = 0; i < 3; i++) {
    float layer = float(i) * 0.5;
    vec2 offset = vec2(sin(t * 0.1 + layer), cos(t * 0.15 + layer));

    vec2 star_pos = star_uv + offset;
    vec2 star_id = floor(star_pos * 5.0);

    float star = fract(sin(dot(star_id, vec2(127.1, 311.7))) * 43758.5453);

    star = pow(star, 20.0) * exp(-layer);
    color += vec3(1.0, 0.9, 0.8) * star;
  }

    // Accretion disk
  float disk_r = length(distorted_uv);
  float disk_theta = atan(distorted_uv.y, distorted_uv.x);

  if(disk_r > accretion_inner && disk_r < accretion_outer) {
        // Relativistic doppler effect
    float velocity = 1.0 / sqrt(disk_r);
    float doppler = 1.0 / (1.0 - velocity * sin(disk_theta));

        // Disk pattern
    float pattern = sin(disk_theta * 8.0 + disk_r * 20.0 - t * 2.0);
    pattern = pattern * 0.5 + 0.5;

        // Temperature gradient
    vec3 disk_color = mix(vec3(1.0, 0.3, 0.1),  // Hot inner disk
    vec3(0.8, 0.2, 0.1),  // Cooler outer disk
    (disk_r - accretion_inner) / (accretion_outer - accretion_inner));

        // Apply doppler shift
    disk_color *= pow(doppler, 0.5);

        // Add disk to scene
    float disk_mask = smoothstep(0.1, 0.0, abs(distorted_uv.y / disk_r * 2.0));
    color += disk_color * pattern * disk_mask;
  }

    // Event horizon
  float horizon = smoothstep(black_hole_radius * 1.1, black_hole_radius, r);
  color = mix(color, vec3(0.0), horizon);

    // Gravitational light bending
  float light_bend = smoothstep(black_hole_radius * 2.0, black_hole_radius, r);
  color *= 1.0 - light_bend * 0.8;

    // Add photon sphere glow
  float photon_sphere = exp(-pow(abs(r - black_hole_radius * 1.5), 2.0) * 4.0);
  color += vec3(0.2, 0.5, 1.0) * photon_sphere;

    // Relativistic beaming
  float beaming = pow(1.0 + dot(normalize(uv), vec2(1.0, 0.0)), 4.0);
  color *= mix(1.0, beaming, 0.3);

    // Tone mapping
  color = pow(color, vec3(0.8));

  return vec4(color, 1.0);
}
