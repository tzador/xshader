/*
Bitwise Patterns
Creates animated patterns using bitwise operations on
pixel coordinates and time, producing digital artifacts.
*/

vec4 f() {
    // Create integer coordinates
  ivec2 pos = ivec2(p * 256.0);
  int time = int(t * 20.0);

    // Perform bitwise operations
  int pattern = (pos.x ^ pos.y) ^ (time | (pos.x + pos.y));
  int pattern2 = (pos.x & time) | (pos.y ^ time);

    // Create color from bit patterns
  vec3 color = vec3(float(pattern & 255) / 255.0, float(pattern2 & 255) / 255.0, float((pattern ^ pattern2) & 255) / 255.0);

    // Add high-frequency detail
  color *= 0.8 + 0.2 * step(0.5, fract(float(pattern ^ time) * 0.1));

  return vec4(color, 1.0);
}
