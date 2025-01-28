float hash(float n) {
  return fract(S(n) * 43758.5453123);
}

vec2 hash2(float n) {
  return vec2(hash(n), hash(n + 1.234));
}

float star(vec2 uv, float flare) {
  float d = length(uv);
  float m = 0.02 / d;

  float rays = max(0.0, 1.0 - abs(uv.x * uv.y * 1000.0));
  m += rays * flare;

  return m;
}

vec2 warpSpace(vec2 uv, float time) {
  // Create spiral warp
  float angle = atan(uv.y, uv.x);
  float dist = length(uv);

  float warp = S(dist * 3.0 - time);
  angle += dist * warp;

  return vec2(dist * C(angle), dist * S(angle));
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  uv.x *= 1.5;

  // Create time-based animation
  float time = t * 0.5;

  // Warp space
  vec2 warpedUV = warpSpace(uv, time);

  // Create starfield
  vec3 color = vec3(0.0);
  for(float i = 0.0; i < 100.0; i++) {
    // Create star position
    vec2 pos = hash2(i) * 2.0 - 1.0;
    pos.x *= 1.5;

    // Calculate star properties
    float size = hash(i + 1.0) * 0.04 + 0.02;
    float speed = (0.2 + 0.8 * hash(i + 2.0)) * time;

    // Move and warp star position
    pos = warpSpace(pos, speed * 0.5);

    // Create star
    float flare = smoothstep(0.5, 1.0, S(time * 5.0 + i));
    vec3 starColor = mix(vec3(1.0, 0.8, 0.4), vec3(0.4, 0.8, 1.0), hash(i + 3.0));

    color += starColor * star(warpedUV - pos, flare) * size;
  }

  // Add nebula background
  float nebula = 0.5 + 0.5 * S(length(warpedUV) * 3.0 + time);
  vec3 nebulaColor = mix(vec3(0.2, 0.0, 0.4), vec3(0.0, 0.2, 0.4), nebula);
  color += nebulaColor * 0.2;

  // Add motion blur
  float blur = smoothstep(0.0, 1.0, length(uv));
  color = mix(color, vec3(0.0), blur * 0.5);

  // Add color aberration
  float aberration = 0.02 * smoothstep(0.0, 1.0, length(uv));
  color.r = mix(color.r, texture(buf_in, p + vec2(aberration, 0.0)).r, 0.5);
  color.b = mix(color.b, texture(buf_in, p - vec2(aberration, 0.0)).b, 0.5);

  return vec4(color, 1.0);
}
