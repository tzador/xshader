// Nuclear Fusion Effect
// Simulates plasma turbulence and energy release

vec4 f() {
    // Parameters
  float turbulenceScale = 15.0;
  float energySpeed = 2.0;
  float fadeRate = 0.95;

    // Calculate base turbulence
  vec2 center = vec2(0.5);
  float dist = length(p - center);

    // Create turbulent flow field
  float angle = atan(p.y - center.y, p.x - center.x);
  float turbulence = sin(dist * turbulenceScale + t) *
    cos(angle * 5.0 + t * 2.0) *
    sin((p.x + p.y) * 8.0 + t);

    // Create plasma distortion
  vec2 distortion = vec2(cos(turbulence + t * energySpeed) * 0.01, sin(turbulence - t * energySpeed) * 0.01) * (1.0 - dist);  // Reduce distortion at edges

    // Sample previous frame with turbulent distortion
  vec4 previous = texture2D(b, p + distortion) * fadeRate;

    // Create new energy
  float energy = (sin(dist * 20.0 + t) *
    cos(angle * 3.0 + t * 1.5) *
    sin(turbulence * 2.0)) * 0.5 + 0.5;

    // Core color
  float coreIntensity = smoothstep(0.3, 0.0, dist);
  vec4 coreColor = vec4(1.0,                            // Red
  0.7 + 0.3 * sin(t),            // Green/Yellow
  0.3 + 0.2 * cos(t * 2.0),      // Blue
  1.0) * coreIntensity;

    // Plasma color
  vec4 plasmaColor = vec4(0.8 + 0.2 * sin(energy * 5.0 + t), 0.6 + 0.4 * cos(energy * 3.0 - t), 0.3 + 0.2 * sin(energy * 4.0 + t * 2.0), 1.0) * energy * (1.0 - coreIntensity);

    // Add high-frequency detail
  float detail = sin(p.x * 50.0 + t) * sin(p.y * 50.0 - t) * 0.1;

    // Combine everything
  return max(previous, coreColor + plasmaColor + detail);
}
