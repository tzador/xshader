float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 rotate2D(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

vec3 rotateX(vec3 p, float angle) {
  float c = C(angle), s = S(angle);
  return vec3(p.x, c * p.y - s * p.z, s * p.y + c * p.z);
}

vec3 rotateY(vec3 p, float angle) {
  float c = C(angle), s = S(angle);
  return vec3(c * p.x + s * p.z, p.y, -s * p.x + c * p.z);
}

vec3 rotateZ(vec3 p, float angle) {
  float c = C(angle), s = S(angle);
  return vec3(c * p.x - s * p.y, s * p.x + c * p.y, p.z);
}

float hyperbolicDist(vec3 p) {
  float r = length(p);
  return log(r + sqrt(r * r - 1.0));
}

vec3 portalDistortion(vec3 p, float time) {
  // Create hyperbolic distortion
  float dist = hyperbolicDist(p);
  float distortion = S(dist * 2.0 - time);

  // Add rotational warping
  p = rotateX(p, dist * 2.0 + time);
  p = rotateY(p, dist * 1.5 - time * 0.5);
  p = rotateZ(p, dist * 1.0 + time * 0.2);

  // Add non-euclidean twist
  float twist = atan(p.y, p.x) + dist * 2.0;
  p.xy = length(p.xy) * vec2(C(twist), S(twist));

  return p;
}

float portalSDF(vec3 p) {
  // Create portal ring
  float ring = length(vec2(length(p.xy) - 1.5, p.z)) - 0.2;

  // Add portal surface
  float portal = length(p) - 1.0;

  // Combine with smooth minimum
  float k = 0.2;
  float h = clamp(0.5 + 0.5 * (portal - ring) / k, 0.0, 1.0);
  return mix(portal, ring, h) - k * h * (1.0 - h);
}

vec3 portalColor(vec3 p, float d) {
  // Create portal color palette
  vec3 portalCore = vec3(0.2, 0.8, 1.0);    // Cyan
  vec3 portalRim = vec3(1.0, 0.2, 0.8);     // Magenta
  vec3 portalGlow = vec3(0.8, 0.2, 1.0);    // Purple

  // Mix colors based on distance and position
  float core = smoothstep(0.0, 1.0, length(p));
  vec3 color = mix(portalCore, portalRim, core);

  // Add dimensional rifts
  float rift = S(sin(p.x * 5.0 + p.y * 3.0 + p.z * 2.0) * 0.5 + 0.5);
  color = mix(color, portalGlow, rift * 0.5);

  // Add distance-based glow
  float glow = exp(-d * 3.0);
  color += portalGlow * glow;

  return color;
}

float dimensionalRift(vec3 p, float time) {
  // Create dimensional tear effect
  float rift = 0.0;

  for(float i = 0.0; i < 3.0; i++) {
    vec3 q = p;
    q = rotateX(q, time * (0.5 + i * 0.2));
    q = rotateY(q, time * (0.3 + i * 0.1));
    q = rotateZ(q, time * (0.4 + i * 0.15));

    float angle = atan(q.y, q.x) * (3.0 + i);
    float dist = length(q.xy);

    rift += S(sin(angle + dist * 5.0 - time * 2.0) * 0.5 + 0.5) / (1.0 + dist);
  }

  return rift * 0.3;
}

vec3 render(vec3 ro, vec3 rd) {
  vec3 color = vec3(0.0);
  float t = 0.0;

  // Ray march
  for(int i = 0; i < 100; i++) {
    vec3 p = ro + rd * t;

    // Apply hyperdimensional distortion
    vec3 dp = portalDistortion(p, t);
    float d = portalSDF(dp);

    if(d < 0.001) {
      vec3 n = normalize(vec3(portalSDF(dp + vec3(0.001, 0.0, 0.0)) - portalSDF(dp - vec3(0.001, 0.0, 0.0)), portalSDF(dp + vec3(0.0, 0.001, 0.0)) - portalSDF(dp - vec3(0.0, 0.001, 0.0)), portalSDF(dp + vec3(0.0, 0.0, 0.001)) - portalSDF(dp - vec3(0.0, 0.0, 0.001))));

      // Calculate lighting
      vec3 lightDir = normalize(vec3(1.0, 1.0, -1.0));
      float diff = max(0.0, dot(n, lightDir));
      float spec = pow(max(0.0, dot(reflect(-lightDir, n), -rd)), 32.0);

      // Create final color
      color = portalColor(dp, d);
      color = color * (0.2 + 0.8 * diff) + vec3(1.0) * spec * 0.5;

      // Add dimensional rift
      float rift = dimensionalRift(dp, t);
      color += vec3(0.5, 0.2, 1.0) * rift;

      // Add depth fade
      float fog = 1.0 - exp(-t * 0.1);
      color = mix(color, vec3(0.0), fog);
      break;
    }

    // Add volumetric effects
    float rift = dimensionalRift(dp, t);
    color += portalColor(dp, d) * exp(-d * 5.0) * 0.05;
    color += vec3(0.5, 0.2, 1.0) * rift * 0.1;

    if(t > 20.0)
      break;
    t += max(0.01, d * 0.5);
  }

  return color;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create camera
  float camDist = 3.0 + mousePos.y;
  vec3 ro = vec3(camDist * C(t * 0.2 + mousePos.x * 2.0), camDist * S(t * 0.2 + mousePos.x * 2.0), 1.0 + mousePos.y);
  vec3 ta = vec3(0.0, 0.0, 0.0);
  vec3 up = vec3(0.0, 0.0, 1.0);

  // Camera matrix
  vec3 ww = normalize(ta - ro);
  vec3 uu = normalize(cross(ww, up));
  vec3 vv = normalize(cross(uu, ww));

  // Create ray
  vec3 rd = normalize(uv.x * uu + uv.y * vv + 1.5 * ww);

  // Render scene
  vec3 color = render(ro, rd);

  // Add background glow
  float glow = exp(-length(uv) * 1.5);
  color += vec3(0.2, 0.0, 0.4) * glow;

  // Add vignette
  float vignette = 1.0 - length(uv) * 0.5;
  color *= vignette;

  // Tone mapping and gamma correction
  color = color / (color + vec3(1.0));
  color = pow(color, vec3(0.4545));

  return vec4(color, 1.0);
}
