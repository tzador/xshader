float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

struct Ray {
  vec3 origin;
  vec3 direction;
};

struct Sphere {
  vec3 center;
  float radius;
  vec3 color;
  float metallic;
};

struct Hit {
  float distance;
  vec3 position;
  vec3 normal;
  vec3 color;
  float metallic;
};

float intersectSphere(Ray ray, Sphere sphere) {
  vec3 oc = ray.origin - sphere.center;
  float b = dot(oc, ray.direction);
  float c = dot(oc, oc) - sphere.radius * sphere.radius;
  float h = b * b - c;

  if(h < 0.0)
    return -1.0;
  return -b - sqrt(h);
}

Hit sceneIntersect(Ray ray) {
  Hit hit;
  hit.distance = 1e10;
  hit.metallic = 0.0;

  // Create ground plane
  float d = -(ray.origin.y + 2.0) / ray.direction.y;
  if(d > 0.0 && d < hit.distance) {
    hit.distance = d;
    hit.position = ray.origin + ray.direction * d;
    hit.normal = vec3(0.0, 1.0, 0.0);
    hit.color = vec3(0.2) + 0.1 * mod(floor(hit.position.x) + floor(hit.position.z), 2.0);
    hit.metallic = 0.1;
  }

  // Create multiple spheres
  for(float i = 0.0; i < 5.0; i++) {
    float angle = i * Q / 5.0 + t * (0.2 + i * 0.1);
    float height = 0.5 + 0.3 * S(t * 2.0 + i);

    Sphere sphere;
    sphere.center = vec3(2.0 * C(angle), height, 2.0 * S(angle));
    sphere.radius = 0.5;
    sphere.color = 0.5 + 0.5 * C(i * 2.0 + vec3(0.0, 2.0, 4.0));
    sphere.metallic = 0.8 + 0.2 * S(i + t);

    float d = intersectSphere(ray, sphere);
    if(d > 0.0 && d < hit.distance) {
      hit.distance = d;
      hit.position = ray.origin + ray.direction * d;
      hit.normal = normalize(hit.position - sphere.center);
      hit.color = sphere.color;
      hit.metallic = sphere.metallic;
    }
  }

  return hit;
}

vec3 skyColor(vec3 direction) {
  float sun = max(0.0, dot(direction, normalize(vec3(0.5, 0.5, 0.0))));
  vec3 sky = mix(vec3(0.2, 0.3, 0.5), vec3(0.8, 0.8, 0.9), direction.y * 0.5 + 0.5);
  return sky + vec3(1.0, 0.8, 0.4) * pow(sun, 32.0);
}

vec3 trace(Ray ray, int maxBounces) {
  vec3 color = vec3(0.0);
  vec3 throughput = vec3(1.0);

  for(int bounce = 0; bounce < 3; bounce++) {
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

    // Check if point is in shadow
    Ray shadowRay;
    shadowRay.origin = hit.position + hit.normal * 0.001;
    shadowRay.direction = lightDir;
    Hit shadowHit = sceneIntersect(shadowRay);
    if(shadowHit.distance < 1e10)
      diffuse *= 0.2;

    // Add direct lighting
    vec3 directLight = (0.2 + 0.8 * diffuse) * hit.color;

    // Handle reflection
    if(hit.metallic > 0.0) {
      ray.origin = hit.position + hit.normal * 0.001;
      ray.direction = reflect(ray.direction, hit.normal);
      throughput *= mix(hit.color, vec3(1.0), hit.metallic);
    } else {
      color += throughput * directLight;
      break;
    }
  }

  return color;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create camera
  vec3 cameraPos = vec3(4.0 * C(t * 0.2), 2.0 + mousePos.y, 4.0 * S(t * 0.2));
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
  vec3 color = trace(ray, 3);

  // Tone mapping and gamma correction
  color = color / (color + vec3(1.0));
  color = pow(color, vec3(0.4545));

  return vec4(color, 1.0);
}
