/*
Music Visualizer
Creates a minimal music visualization with
frequency bands and beat detection.
*/

vec4 f() {
  vec2 uv = p * vec2(8.0, 2.0);
  vec2 id = floor(uv);
  vec2 gv = fract(uv) - 0.5;

    // Generate frequency bands
  float freq = fract(sin(dot(id, vec2(127.1, 311.7))) * 43758.5453);

    // Animate frequency
  float band = freq * (0.8 + 0.4 * sin(t * 4.0 + id.x));

    // Create bar visualization
  float bar = smoothstep(band - 0.02, band, 0.5 - abs(gv.y));

    // Add beat pulse
  float beat = sin(t * 2.0) * 0.5 + 0.5;
  bar *= 1.0 + 0.2 * beat;

    // Color bands
  vec3 color = vec3(sin(id.x * 0.5) * 0.5 + 0.5, cos(id.x * 0.5) * 0.5 + 0.5, sin(id.x * 0.5 + 1.57) * 0.5 + 0.5) * bar;

  return vec4(color, 1.0);
}
