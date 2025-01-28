// Energy Burst Effect
// Creates electric arcs and energy bursts

vec4 f() {
    // Parameters
  float arcSpeed = 5.0;
  float arcWidth = 0.01;
  float fadeRate = 0.9;

    // Create electric arc pattern
  vec2 center = vec2(0.5);
  float dist = length(p - center);

    // Generate multiple arcs
  float arc = 0.0;
  for(int i = 0; i < 5; i++) {
    float angle = float(i) * 2.5 + t * arcSpeed;
    vec2 arcPos = center + vec2(cos(angle), sin(angle)) * 0.3;
    float arcDist = length(p - arcPos);

        // Create branching effect
    float branch = sin(arcDist * 50.0 + t * 10.0) * cos(atan(p.y - arcPos.y, p.x - arcPos.x) * 5.0);
    arc += smoothstep(arcWidth, 0.0, abs(arcDist - 0.1 - branch * 0.02));
  }

    // Create energy color
  vec4 energyColor = vec4(0.3 + 0.7 * sin(t * 2.0),     // Blue-white pulsing
  0.5 + 0.5 * cos(t * 3.0), 1.0, 1.0);

    // Add central core
  float core = smoothstep(0.1, 0.0, dist);

    // Sample previous frame with slight distortion
  float distortion = arc * 0.01;
  vec2 distortedUV = p + vec2(sin(p.y * 10.0 + t) * distortion, cos(p.x * 10.0 - t) * distortion);
  vec4 previous = texture2D(b, distortedUV) * fadeRate;

    // Combine everything
  vec4 current = energyColor * (arc + core);
  return max(previous, current);
}
