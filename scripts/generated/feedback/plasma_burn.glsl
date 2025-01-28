// Plasma Burn Effect
// Creates flowing plasma-like fire with heat distortion

vec4 f() {
    // Parameters
  float flowSpeed = 0.002;
  float heatDistortion = 0.005;
  float fadeRate = 0.98;

    // Create base plasma pattern
  float plasma = sin(p.x * 10.0 + t) * cos(p.y * 10.0 - t) +
    sin(length(p - 0.5) * 10.0) +
    sin(length(p - vec2(0.7, 0.3)) * 8.0) * cos(t);

    // Create flow field
  vec2 flow = vec2(sin(p.y * 4.0 + t) * flowSpeed, cos(p.x * 4.0 - t) * flowSpeed);

    // Add heat distortion
  vec2 distortion = vec2(sin(plasma + t) * heatDistortion, cos(plasma - t) * heatDistortion);

    // Sample previous frame with flow and distortion
  vec2 samplePos = p - flow + distortion;
  vec4 previous = texture2D(b, samplePos) * fadeRate;

    // Create new plasma color
  float intensity = 0.5 + 0.5 * sin(plasma);
  vec4 plasmaColor = vec4(0.8 + 0.2 * sin(plasma + t),     // Red
  0.4 + 0.2 * cos(plasma - t),     // Green
  0.9 + 0.1 * sin(plasma * 2.0),   // Blue
  1.0) * intensity;

    // Add some high-frequency detail
  float detail = sin(p.x * 50.0 + t) * sin(p.y * 50.0 - t) * 0.1;

    // Combine with smooth transition
  return max(previous, plasmaColor + detail);
}
