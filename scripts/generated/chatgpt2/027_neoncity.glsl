float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

struct Ray {
  vec3 origin;
  vec3 direction;
};

struct Hit {
  float distance;
  vec3 position;
  vec3 normal;
  vec3 color;
  float emission;
  float metallic;
};

float sdBox(vec3 p, vec3 b) {
  vec3 q = abs(p) - b;
  return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

float sdCylinder(vec3 p, float h, float r) {
  vec2 d = abs(vec2(length(p.xz), p.y)) - vec2(r, h);
  return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
}

vec3 neonColor(float value) {
  // Create cyberpunk color palette
  vec3 col1 = vec3(1.0, 0.0, 0.5);  // Hot pink
  vec3 col2 = vec3(0.0, 1.0, 1.0);  // Cyan
  vec3 col3 = vec3(0.5, 0.0, 1.0);  // Purple

  value = fract(value * 3.0);
  float t1 = smoothstep(0.0, 0.5, value);
  float t2 = smoothstep(0.5, 1.0, value);

  return mix(mix(col1, col2, t1), col3, t2);
}

float buildingSDF(vec3 p, float seed) {
  // Create random building dimensions
  float height = 2.0 + hash(vec2(seed, 0.0)) * 4.0;
  vec2 size = vec2(0.5 + hash(vec2(seed, 1.0)) * 0.5, 0.5 + hash(vec2(seed, 2.0)) * 0.5);

  // Create basic building shape
  float building = sdBox(p, vec3(size.x, height, size.y));

  // Add windows
  vec3 q = p;
  q.y = mod(q.y, 0.3) - 0.15;
  q.x = mod(q.x, 0.3) - 0.15;
  float windows = sdBox(q, vec3(0.1, 0.1, 0.0));

  return max(building, -windows);
}

float citySDF(vec3 p, out vec3 color, out float emission) {
  float minDist = 1e10;
  color = vec3(0.1);
  emission = 0.0;

  // Create grid of buildings
  for(float i = -5.0; i < 5.0; i++) {
    for(float j = -5.0; j < 5.0; j++) {
      vec3 offset = vec3(i * 2.0, 0.0, j * 2.0);
      vec3 q = p - offset;

      float building = buildingSDF(q, dot(offset.xz, vec2(127.1, 311.7)));

      if(building < minDist) {
        minDist = building;
        // Add random neon signs
        if(hash(offset.xz) > 0.7) {
          color = neonColor(hash(offset.xz + 1234.5));
          emission = 2.0;
        }
      }
    }
  }

  // Add ground plane
  float ground = p.y + 0.0;
  if(ground < minDist) {
    minDist = ground;
    color = vec3(0.02);
    emission = 0.0;
  }

  return minDist;
}

vec3 getNormal(vec3 p) {
  const float h = 0.001;
  const vec2 k = vec2(1.0, -1.0);
  vec3 col;
  float em;
  return normalize(k.xyy * citySDF(p + k.xyy * h, col, em) +
    k.yyx * citySDF(p + k.yyx * h, col, em) +
    k.yxy * citySDF(p + k.yxy * h, col, em) +
    k.xxx * citySDF(p + k.xxx * h, col, em));
}

Hit sceneIntersect(Ray ray) {
  Hit hit;
  hit.distance = 1e10;
  hit.emission = 0.0;
  hit.metallic = 0.0;

  float t = 0.0;
  for(int i = 0; i < 100; i++) {
    vec3 p = ray.origin + ray.direction * t;
    vec3 col;
    float em;
    float d = citySDF(p, col, em);

    if(d < 0.001) {
      hit.distance = t;
      hit.position = p;
      hit.normal = getNormal(p);
      hit.color = col;
      hit.emission = em;
      break;
    }

    if(t > 100.0)
      break;
    t += d;
  }

  return hit;
}

vec3 skyColor(vec3 direction) {
  return mix(vec3(0.02), vec3(0.1), direction.y * 0.5 + 0.5);
}

float getRain(vec3 p) {
  p.y = mod(p.y - t * 2.0, 20.0) - 10.0;
  vec2 id = floor(p.xz);
  float rainDrop = step(0.95, hash(id));
  return rainDrop * smoothstep(0.1, 0.0, length(vec2(p.x - id.x - 0.5, p.z - id.y - 0.5)));
}

vec3 trace(Ray ray) {
  vec3 color = vec3(0.0);
  vec3 throughput = vec3(1.0);

  for(int bounce = 0; bounce < 3; bounce++) {
    Hit hit = sceneIntersect(ray);

    if(hit.distance == 1e10) {
      color += throughput * skyColor(ray.direction);
      break;
    }

    // Add rain effect
    float rain = 0.0;
    for(float i = 0.0; i < 10.0; i++) {
      float depth = i * 0.2;
      vec3 rainPos = ray.origin + ray.direction * depth;
      rain += getRain(rainPos) * exp(-depth);
    }
    color += throughput * vec3(0.5, 0.7, 1.0) * rain * 0.2;

    // Add emissive lighting
    color += throughput * hit.color * hit.emission;

    // Calculate reflection
    vec3 reflectDir = reflect(ray.direction, hit.normal);
    float fresnel = pow(1.0 - abs(dot(hit.normal, -ray.direction)), 5.0);

    // Update ray for next bounce
    ray.origin = hit.position + hit.normal * 0.001;
    ray.direction = reflectDir;

    // Update throughput
    throughput *= mix(hit.color, vec3(1.0), fresnel * 0.5);
  }

  return color;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create camera
  vec3 cameraPos = vec3(10.0 * C(t * 0.1 + mousePos.x), 5.0 + mousePos.y * 2.0, 10.0 * S(t * 0.1 + mousePos.x));
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
  vec3 color = trace(ray);

  // Add fog
  float fogAmount = 1.0 - exp(-length(cameraPos) * 0.05);
  color = mix(color, vec3(0.02), fogAmount);

  // Add screen effects
  color *= 0.8 + 0.2 * hash(uv + t); // Film grain
  color *= 0.8 + 0.2 * smoothstep(0.4, 0.6, fract(uv.y * 100.0)); // Scan lines

  // Tone mapping and gamma correction
  color = color / (color + vec3(1.0));
  color = pow(color, vec3(0.4545));

  return vec4(color, 1.0);
}
