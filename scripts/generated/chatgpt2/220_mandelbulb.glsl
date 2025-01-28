/*
Mandelbulb Projection
Creates a 2D visualization of a rotating 3D Mandelbulb fractal
with dynamic lighting, depth, and ambient occlusion effects.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 2.0;
  vec3 color = vec3(0.0);
  float ao = 0.0;

    // Camera rotation matrices
  float time = t * 0.2;
  mat2 rot_xz = mat2(cos(time), -sin(time), sin(time), cos(time));
  mat2 rot_yz = mat2(cos(time * 0.7), -sin(time * 0.7), sin(time * 0.7), cos(time * 0.7));

    // Ray setup
  vec3 ray = vec3(uv, 2.0);
  ray.xz = rot_xz * ray.xz;
  ray.yz = rot_yz * ray.yz;
  ray = normalize(ray);

  vec3 pos = vec3(0.0);
  float dist = 0.0;
  float total_dist = 0.0;

    // Ray marching loop
  for(int i = 0; i < 64; i++) {
    vec3 z = pos;
    float dr = 1.0;
    float r = 0.0;

        // Mandelbulb iteration
    for(int j = 0; j < 8; j++) {
      r = length(z);
      if(r > 2.0)
        break;

            // Convert to polar coordinates
      float theta = acos(z.z / r);
      float phi = atan(z.y, z.x);
      dr = pow(r, 7.0) * 7.0 * dr + 1.0;

            // Scale and rotate
      float zr = pow(r, 8.0);
      theta = theta * 8.0;
      phi = phi * 8.0;

            // Convert back to cartesian coordinates
      z = zr * vec3(sin(theta) * cos(phi), sin(theta) * sin(phi), cos(theta));
      z += pos;
    }

        // Distance estimation
    dist = 0.5 * log(r) * r / dr;
    total_dist += dist;

        // Accumulate ambient occlusion
    ao += exp(-dist * 2.0);

        // Move along ray
    pos += ray * dist;

        // Break if hit or miss
    if(dist < 0.001 || total_dist > 4.0)
      break;
  }

    // Calculate surface normal
  vec3 normal = normalize(pos);

    // Create base color from position
  color = 0.5 + 0.5 * cos(vec3(length(pos) * 2.0 + t, length(pos) * 2.0 + t + 2.094, length(pos) * 2.0 + t + 4.189));

    // Apply ambient occlusion
  ao = 1.0 - ao * 0.02;
  color *= ao;

    // Add depth fog
  color *= exp(-total_dist * 0.5);

    // Add specular highlight
  vec3 light_dir = normalize(vec3(1.0, 1.0, -1.0));
  float spec = pow(max(0.0, dot(reflect(ray, normal), light_dir)), 32.0);
  color += vec3(1.0, 0.8, 0.6) * spec * ao;

    // Add glow for missed rays
  color += vec3(0.1, 0.2, 0.4) * smoothstep(3.0, 4.0, total_dist);

  return vec4(color, 1.0);
}
