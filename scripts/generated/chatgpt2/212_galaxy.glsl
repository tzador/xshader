/*
Spiral Galaxy
Creates a minimal galaxy simulation with
rotating arms and star clusters.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 4.0;
  float stars = 0.0;

    // Create spiral arms
  float angle = atan(uv.y, uv.x);
  float radius = length(uv);
  float spiral = angle + radius * 2.0 - t;

    // Generate star clusters
  for(int i = 0; i < 3; i++) {
    float arm_angle = spiral + float(i) * 2.094;
    float arm = exp(-pow(mod(arm_angle, 2.094) - 1.047, 2.0) * 4.0);

        // Add stars to arm
    stars += arm * exp(-radius * radius) *
      (0.5 + 0.5 * sin(radius * 20.0 + t));
  }

    // Add central bulge
  stars += exp(-radius * radius * 4.0);

    // Create galaxy colors
  vec3 color = mix(vec3(0.8, 0.6, 0.4),  // Yellow core
  vec3(0.4, 0.5, 1.0),  // Blue arms
  radius * 0.5) * stars;

  return vec4(color, 1.0);
}
