float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  f = f * f * (3.0 - 2.0 * f);

  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));

  return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;
  float frequency = 1.0;
  for(float i = 0.0; i < 5.0; i++) {
    value += amplitude * noise(p * frequency);
    amplitude *= 0.5;
    frequency *= 2.0;
  }
  return value;
}

vec2 rotate2D(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float dnaStrand(vec3 p, float radius, float twist) {
  // Create double helix structure
  float angle = atan(p.y, p.x);
  float r = length(p.xy);

  float helixAngle = angle + p.z * twist;
  float helix1 = length(vec2(r - radius, mod(helixAngle, Q) - P)) - 0.1;
  float helix2 = length(vec2(r - radius, mod(helixAngle + P, Q) - P)) - 0.1;

  // Add base pairs
  float bases = 1e10;
  for(float i = -2.0; i <= 2.0; i++) {
    float z = mod(p.z + i, 1.0) - 0.5;
    float baseAngle = twist * (p.z + i);
    vec2 basePos = vec2(radius * C(baseAngle), radius * S(baseAngle));
    bases = min(bases, length(vec3(p.xy - basePos, z)) - 0.15);
  }

  return min(min(helix1, helix2), bases);
}

float fractalDNA(vec3 p) {
  float d = 1e10;

  // Create multiple scales of DNA
  for(float i = 0.0; i < 3.0; i++) {
    float scale = pow(2.0, -i);
    vec3 q = p * scale;
    q.xy = rotate2D(q.xy, q.z * 0.5 + t * (0.2 + i * 0.1));

    float twist = 5.0 + i * 2.0;
    float strand = dnaStrand(q, 1.0, twist) / scale;
    d = min(d, strand);
  }

  return d;
}

vec3 bioColor(float value, vec3 p) {
  // Create bioluminescent color palette
  vec3 col1 = vec3(0.0, 0.3, 0.6);  // Deep blue
  vec3 col2 = vec3(0.0, 0.8, 0.3);  // Green
  vec3 col3 = vec3(0.6, 0.8, 1.0);  // Light blue

  float f = fbm(p.xy * 2.0 + p.z + t);
  value = fract(value * 2.0 + f * 0.5);

  float t1 = smoothstep(0.0, 0.5, value);
  float t2 = smoothstep(0.5, 1.0, value);

  return mix(mix(col1, col2, t1), col3, t2);
}

float bioluminescence(vec3 p) {
  return fbm(p.xy * 3.0 + t) * fbm(p.yz * 3.0 - t) * fbm(p.xz * 3.0 + t * 0.5);
}

vec3 render(vec3 ro, vec3 rd) {
  vec3 color = vec3(0.0);
  float t = 0.0;

  // Ray march
  for(int i = 0; i < 100; i++) {
    vec3 p = ro + rd * t;
    float d = fractalDNA(p);

    if(d < 0.001) {
      // Calculate normal
      vec2 e = vec2(0.001, 0.0);
      vec3 n = normalize(vec3(fractalDNA(p + e.xyy) - fractalDNA(p - e.xyy), fractalDNA(p + e.yxy) - fractalDNA(p - e.yxy), fractalDNA(p + e.yyx) - fractalDNA(p - e.yyx)));

      // Calculate lighting
      vec3 lightDir = normalize(vec3(1.0, 1.0, -1.0));
      float diff = max(0.0, dot(n, lightDir));
      float spec = pow(max(0.0, dot(reflect(-lightDir, n), -rd)), 32.0);

      // Add bioluminescence
      float bio = bioluminescence(p);

      // Create final color
      vec3 baseColor = bioColor(length(p) * 0.1 + bio, p);
      color = baseColor * (0.2 + 0.8 * diff) + vec3(0.8, 0.9, 1.0) * spec;
      color += baseColor * bio * 2.0;

      // Add depth fade
      float fog = 1.0 - exp(-t * 0.1);
      color = mix(color, vec3(0.0), fog);
      break;
    }

    if(t > 20.0)
      break;
    t += d;
  }

  return color;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create camera
  vec3 ro = vec3(3.0 * C(t * 0.2 + mousePos.x * 2.0), 3.0 * S(t * 0.2 + mousePos.x * 2.0), 2.0 + mousePos.y * 2.0);
  vec3 ta = vec3(0.0, 0.0, 0.0);
  vec3 up = vec3(0.0, 0.0, 1.0);

  // Camera matrix
  vec3 ww = normalize(ta - ro);
  vec3 uu = normalize(cross(ww, up));
  vec3 vv = normalize(cross(uu, ww));

  // Create ray
  vec3 rd = normalize(uv.x * uu + uv.y * vv + 2.0 * ww);

  // Render scene
  vec3 color = render(ro, rd);

  // Add glow
  float glow = exp(-length(uv) * 2.0);
  color += vec3(0.0, 0.3, 0.6) * glow;

  // Tone mapping and gamma correction
  color = color / (color + vec3(1.0));
  color = pow(color, vec3(0.4545));

  return vec4(color, 1.0);
}
