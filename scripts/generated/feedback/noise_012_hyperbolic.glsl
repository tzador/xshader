// Hyperbolic Electromagnetic Field Visualization
// Creates complex patterns in hyperbolic space with chaotic attractors

// Complex number operations
vec2 cmul(vec2 a, vec2 b) {
  return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

vec2 cdiv(vec2 a, vec2 b) {
  float denom = dot(b, b);
  return vec2(dot(a, b), a.y * b.x - a.x * b.y) / denom;
}

vec2 cexp(vec2 z) {
  return exp(z.x) * vec2(cos(z.y), sin(z.y));
}

// Simplex noise function
vec3 permute(vec3 x) {
  return mod(((x * 34.0) + 1.0) * x, 289.0);
}

float snoise(vec2 v) {
  const vec4 C = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);
  vec2 i = floor(v + dot(v, C.yy));
  vec2 x0 = v - i + dot(i, C.xx);
  vec2 i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0)) + i.x + vec3(0.0, i1.x, 1.0));
  vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
  m = m * m;
  m = m * m;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);
  vec3 g;
  g.x = a0.x * x0.x + h.x * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

// Hyperbolic transformations
vec2 mobius(vec2 z, vec2 a, vec2 b, vec2 c, vec2 d) {
  vec2 num = cmul(a, z) + b;
  vec2 den = cmul(c, z) + d;
  return cdiv(num, den);
}

vec2 poincare_to_klein(vec2 z) {
  float d = 1.0 + dot(z, z);
  return 2.0 * z / d;
}

vec2 klein_to_poincare(vec2 z) {
  float d = sqrt(1.0 - dot(z, z));
  return z / (1.0 + d);
}

// Electromagnetic field simulation
vec2 magnetic_field(vec2 pos, vec2 charge_pos, float charge) {
  vec2 r = pos - charge_pos;
  float d2 = dot(r, r);
  return vec2(-r.y, r.x) * charge / (d2 * sqrt(d2 + 0.001));
}

// Chaotic attractor
vec2 attractor(vec2 z) {
  float a = 2.0 + sin(t * 0.1);
  float b = 0.6 + cos(t * 0.15);
  return vec2(sin(a * z.y) - cos(b * z.x), sin(b * z.x) - cos(a * z.y));
}

vec4 f() {
    // System parameters
  float fadeRate = 0.97;
  float timeScale = 0.2;
  float fieldStrength = 2.0;
  float attractorScale = 1.5;

    // Center and transform coordinates
  vec2 center = vec2(0.5);
  vec2 pos = (p - center) * 2.0;

    // Transform to hyperbolic space (Poincaré disk model)
  vec2 hyperbolic_pos = pos;
  float disk_radius = length(pos);

    // Apply Möbius transformation if inside unit disk
  if(disk_radius < 1.0) {
    vec2 a = vec2(cos(t * 0.1), sin(t * 0.2));
    vec2 b = vec2(0.0, 0.0);
    vec2 c = vec2(-sin(t * 0.15), cos(t * 0.1)) * 0.2;
    vec2 d = vec2(1.0, 0.0);
    hyperbolic_pos = mobius(pos, a, b, c, d);
  }

    // Create electromagnetic field
  vec2 field = vec2(0.0);
  const int NUM_CHARGES = 4;
  for(int i = 0; i < NUM_CHARGES; i++) {
    float angle = float(i) * 3.14159 * 0.5 + t * 0.2;
    vec2 charge_pos = vec2(cos(angle), sin(angle)) * 0.5;
    float charge = sin(t * 0.3 + float(i));
    field += magnetic_field(hyperbolic_pos, charge_pos, charge);
  }

    // Create field lines
  float fieldIntensity = length(field);
  float fieldAngle = atan(field.y, field.x);

    // Transform through Klein disk for additional distortion
  vec2 klein_pos = poincare_to_klein(hyperbolic_pos);
  vec2 distorted_pos = klein_to_poincare(klein_pos + field * 0.1);

    // Create base pattern
  float pattern = snoise(distorted_pos * 3.0 + t * timeScale);
  pattern += 0.5 * snoise(distorted_pos * 6.0 - t * timeScale);

    // Create electromagnetic visualization
  vec4 emColor = vec4(0.5 + 0.5 * sin(fieldAngle * 3.0 + t), 0.5 + 0.5 * cos(fieldAngle * 2.0 - t), 0.5 + 0.5 * sin(fieldIntensity * 4.0 + t * 0.7), 1.0);

    // Add hyperbolic tessellation
  float tess = fract(atan(hyperbolic_pos.y, hyperbolic_pos.x) * 4.0 / 3.14159);
  vec4 tessColor = vec4(tess * sin(t * 2.0), tess * cos(t * 1.5), tess, 1.0) * (1.0 - disk_radius);

    // Sample previous frame with field-based movement
  vec2 offset = field * 0.001;
  vec4 previous = texture2D(b, p - offset) * fadeRate;

    // Add geometric patterns
  float geo = sin(dot(hyperbolic_pos, field) * 10.0 + t);
  vec4 geoColor = vec4(0.5 + 0.5 * sin(geo * 6.0 + t), 0.5 + 0.5 * cos(geo * 4.0 - t), 0.5 + 0.5 * sin(geo * 2.0 + t * 0.3), 1.0);

    // Combine everything with sophisticated blending
  vec4 current = emColor * 0.3 + tessColor * 0.3 + geoColor * 0.4;
  current *= smoothstep(1.0, 0.8, disk_radius); // Fade at boundary
  current += pattern * 0.1;

    // Add boundary glow
  float edge = smoothstep(0.8, 1.0, disk_radius);
  current += vec4(0.3, 0.5, 0.7, 1.0) * edge * (1.0 + 0.5 * sin(t * 2.0));

  return max(current, previous);
}
