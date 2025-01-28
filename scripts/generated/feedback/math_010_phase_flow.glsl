// Phase Flow Field
// Visualizes vector fields and streamlines

vec4 f() {
    // Flow parameters
  float flowSpeed = 0.002;
  float fadeRate = 0.99;
  float particleDensity = 30.0;

    // Create flow field (combination of several fields)
  vec2 center = vec2(0.5);
  float dist = length(p - center);
  float angle = atan(p.y - center.y, p.x - center.x);

    // Rotational field
  vec2 rotational = vec2(cos(angle + t), sin(angle + t)) * dist;

    // Sink/source field
  vec2 radial = normalize(p - center) * sin(dist * 10.0 + t);

    // Wavy field
  vec2 wavy = vec2(sin(p.y * 5.0 + t), cos(p.x * 5.0 + t));

    // Combine fields
  vec2 flowField = normalize(rotational * 0.5 +
    radial * 0.3 +
    wavy * 0.2) * flowSpeed;

    // Calculate flow intensity
  float intensity = length(flowField) / flowSpeed;

    // Create particles based on position
  vec2 particlePos = fract(p * particleDensity + t);
  float particle = smoothstep(0.1, 0.0, length(particlePos - 0.5));

    // Sample previous frame with flow offset
  vec4 previous = texture2D(b, p - flowField) * fadeRate;

    // Create flow visualization color
  vec4 flowColor = vec4(0.5 + 0.5 * sin(angle * 3.0 + t), 0.5 + 0.5 * cos(dist * 5.0 - t), 0.5 + 0.5 * sin(intensity * 10.0 + t), 1.0);

    // Add streamlines
  float streamline = smoothstep(0.1, 0.0, abs(sin(dot(normalize(flowField), p) * 20.0 + t)));

    // Create critical points visualization
  float criticalPoint = smoothstep(0.1, 0.0, length(flowField) / flowSpeed);
  vec4 criticalColor = vec4(1.0, 0.2, 0.1, 1.0) * criticalPoint;

    // Combine everything
  vec4 current = flowColor * (particle + streamline * 0.3) + criticalColor;
  return max(current, previous);
}
