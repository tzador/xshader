float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
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

vec2 powComplex(vec2 z, float n) {
  float r = length(z);
  float theta = atan(z.y, z.x);
  return pow(r, n) * vec2(C(theta * n), S(theta * n));
}

float mandelbulbSDF(vec3 pos) {
  vec3 z = pos;
  float dr = 1.0;
  float r = 0.0;

  // Dynamic parameters based on time and mouse
  float power = 8.0 + S(t * 0.2) * 4.0;
  float iterations = 8.0 + S(t * 0.3) * 4.0;

  for(float i = 0.0; i < 15.0; i++) {
    if(i >= iterations)
      break;

    r = length(z);
    if(r > 2.0)
      break;

    // Convert to polar coordinates
    float theta = acos(z.z / r);
    float phi = atan(z.y, z.x);
    dr = pow(r, power - 1.0) * power * dr + 1.0;

    // Scale and rotate
    float zr = pow(r, power);
    theta = theta * power;
    phi = phi * power;

    // Convert back to cartesian coordinates
    z = zr * vec3(S(theta) * C(phi), S(theta) * S(phi), C(theta));
    z += pos; // Add initial position

    // Apply dynamic rotation
    z = rotateX(z, t * 0.1);
    z = rotateY(z, t * 0.15);
    z = rotateZ(z, t * 0.12);
  }
  return 0.5 * log(r) * r / dr;
}

vec3 mandelbulbColor(vec3 p, float d) {
  // Create base color from position and distance
  vec3 baseColor = 0.5 + 0.5 * C(vec3(atan(p.y, p.x) * 2.0, atan(p.z, length(p.xy)) * 2.0, length(p) * 0.5) + t);

  // Add color variation based on distance
  float colorMix = exp(-d * 10.0);
  vec3 glowColor = vec3(1.0, 0.5, 0.2);

  return mix(baseColor, glowColor, colorMix);
}

vec3 getNormal(vec3 p) {
  vec2 e = vec2(0.001, 0.0);
  return normalize(vec3(mandelbulbSDF(p + e.xyy) - mandelbulbSDF(p - e.xyy), mandelbulbSDF(p + e.yxy) - mandelbulbSDF(p - e.yxy), mandelbulbSDF(p + e.yyx) - mandelbulbSDF(p - e.yyx)));
}

vec3 render(vec3 ro, vec3 rd) {
  vec3 color = vec3(0.0);
  float t = 0.0;

  // Ray march
  for(int i = 0; i < 100; i++) {
    vec3 p = ro + rd * t;
    float d = mandelbulbSDF(p);

    if(d < 0.001) {
      vec3 n = getNormal(p);

      // Calculate lighting
      vec3 lightDir = normalize(vec3(1.0, 1.0, -1.0));
      float diff = max(0.0, dot(n, lightDir));
      float spec = pow(max(0.0, dot(reflect(-lightDir, n), -rd)), 32.0);

      // Create final color
      color = mandelbulbColor(p, d);
      color = color * (0.2 + 0.8 * diff) + vec3(1.0) * spec * 0.5;

      // Add glow
      float glow = exp(-d * 5.0);
      color += mandelbulbColor(p, d * 2.0) * glow;

      // Add depth fade
      float fog = 1.0 - exp(-t * 0.1);
      color = mix(color, vec3(0.0), fog);
      break;
    }

    // Add volumetric effects
    float density = exp(-d * 8.0);
    color += mandelbulbColor(p, d) * density * 0.05;

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
  float camDist = 2.5 + mousePos.y;
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
  float glow = exp(-length(uv) * 2.0);
  color += vec3(0.1, 0.2, 0.4) * glow;

  // Tone mapping and gamma correction
  color = color / (color + vec3(1.0));
  color = pow(color, vec3(0.4545));

  return vec4(color, 1.0);
}
