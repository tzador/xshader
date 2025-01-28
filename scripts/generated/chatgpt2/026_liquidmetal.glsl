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

struct Ray {
  vec3 origin;
  vec3 direction;
};

struct Hit {
  float distance;
  vec3 position;
  vec3 normal;
  float metallic;
};

float smin(float a, float b, float k) {
  float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
  return mix(b, a, h) - k * h * (1.0 - h);
}

float liquidMetalSDF(vec3 p) {
  // Create base pool of liquid metal
  float base = p.y + 1.0;

  // Add waves and ripples
  vec2 uv = p.xz;
  float waves = 0.0;

  for(float i = 1.0; i < 4.0; i++) {
    float speed = t * (0.5 + i * 0.1);
    vec2 offset = vec2(C(speed), S(speed)) * i;
    waves += fbm((uv + offset) * (1.0 + i * 0.5)) * (0.2 / i);
  }

  // Add mouse interaction ripples
  vec2 mousePos = m * 4.0 - 2.0;
  float mouseRipple = length(uv - mousePos);
  waves += 0.2 * exp(-mouseRipple * 2.0) * S(mouseRipple * 5.0 - t * 10.0);

  base -= waves;

  // Add droplets
  float droplets = 1e10;
  for(float i = 0.0; i < 10.0; i++) {
    float t_offset = t + i * 1234.5678;
    vec2 pos = vec2(hash(vec2(i, t_offset)), hash(vec2(t_offset, i))) * 4.0 - 2.0;

    float height = 1.0 + hash(vec2(i, 0.0)) * 2.0;
    vec3 dropletPos = vec3(pos.x, height + S(t * 2.0 + i) * 0.5, pos.y);
    float droplet = length(p - dropletPos) - 0.1;
    droplets = smin(droplets, droplet, 0.1);
  }

  return smin(base, droplets, 0.2);
}

Hit sceneIntersect(Ray ray) {
  Hit hit;
  hit.distance = 1e10;
  hit.metallic = 1.0;

  float t = 0.0;
  for(int i = 0; i < 100; i++) {
    vec3 p = ray.origin + ray.direction * t;
    float d = liquidMetalSDF(p);

    if(d < 0.001) {
      hit.distance = t;
      hit.position = p;

      // Calculate normal using central differences
      vec2 e = vec2(0.001, 0.0);
      vec3 n = normalize(vec3(liquidMetalSDF(p + e.xyy) - liquidMetalSDF(p - e.xyy), liquidMetalSDF(p + e.yxy) - liquidMetalSDF(p - e.yxy), liquidMetalSDF(p + e.yyx) - liquidMetalSDF(p - e.yyx)));

      hit.normal = n;
      break;
    }

    if(t > 20.0)
      break;
    t += d;
  }

  // Add ground plane
  float d = -(ray.origin.y + 2.0) / ray.direction.y;
  if(d > 0.0 && d < hit.distance) {
    hit.distance = d;
    hit.position = ray.origin + ray.direction * d;
    hit.normal = vec3(0.0, 1.0, 0.0);
    hit.metallic = 0.0;
  }

  return hit;
}

vec3 skyColor(vec3 direction) {
  vec3 col1 = vec3(0.2, 0.3, 0.5);
  vec3 col2 = vec3(0.8, 0.8, 0.9);
  float sun = max(0.0, dot(direction, normalize(vec3(0.5, 0.5, 0.0))));
  vec3 sky = mix(col1, col2, direction.y * 0.5 + 0.5);
  return sky + vec3(1.0, 0.8, 0.4) * pow(sun, 32.0);
}

vec3 trace(Ray ray, int maxBounces) {
  vec3 color = vec3(0.0);
  vec3 throughput = vec3(1.0);

  for(int bounce = 0; bounce < 5; bounce++) {
    if(bounce >= maxBounces)
      break;

    Hit hit = sceneIntersect(ray);

    if(hit.distance == 1e10) {
      color += throughput * skyColor(ray.direction);
      break;
    }

    // Calculate lighting
    vec3 lightDir = normalize(vec3(0.5, 0.5, 0.0));
    float diffuse = max(0.0, dot(hit.normal, lightDir));

    if(hit.metallic > 0.0) {
      // Perfect reflection for liquid metal
      ray.origin = hit.position + hit.normal * 0.001;
      ray.direction = reflect(ray.direction, hit.normal);

      // Add slight color tint to the metal
      throughput *= vec3(0.9, 0.9, 1.0);
    } else {
      // Diffuse ground
      vec3 albedo = vec3(0.2) + 0.1 * mod(floor(hit.position.x) + floor(hit.position.z), 2.0);
      color += throughput * albedo * (0.2 + 0.8 * diffuse);
      break;
    }
  }

  return color;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create camera
  vec3 cameraPos = vec3(4.0 * C(t * 0.2), 3.0 + mousePos.y, 4.0 * S(t * 0.2));
  vec3 lookAt = vec3(0.0, 0.0, 0.0);
  vec3 up = vec3(0.0, 1.0, 0.0);

  // Camera coordinate system
  vec3 forward = normalize(lookAt - cameraPos);
  vec3 right = normalize(cross(forward, up));
  vec3 camUp = cross(right, forward);

  // Create ray
  Ray ray;
  ray.origin = cameraPos;
  ray.direction = normalize(forward + right * uv.x + camUp * uv.y);

  // Trace scene
  vec3 color = trace(ray, 5);

  // Tone mapping and gamma correction
  color = color / (color + vec3(1.0));
  color = pow(color, vec3(0.4545));

  return vec4(color, 1.0);
}
