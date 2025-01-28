/*
String Theory Vibrations
Advanced visualization demonstrating:
- Multi-dimensional string oscillations
- Calabi-Yau compactification
- Supersymmetric patterns
- Harmonic resonances
- Quantum string dynamics

Physical concepts:
- String worldsheet
- Extra dimensions
- Vibrational modes
- Supersymmetry
- Compactification
*/

vec4 f() {
    // Initialize worldsheet coordinates
  vec2 uv = (p * 2.0 - 1.0) * 3.0;
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

    // String tension parameters
  float tension = 1.0 + 0.3 * sin(t * 0.5);
  vec2 string_dir = vec2(cos(t * 0.3), sin(t * 0.3));

    // Primary string vibrations
  float vibration = 0.0;
  for(int i = 0; i < 7; i++) {
        // Create vibrational modes
    float mode = float(i) + 1.0;
    float freq = mode * 3.14159 / tension;

        // Calculate string displacement
    float phase = t * freq;
    vec2 pos = vec2(cos(phase + float(i) * 0.5), sin(phase + float(i) * 0.5)) * 0.8;

        // Add harmonic contribution
    float d = length(uv - pos);
    vibration += exp(-d * 3.0) *
      sin(d * mode * 4.0 - phase) *
      exp(-mode * 0.3);
  }

    // Compactified dimensions
  float compact = 0.0;
  for(int i = 0; i < 5; i++) {
        // Create compact dimension
    float theta = float(i) * 1.25663706144;
    vec2 dim = vec2(cos(t + theta) * string_dir.x, sin(t + theta) * string_dir.y) * 0.7;

        // Calculate dimensional wrapping
    float r = length(uv - dim);
    compact += exp(-r * 4.0) *
      sin(r * 8.0 - t + theta);
  }

    // Supersymmetric partners
  float susy = 0.0;
  for(int i = 0; i < 4; i++) {
        // Create superpartner pairs
    float phase = float(i) * 1.57079632679;
    vec2 p1 = vec2(cos(t * 1.5 + phase), sin(t * 1.5 + phase)) * 0.6;
    vec2 p2 = -p1; // Superpartner

        // Calculate SUSY correlation
    float d1 = length(uv - p1);
    float d2 = length(uv - p2);
    susy += exp(-(d1 + d2) * 2.0) *
      sin((d1 - d2) * 6.0 - t);
  }

    // String interaction vertices
  float interact = 0.0;
  for(int i = 0; i < 3; i++) {
        // Create interaction points
    vec2 vertex = vec2(cos(t * 2.0 + float(i) * 2.0944), sin(t * 2.0 + float(i) * 2.0944)) * 0.5;

        // Calculate interaction strength
    float d = length(uv - vertex);
    interact += exp(-d * 5.0) *
      pow(sin(d * 10.0 - t) * 0.5 + 0.5, 2.0);
  }

    // Combine string theory effects with spectral colors
  vec3 vibrateColor = mix(vec3(0.1, 0.4, 0.9), vec3(0.9, 0.1, 0.8), vibration) * vibration;

  vec3 compactColor = mix(vec3(0.2, 0.8, 0.5), vec3(0.8, 0.2, 0.4), compact) * compact;

  vec3 susyColor = mix(vec3(0.3, 0.6, 1.0), vec3(1.0, 0.3, 0.7), susy) * susy;

  vec3 interactColor = vec3(0.7, 0.4, 1.0) * interact;

    // Final composition with string tension modulation
  float tension_mod = exp(-dist * 0.4) *
    (1.0 + 0.2 * sin(angle * 3.0 - t * tension));

  return vec4((vibrateColor + compactColor + susyColor + interactColor) *
    tension_mod, 1.0);
}
