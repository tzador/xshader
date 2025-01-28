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

float fbm(vec3 p) {
  float value = 0.0;
  float amplitude = 0.5;
  float frequency = 1.0;

  for(float i = 0.0; i < 5.0; i++) {
    value += amplitude * noise(p.xy * frequency);
    value += amplitude * noise(p.yz * frequency);
    value += amplitude * noise(p.xz * frequency);
    amplitude *= 0.5;
    frequency *= 2.0;
  }

  return value;
}

mat2 rotate2D(float angle) {
  float c = C(angle);
  float s = S(angle);
  return mat2(c, -s, s, c);
}

float smin(float a, float b, float k) {
  float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
  return mix(b, a, h) - k * h * (1.0 - h);
}

float sdBox(vec3 p, vec3 b) {
  vec3 q = abs(p) - b;
  return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

float crystalSDF(vec3 p, float size) {
  p.xy *= rotate2D(p.z * 0.1 + t);
  float d1 = sdBox(p, vec3(size, size * 0.5, size * 2.0));
  float d2 = sdBox(p.yxz, vec3(size * 0.7, size * 0.3, size * 1.5));
  return smin(d1, d2, 0.1);
}

float caveSDF(vec3 p) {
  float cave = length(p.xy) - 3.0 + fbm(p * 0.5) * 0.5;
  cave = max(cave, -p.z - 5.0); // Floor
  cave = max(cave, p.z - 5.0);  // Ceiling
  return cave;
}

float sceneSDF(vec3 p) {
  float cave = caveSDF(p);

  float crystals = 1e10;
  for(float i = 0.0; i < 8.0; i++) {
    float angle = i * Q / 8.0 + t * 0.1;
    vec3 pos = vec3(2.5 * C(angle), 2.5 * S(angle), 0.0);
    pos.z += S(t + i) * 2.0;

    float crystal = crystalSDF(p - pos, 0.3 + 0.2 * S(i + t));
    crystals = min(crystals, crystal);
  }

  return min(cave, crystals);
}

vec3 getNormal(vec3 p) {
  const float h = 0.001;
  const vec2 k = vec2(1.0, -1.0);
  return normalize(k.xyy * sceneSDF(p + k.xyy * h) +
    k.yyx * sceneSDF(p + k.yyx * h) +
    k.yxy * sceneSDF(p + k.yxy * h) +
    k.xxx * sceneSDF(p + k.xxx * h));
}

float getAO(vec3 p, vec3 n) {
  float ao = 0.0;
  float step = 0.1;

  for(float i = 1.0; i <= 5.0; i++) {
    float dist = step * i;
    ao += max(0.0, (dist - sceneSDF(p + n * dist)) / dist);
  }

  return 1.0 - ao * 0.2;
}

vec3 crystalColor(vec3 p) {
  vec3 col1 = vec3(0.2, 0.8, 0.9);  // Cyan
  vec3 col2 = vec3(0.9, 0.2, 0.8);  // Magenta
  vec3 col3 = vec3(0.8, 0.9, 0.2);  // Yellow

  float f = fbm(p * 2.0 + t);
  vec3 color = mix(col1, col2, f);
  color = mix(color, col3, f * f);

  return color;
}

vec3 render(vec3 ro, vec3 rd) {
  float t = 0.0;
  float maxDist = 20.0;

  // Ray march
  for(int i = 0; i < 100; i++) {
    vec3 p = ro + rd * t;
    float d = sceneSDF(p);

    if(d < 0.001) {
      vec3 normal = getNormal(p);
      float ao = getAO(p, normal);

      // Determine material
      float cave = caveSDF(p);
      vec3 albedo = (cave < 0.1) ? vec3(0.2) + 0.1 * fbm(p) : crystalColor(p);

      // Lighting
      vec3 lightPos = vec3(0.0, 0.0, 3.0);
      vec3 lightDir = normalize(lightPos - p);
      float diff = max(0.0, dot(normal, lightDir));
      float spec = pow(max(0.0, dot(reflect(-lightDir, normal), -rd)), 32.0);

      // Crystal internal scattering
      float scatter = 0.0;
      if(cave > 0.1) {
        for(float i = 0.0; i < 5.0; i++) {
          vec3 scatterPos = p + normal * (0.1 * i);
          scatter += exp(-length(scatterPos - p) * 2.0) * 0.2;
        }
      }

      vec3 color = albedo * (0.2 + 0.8 * diff * ao) +
        vec3(0.5, 0.8, 1.0) * spec * 0.5 +
        albedo * scatter;

      // Fog
      float fog = 1.0 - exp(-t * 0.1);
      vec3 fogColor = vec3(0.1, 0.2, 0.3);
      color = mix(color, fogColor, fog);

      return color;
    }

    if(t > maxDist)
      break;
    t += d;
  }

  // Background
  return vec3(0.1, 0.2, 0.3);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Camera setup
  vec3 ro = vec3(3.0 * C(t * 0.2), 3.0 * S(t * 0.2), 2.0 + mousePos.y);
  vec3 ta = vec3(0.0, 0.0, 0.0);
  vec3 up = vec3(0.0, 0.0, 1.0);

  // Camera matrix
  vec3 ww = normalize(ta - ro);
  vec3 uu = normalize(cross(ww, up));
  vec3 vv = normalize(cross(uu, ww));

  // Ray direction
  vec3 rd = normalize(uv.x * uu + uv.y * vv + 2.0 * ww);

  // Render scene
  vec3 color = render(ro, rd);

  // Tone mapping and gamma correction
  color = color / (color + vec3(1.0));
  color = pow(color, vec3(0.4545));

  return vec4(color, 1.0);
}
