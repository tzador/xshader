/*
Crystal Growth
Simulates crystal formation with geometric growth patterns
and prismatic color effects.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 2.0;
  float pattern = 0.0;

    // Create crystal axes
  for(int i = 0; i < 6; i++) {
    float angle = float(i) * 1.0472;
    vec2 dir = vec2(cos(angle), sin(angle));

        // Growth along axis
    float axis = abs(dot(uv, dir));
    float growth = mod(axis - t, 1.0);

        // Crystal formation
    pattern += exp(-growth * 8.0) *
      (0.5 + 0.5 * sin(axis * 10.0 + t));
  }

    // Add radial component
  float rad = length(uv);
  pattern *= exp(-rad * rad * 2.0);

    // Prismatic colors
  vec3 color = vec3(pattern * (sin(rad * 5.0 - t) * 0.5 + 0.5), pattern * (cos(rad * 5.0 - t) * 0.5 + 0.5), pattern);

  return vec4(color, 1.0);
}
