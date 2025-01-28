/*
Energy Field Effect
Creates a dynamic energy field visualization with:
1. Primary energy core
2. Field distortions
3. Power surges
4. Particle emissions
5. Wave interactions
Simulates a high-energy field with multiple phenomena
*/

vec4 f() {
    // Initialize coordinate system
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // Primary energy core
  float core = exp(-abs(dist - 0.5 - 0.2 * sin(t)) * 8.0);
  float glow = sin(core * 2.0) * exp(-dist);

    // Field distortions
  float field = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create field vectors
    float phase = float(i) * 1.57079632679 + t;
    vec2 dir = vec2(cos(phase), sin(phase));
        // Calculate field intensity
    float intensity = pow(max(0.0, dot(normalize(uv), dir)), 2.0) *
      (1.0 + 0.5 * sin(dot(uv, dir) * 6.0 - t));
    field += intensity;
  }

    // Power surges
  float power = 0.0;
  for(int i = 0; i < 3; i++) {
        // Create surge points
    vec2 center = vec2(cos(t * 2.0 + float(i) * 2.09439510239), sin(t * 2.0 + float(i) * 2.09439510239)) * 0.7;
    float d = length(uv - center);
    power += exp(-d * 6.0) *
      (1.0 + 0.5 * sin(d * 15.0 - t));
  }

    // Wave interactions
  float waves = 0.0;
  for(int i = 0; i < 4; i++) {
    float ring = abs(dist - 0.4 - float(i) * 0.2 +
      0.1 * sin(t * 1.5 + float(i)));
    waves += exp(-ring * 7.0) *
      sin(ring * 20.0 - t + angle);
  }

    // Combine effects with color
  vec3 coreColor = mix(vec3(0.2, 0.5, 1.0), vec3(1.0, 0.3, 0.1), core + glow) * (core + glow);
  vec3 fieldColor = mix(vec3(0.3, 0.6, 0.9), vec3(0.9, 0.3, 0.8), field) * field;
  vec3 powerColor = vec3(0.8, 0.5, 0.2) * power;
  vec3 waveColor = vec3(0.6, 0.4, 1.0) * waves;

    // Final composition
  return vec4((coreColor + fieldColor + powerColor + waveColor) *
    smoothstep(1.0, 0.0, dist), 1.0);
}
