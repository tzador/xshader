/*
Chemical Reaction
Simulates particle interactions and chemical reactions
using minimal distance field techniques.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * 3.0;
  float reaction = 0.0;

    // Create reagent particles
  for(int i = 0; i < 6; i++) {
        // Particle positions
    float angle = float(i) * 1.0472;
    vec2 pos = vec2(cos(angle + t), sin(angle * 1.5 + t * 0.7));

        // Reaction field
    float dist = length(uv - pos);
    float particle = exp(-dist * 4.0);

        // Interaction with other particles
    for(int j = 0; j < 6; j++) {
      if(i != j) {
        float angle2 = float(j) * 1.0472;
        vec2 pos2 = vec2(cos(angle2 + t * 1.1), sin(angle2 * 1.5 + t * 0.8));

                // Calculate reaction intensity
        float interact = exp(-length(pos - pos2) * 2.0);
        particle *= 1.0 + interact;
      }
    }

    reaction += particle;
  }

    // Reaction colors
  vec3 color1 = vec3(0.8, 0.2, 0.1);  // Reagent 1 (red)
  vec3 color2 = vec3(0.1, 0.2, 0.8);  // Reagent 2 (blue)
  vec3 color3 = vec3(0.8, 0.7, 0.1);  // Product (yellow)

  vec3 color = mix(mix(color1, color2, sin(t) * 0.5 + 0.5), color3, reaction);

  return vec4(color, 1.0);
}
