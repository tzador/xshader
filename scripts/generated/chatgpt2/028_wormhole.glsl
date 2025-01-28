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

vec2 rotate2D(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float schwarzschildRadius(float mass) {
  return 2.0 * mass;
}

vec3 gravitationalLensing(Ray ray, vec3 blackHolePos, float mass) {
  vec3 dir = ray.direction;
  vec3 delta = blackHolePos - ray.origin;
  float a = dot(dir, dir);
  float b = 2.0 * dot(delta, dir);
  float c = dot(delta, delta);
  float rs = schwarzschildRadius(mass);

  // Calculate gravitational influence
  float d = length(delta);
  float force = mass / (d * d);

  // Bend light towards black hole
  vec3 perpendicular = normalize(cross(dir, delta));
  vec3 towards = normalize(delta - dot(delta, dir) * dir);
  float bend = force * (1.0 - exp(-d / rs));

  return normalize(dir + towards * bend);
}

vec3 wormholeColor(vec3 p, float time) {
  // Create space nebula colors
  vec3 col1 = vec3(0.5, 0.0, 1.0);  // Purple
  vec3 col2 = vec3(0.0, 0.5, 1.0);  // Blue
  vec3 col3 = vec3(1.0, 0.5, 0.0);  // Orange

  float f = fbm(p.xy * 0.5 + time) * fbm(p.yz * 0.5 - time);
  vec3 color = mix(col1, col2, f);
  color = mix(color, col3, f * f);

  return color;
}

vec3 starField(vec3 dir, float time) {
  vec2 uv = vec2(atan(dir.x, dir.z), asin(dir.y));

  float stars = 0.0;
  for(float i = 0.0; i < 3.0; i++) {
    vec2 gridUV = uv * (10.0 + i * 20.0);
    vec2 id = floor(gridUV);
    vec2 gv = fract(gridUV) - 0.5;

    float star = step(0.98, hash(id + i * 1234.5));
    star *= smoothstep(0.5, 0.2, length(gv));
    star *= 0.5 + 0.5 * S(time * 2.0 + hash(id) * 10.0);

    stars += star;
  }

  return vec3(stars);
}

vec3 trace(Ray ray) {
  vec3 color = vec3(0.0);
  vec3 throughput = vec3(1.0);

  // Wormhole parameters
  vec3 entrance = vec3(0.0, 0.0, -5.0);
  vec3 exit = vec3(0.0, 0.0, 5.0);
  float mass = 2.0;

  // Space-time distortion
  for(int i = 0; i < 100; i++) {
    // Calculate distance to wormhole entrance and exit
    float distEntrance = length(ray.origin - entrance);
    float distExit = length(ray.origin - exit);

    // Apply gravitational lensing from both ends
    ray.direction = gravitationalLensing(ray, entrance, mass);
    ray.direction = gravitationalLensing(ray, exit, mass);

    // Calculate wormhole influence
    float wormholeEffect = exp(-distEntrance * 0.5) + exp(-distExit * 0.5);

    // Add color contribution
    vec3 spaceColor = starField(ray.direction, t);
    vec3 wormholeCol = wormholeColor(ray.origin, t);

    color += throughput * mix(spaceColor, wormholeCol, wormholeEffect) * 0.1;

    // Update ray position
    ray.origin += ray.direction * 0.1;

    // Reduce throughput
    throughput *= 0.95;

    // Break if throughput is too low
    if(length(throughput) < 0.01)
      break;
  }

  return color;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create camera
  vec3 cameraPos = vec3(3.0 * mousePos.x, 3.0 * mousePos.y, -10.0);
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

  // Add camera rotation
  float camAngle = t * 0.2;
  ray.direction.xy = rotate2D(ray.direction.xy, camAngle);

  // Trace scene
  vec3 color = trace(ray);

  // Add glow around wormhole
  float dist = length(uv);
  float glow = exp(-dist * 2.0);
  color += vec3(0.2, 0.4, 1.0) * glow;

  // Add chromatic aberration
  float aberration = 0.02;
  vec3 colorR = trace(Ray(ray.origin, normalize(ray.direction + right * aberration)));
  vec3 colorB = trace(Ray(ray.origin, normalize(ray.direction - right * aberration)));
  color = vec3(colorR.r, color.g, colorB.b);

  // Add time distortion effect
  float timeDist = S(t + dist * 5.0);
  color *= 0.8 + 0.2 * timeDist;

  // Tone mapping and gamma correction
  color = color / (color + vec3(1.0));
  color = pow(color, vec3(0.4545));

  return vec4(color, 1.0);
}
