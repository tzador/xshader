float random(vec2 st) {
  return fract(S(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float character(vec2 st, float seed) {
  float r = random(vec2(seed, floor(st.y)));
  float char = floor(r * 3.0);
  float brightness = step(0.5, random(st + char));
  return brightness;
}

vec4 f() {
  // Scale UV to create more characters
  vec2 uv = p * vec2(30.0, 40.0);

  // Create falling effect
  float speed = 2.0;
  uv.y += t * speed;

  // Get grid position
  vec2 grid = fract(uv);
  vec2 id = floor(uv);

  // Generate random streams
  float stream = random(vec2(id.x, 0.0));
  float streamSpeed = 0.5 + stream * 1.5;
  float streamLength = 0.3 + stream * 0.7;

  // Calculate character and fade
  float char = character(id, t * streamSpeed);
  float fade = 1.0 - fract(uv.y * streamLength);

  // Create trail effect
  float trail = smoothstep(0.0, 0.3, fade);

  // Add brightness variation
  float brightness = char * trail;
  brightness *= 0.8 + 0.2 * S(t * 10.0 + id.y + id.x);

  // Create color
  vec3 green = vec3(0.0, 1.0, 0.0);
  vec3 brightGreen = vec3(0.4, 1.0, 0.4);
  vec3 color = mix(green, brightGreen, brightness);

  // Add screen glow
  float glow = exp(-length(p * 2.0 - 1.0) * 1.5);
  color += vec3(0.0, 0.2, 0.0) * glow;

  // Add scanline effect
  float scanline = 0.5 + 0.5 * S(p.y * 100.0 + t * 10.0);
  color *= 0.9 + 0.1 * scanline;

  return vec4(color * brightness, 1.0);
}
