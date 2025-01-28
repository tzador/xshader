float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);

  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));

  return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;
  float frequency = 1.0;

  for(float i = 0.0; i < 6.0; i++) {
    value += amplitude * noise(p * frequency);
    amplitude *= 0.5;
    frequency *= 2.0;
  }

  return value;
}

float butterflyWing(vec2 uv, float angle, float scale) {
  // Transform space
  uv = uv * scale;
  float r = length(uv);
  float theta = atan(uv.y, uv.x);

  // Create wing shape using polar function
  float wing = 0.0;

  // Base shape
  float shape = exp(-r * 2.0) * (1.0 + 0.5 * S(theta * 2.0 + t));
  shape *= smoothstep(0.0, 0.1, r);

  // Add vein patterns
  float veins = 0.0;
  for(float i = 0.0; i < 5.0; i++) {
    float a = i * P / 4.0;
    veins += smoothstep(0.05, 0.0, A(theta - a));
  }

  wing = shape + veins * shape * 0.2;

  return wing;
}

vec2 chaosField(vec2 uv, vec2 mousePos) {
  // Create chaos-based displacement
  vec2 displacement = vec2(0.0);

  for(float i = 1.0; i < 4.0; i++) {
    float scale = pow(2.0, i);
    vec2 offset = vec2(t * 0.1 * i);

    displacement += vec2(fbm(uv * scale + offset), fbm(uv * scale + offset + 100.0)) / scale;
  }

  // Add mouse influence
  vec2 toMouse = mousePos - uv;
  float mouseStrength = exp(-length(toMouse) * 3.0);
  displacement += normalize(toMouse) * mouseStrength * 0.2;

  return displacement;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Apply chaos field displacement
  vec2 displacement = chaosField(uv, mousePos);
  vec2 distortedUV = uv + displacement * 0.2;

  // Create butterfly
  float leftWing = butterflyWing(distortedUV + vec2(0.2, 0.0), t, 2.0);
  float rightWing = butterflyWing(vec2(-distortedUV.x + 0.2, distortedUV.y), -t, 2.0);

  // Create wing colors with iridescence
  vec3 wingColor1 = vec3(0.8, 0.2, 0.5); // Magenta
  vec3 wingColor2 = vec3(0.2, 0.5, 0.8); // Blue

  float iridescence = 0.5 + 0.5 * S(length(distortedUV) * 5.0 - t);
  vec3 wingColor = mix(wingColor1, wingColor2, iridescence);

  // Combine wings
  float butterfly = leftWing + rightWing;

  // Create weather patterns
  vec3 color = vec3(0.0);

  // Add background turbulence
  float turbulence = fbm(distortedUV * 3.0 + t * 0.1);
  vec3 skyColor = mix(vec3(0.2, 0.3, 0.5), // Dark blue
  vec3(0.5, 0.7, 0.9), // Light blue
  turbulence);

  // Add cloud formations influenced by butterfly
  float clouds = 0.0;
  for(float i = 1.0; i < 4.0; i++) {
    vec2 offset = displacement * i;
    clouds += fbm(distortedUV * i + offset + t * 0.05) / i;
  }

  // Create final color composition
  color = mix(skyColor, vec3(1.0), clouds * 0.5);
  color = mix(color, wingColor, butterfly);

  // Add chaos visualization
  float chaos = length(displacement);
  vec3 chaosColor = vec3(1.0, 0.3, 0.0); // Orange
  color += chaosColor * chaos * 0.3;

  // Add mouse interaction effects
  float mouseGlow = exp(-length(uv - mousePos) * 3.0);
  color += vec3(0.8, 0.6, 0.3) * mouseGlow * 0.5;

  // Add subtle animation
  color *= 0.8 + 0.2 * S(t + length(uv));

  return vec4(color, 1.0);
}
