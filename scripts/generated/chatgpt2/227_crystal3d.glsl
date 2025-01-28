/*
3D Crystal Growth
Creates a visualization of growing crystals with light
refraction, caustics, and internal reflections.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 2.0;
  vec3 color = vec3(0.0);

    // Crystal parameters
  const int CRYSTAL_COUNT = 6;
  const float GROWTH_SPEED = 0.5;
  const float IOR = 1.5;  // Index of refraction

    // Create rotation matrices
  float time = t * 0.2;
  mat2 rot = mat2(cos(time), -sin(time), sin(time), cos(time));

    // Ray setup for refraction
  vec3 ray_dir = normalize(vec3(uv, 2.0));
  vec3 ray_pos = vec3(0.0, 0.0, -3.0);

    // Crystal faces and reflections
  for(int i = 0; i < CRYSTAL_COUNT; i++) {
    float angle = float(i) * 1.0472;
    float growth = (1.0 + sin(angle + t * GROWTH_SPEED)) * 0.5;

        // Crystal face orientation
    vec3 normal = normalize(vec3(cos(angle) * growth, sin(angle) * growth, 1.0));

        // Calculate refraction
    float cos_i = dot(-ray_dir, normal);
    float eta = cos_i > 0.0 ? IOR : 1.0 / IOR;
    normal *= sign(cos_i);
    float k = 1.0 - eta * eta * (1.0 - cos_i * cos_i);

    vec3 refracted = k > 0.0 ? eta * ray_dir + (eta * cos_i - sqrt(k)) * normal : reflect(ray_dir, normal);

        // Internal reflections
    vec3 internal_pos = ray_pos;
    vec3 internal_dir = refracted;
    float intensity = 1.0;

    for(int j = 0; j < 3; j++) {
            // Intersect with crystal faces
      float t_hit = 1e10;
      vec3 hit_normal = vec3(0.0);

      for(int k = 0; k < CRYSTAL_COUNT; k++) {
        float a = float(k) * 1.0472;
        float g = (1.0 + sin(a + t * GROWTH_SPEED)) * 0.5;

        vec3 face_normal = normalize(vec3(cos(a) * g, sin(a) * g, 1.0));

        float d = dot(face_normal, internal_pos);
        float t_intersect = -d / dot(face_normal, internal_dir);

        if(t_intersect > 0.0 && t_intersect < t_hit) {
          t_hit = t_intersect;
          hit_normal = face_normal;
        }
      }

            // Update position and direction
      internal_pos += internal_dir * t_hit;
      internal_dir = reflect(internal_dir, hit_normal);
      intensity *= 0.8;

            // Add caustics
      float caustic = pow(abs(dot(internal_dir, vec3(0.0, 0.0, 1.0))), 8.0);
      color += vec3(0.5, 0.8, 1.0) * caustic * intensity * 0.3;
    }

        // Add face color and highlights
    float face_intensity = pow(1.0 - abs(dot(normal, ray_dir)), 4.0);
    vec3 face_color = mix(vec3(0.2, 0.5, 1.0),  // Base color
    vec3(1.0),            // Highlight
    face_intensity);

        // Add dispersion
    float dispersion = pow(1.0 - abs(dot(refracted, normal)), 2.0);
    face_color += vec3(1.0, 0.2, 0.1) * dispersion;

    color += face_color * growth * 0.3;
  }

    // Add ambient occlusion
  float ao = exp(-length(uv) * 0.5);
  color *= 0.8 + 0.2 * ao;

    // Add glow
  float glow = exp(-length(uv) * 2.0);
  color += vec3(0.2, 0.4, 1.0) * glow * 0.5;

    // Tone mapping
  color = pow(color, vec3(0.8));

  return vec4(color, 1.0);
}
