// Expanding Ring Explosion
// Creates periodic ring explosions from the center

vec4 f() {
    // Parameters
  float expansionSpeed = 0.3;
  float ringWidth = 0.02;
  float fadeRate = 0.95;

    // Calculate distance from center
  vec2 center = vec2(0.5);
  float dist = length(p - center);

    // Create expanding rings
  float time = mod(t, 3.0); // Reset every 3 seconds
  float ringRadius = time * expansionSpeed;
  float ring = smoothstep(ringRadius - ringWidth, ringRadius, dist) *
    smoothstep(ringRadius + ringWidth, ringRadius, dist);

    // Create color for new explosion
  float explosionIntensity = (1.0 - time * 0.3); // Fade with time
  vec4 explosionColor = vec4(1.0,                                // Red
  0.5 + 0.5 * sin(dist * 10.0),      // Yellow-Orange variation
  0.2 * explosionIntensity,           // Blue
  1.0) * ring * explosionIntensity;

    // Add shock wave distortion
  float shockDist = abs(dist - ringRadius);
  float shock = exp(-shockDist * 50.0) * 0.1;
  vec2 distortedUV = p + normalize(p - center) * shock;

    // Sample previous frame with distortion
  vec4 previous = texture2D(b, distortedUV) * fadeRate;

    // Add some noise to the explosion
  float noise = sin(p.x * 50.0 + t) * sin(p.y * 50.0 + t) * 0.1;

    // Combine everything
  return max(previous, explosionColor + noise);
}
