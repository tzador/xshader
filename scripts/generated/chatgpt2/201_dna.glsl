/*
DNA Helix
Creates a minimal DNA double helix visualization with
base pairs and rotating strands.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 2.0;
  float y = uv.y + t;  // Scrolling effect

    // Create double helix
  float x1 = 0.3 * sin(y * 4.0);
  float x2 = 0.3 * sin(y * 4.0 + 3.14159);

    // Draw strands
  float strand1 = exp(-pow(uv.x - x1, 2.0) * 40.0);
  float strand2 = exp(-pow(uv.x - x2, 2.0) * 40.0);

    // Add base pairs
  float bases = exp(-pow(mod(y, 0.4) - 0.2, 2.0) * 80.0) *
    exp(-pow(uv.x, 2.0) * 20.0);

    // Combine with colors
  vec3 color1 = vec3(0.8, 0.2, 0.2);  // Red strand
  vec3 color2 = vec3(0.2, 0.2, 0.8);  // Blue strand
  vec3 baseColor = vec3(0.8);          // White bases

  vec3 color = color1 * strand1 + color2 * strand2 + baseColor * bases;

  return vec4(color, 1.0);
}
