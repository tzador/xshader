// Wave Function Interference
// Simulates quantum wave packet evolution and interference

vec4 f() {
    // Wave parameters
  float wavelength = 0.1;
  float speed = 0.5;
  float decay = 0.995;
  float dispersion = 0.001;

    // Create two wave sources
  vec2 source1 = vec2(0.3, 0.5);
  vec2 source2 = vec2(0.7, 0.5);

    // Calculate distances from sources
  float d1 = length(p - source1);
  float d2 = length(p - source2);

    // Calculate wave phases
  float phase1 = d1 / wavelength - t * speed;
  float phase2 = d2 / wavelength - t * speed;

    // Create wave amplitudes with distance attenuation
  float amp1 = sin(phase1 * 6.28318) / (1.0 + d1 * 5.0);
  float amp2 = sin(phase2 * 6.28318) / (1.0 + d2 * 5.0);

    // Combine waves
  float combinedAmp = amp1 + amp2;

    // Calculate phase difference for interference pattern
  float phaseDiff = abs(mod(phase1 - phase2, 2.0) - 1.0);

    // Sample previous frame with dispersion
  vec2 dispersionOffset = vec2(sin(combinedAmp * 6.28318) * dispersion, cos(combinedAmp * 6.28318) * dispersion);
  vec4 previous = texture2D(b, p + dispersionOffset) * decay;

    // Create wave color
  vec4 waveColor = vec4(0.5 + 0.5 * combinedAmp,                    // Red
  0.5 + 0.5 * sin(phaseDiff * 3.14159),      // Green
  0.5 + 0.5 * cos(combinedAmp * 3.14159),    // Blue
  1.0);

    // Add quantum probability density visualization
  float probability = combinedAmp * combinedAmp;
  vec4 probColor = vec4(probability * sin(t), probability * cos(t), probability, 1.0);

    // Combine wave function and probability visualization with feedback
  return max(mix(waveColor, probColor, 0.5), previous);
}
