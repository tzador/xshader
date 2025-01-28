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

vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float tentacle(vec2 uv, vec2 pos, float angle, float length, float width) {
  // Transform space to tentacle's coordinate system
  vec2 p = uv - pos;
  p = rotate(p, angle);

  // Create main tentacle shape
  float d = length(p);
  float a = atan(p.y, p.x);

  // Add wavey movement
  float wave = S(a * 3.0 + t * 2.0) * 0.1;
  float r = length + wave;

  // Create tentacle segment
  float tentacle = smoothstep(width, 0.0, A(p.x)) *
    smoothstep(r, r - width * 2.0, p.y) *
    smoothstep(-r, -r + width * 2.0, p.y);

  // Add suction cups
  float cups = 0.0;
  for(float i = 0.0; i < 10.0; i++) {
    float y = mix(-r, r, i / 9.0);
    vec2 cupPos = vec2(width * 0.5, y);
    cups += smoothstep(width * 0.2, 0.0, length(p - cupPos));
  }

  return tentacle + cups * 0.5;
}

vec3 bioluminescence(float intensity, vec3 baseColor) {
  // Add pulsing glow
  float pulse = 0.5 + 0.5 * S(t * 2.0);
  vec3 glowColor = baseColor * 2.0;
  return mix(baseColor, glowColor, intensity * pulse);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create multiple tentacles
  float tentacles = 0.0;
  vec3 color = vec3(0.0);

  for(float i = 0.0; i < 8.0; i++) {
    // Calculate tentacle parameters
    float angle = i * Q / 8.0 + t * 0.2;
    float length = 0.4 + 0.2 * S(t + i);
    float width = 0.05 + 0.02 * C(t * 2.0 + i);

    // Calculate tentacle position
    vec2 basePos = vec2(C(angle), S(angle)) * 0.2;

    // Add mouse interaction
    vec2 targetDir = mousePos - basePos;
    float targetAngle = atan(targetDir.y, targetDir.x);
    float finalAngle = mix(angle, targetAngle, 0.5 + 0.5 * S(t + i));

    // Create tentacle
    float tent = tentacle(uv, basePos, finalAngle, length, width);
    tentacles += tent;

    // Add different colors for each tentacle
    vec3 tentColor = vec3(0.2 + 0.8 * S(i * 0.7), 0.2 + 0.8 * S(i * 0.7 + Q / 3.0), 0.2 + 0.8 * S(i * 0.7 + Q * 2.0 / 3.0));

    color += bioluminescence(tent, tentColor);
  }

  // Add ambient glow
  float glow = exp(-length(uv) * 2.0);
  color += vec3(0.1, 0.2, 0.3) * glow;

  // Add mouse proximity effect
  float mouseGlow = exp(-length(uv - mousePos) * 4.0);
  color += vec3(0.2, 0.4, 0.8) * mouseGlow;

  // Add subtle noise texture
  color *= 0.8 + 0.2 * noise(uv * 10.0 + t);

  return vec4(color, 1.0);
}
