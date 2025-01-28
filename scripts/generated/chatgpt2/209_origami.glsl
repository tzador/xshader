/*
Origami Pattern
Creates animated folding patterns inspired by
origami tessellations.
*/

vec4 f() {
  vec2 uv = p * 4.0;
  vec2 id = floor(uv);
  vec2 gv = fract(uv) - 0.5;

    // Create fold pattern
  float fold = sin(dot(id, vec2(0.5)) + t) * 0.5 + 0.5;

    // Calculate fold lines
  float diag = abs(gv.x + gv.y) * 2.0;
  float anti_diag = abs(gv.x - gv.y) * 2.0;

    // Combine folds
  float pattern = mix(diag, anti_diag, fold);

    // Add shading based on fold
  float shade = 1.0 - pattern;
  shade *= 1.0 + 0.2 * sin(fold * 6.28);

    // Create color gradient
  vec3 color = mix(vec3(0.9, 0.8, 0.7),  // Paper color
  vec3(0.4, 0.3, 0.2),  // Shadow color
  shade);

  return vec4(color, 1.0);
}
