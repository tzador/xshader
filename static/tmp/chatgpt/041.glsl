vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float interference(vec2 uv, float phase) {
  float pattern = 0.0;

  // Create multiple wave sources
  for(float i = 0.0; i < 3.0; i++) {
    float angle = Q * i / 3.0 + phase;
    vec2 dir = vec2(C(angle), S(angle));
    pattern += 0.5 + 0.5 * S(dot(uv, dir) * 20.0);
  }

  return pattern / 3.0;
}

vec3 holographic(float pattern, float brightness) {
  // Create rainbow spectrum
  vec3 color = vec3(0.5 + 0.5 * S(pattern * 5.0), 0.5 + 0.5 * S(pattern * 5.0 + Q / 3.0), 0.5 + 0.5 * S(pattern * 5.0 + Q * 2.0 / 3.0));

  // Add metallic sheen
  color = mix(color, vec3(1.0), pow(brightness, 3.0));

  return color;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Create time-based animation
  float time = t * 0.5;

  // Create rotating coordinate system
  vec2 rotUV = rotate(uv, time * 0.1);

  // Create interference pattern
  float pattern1 = interference(rotUV, time);
  float pattern2 = interference(rotUV * 1.5, -time * 0.7);
  float pattern3 = interference(rotUV * 0.5, time * 0.3);

  float finalPattern = (pattern1 + pattern2 + pattern3) / 3.0;

  // Add mouse interaction
  vec2 mouseUV = uv - (m * 2.0 - 1.0);
  float mouseDist = length(mouseUV);
  float mousePattern = interference(rotate(mouseUV, atan(mouseUV.y, mouseUV.x)), time * 2.0);
  finalPattern = mix(finalPattern, mousePattern, smoothstep(0.5, 0.0, mouseDist));

  // Create holographic color
  float brightness = pow(finalPattern, 2.0);
  vec3 color = holographic(finalPattern, brightness);

  // Add scanlines
  float scanline = 0.9 + 0.1 * S(uv.y * 100.0 + time * 5.0);
  color *= scanline;

  // Add glitch effect
  float glitch = step(0.98, S(time * 10.0));
  color = mix(color, color.gbr, glitch);

  // Add edge glow
  float edge = length(vec2(dFdx(finalPattern), dFdy(finalPattern)));
  color += vec3(0.5, 0.8, 1.0) * edge * 2.0;

  // Add vignette
  float vignette = 1.0 - length(uv) * 0.5;
  color *= vignette;

  // Add transparency based on pattern
  float alpha = smoothstep(0.1, 0.3, brightness);

  return vec4(color, alpha);
}
