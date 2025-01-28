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

struct Neuron {
  vec3 position;
  float activation;
  float phase;
};

Neuron createNeuron(float index) {
  Neuron n;
  float angle = index * Q / 20.0 + t * 0.1;
  float height = S(t * 0.5 + index) * 2.0;
  float radius = 2.0 + hash(vec2(index)) * 1.0;

  n.position = vec3(radius * C(angle), radius * S(angle), height);

  n.activation = 0.5 + 0.5 * S(t * 2.0 + index * 1234.5);
  n.phase = t * (1.0 + hash(vec2(index)) * 0.5);

  return n;
}

float neuronField(vec3 p, Neuron n) {
  float d = length(p - n.position) - 0.2;
  float pulse = 0.1 * S(n.phase * 10.0) * n.activation;
  return d - pulse;
}

float synapseField(vec3 p, Neuron n1, Neuron n2, float activation) {
  vec3 dir = n2.position - n1.position;
  float len = length(dir);
  dir /= len;

  // Calculate distance to line segment
  vec3 pa = p - n1.position;
  float h = clamp(dot(pa, dir), 0.0, len);
  float d = length(pa - dir * h) - 0.02;

  // Add pulse effect
  float pulse = S(mod(h - t * 2.0, len));
  pulse *= activation * (1.0 - h / len); // Fade along length

  return d - pulse * 0.05;
}

vec3 neuronColor(float activation) {
  // Create neural color palette
  vec3 baseColor = vec3(0.0, 0.5, 1.0);  // Blue
  vec3 activeColor = vec3(0.0, 1.0, 0.5); // Green
  vec3 pulseColor = vec3(1.0, 0.5, 0.0);  // Orange

  vec3 color = mix(baseColor, activeColor, activation);
  color += pulseColor * activation * activation;

  return color;
}

float sceneSDF(vec3 p, out vec3 color) {
  float minDist = 1e10;
  color = vec3(0.0);

  // Create neurons
  Neuron[20] neurons;
  for(int i = 0; i < 20; i++) {
    neurons[i] = createNeuron(float(i));
  }

  // Calculate neuron fields
  for(int i = 0; i < 20; i++) {
    float d = neuronField(p, neurons[i]);
    if(d < minDist) {
      minDist = d;
      color = neuronColor(neurons[i].activation);
    }
  }

  // Calculate synapse fields
  for(int i = 0; i < 20; i++) {
    for(int j = i + 1; j < 20; j++) {
      float dist = length(neurons[i].position - neurons[j].position);
      if(dist < 3.0) { // Only connect nearby neurons
        float activation = neurons[i].activation * neurons[j].activation;
        float d = synapseField(p, neurons[i], neurons[j], activation);
        if(d < minDist) {
          minDist = d;
          color = neuronColor(activation);
        }
      }
    }
  }

  return minDist;
}

vec3 getNormal(vec3 p) {
  vec2 e = vec2(0.001, 0.0);
  vec3 dummy;
  return normalize(vec3(sceneSDF(p + e.xyy, dummy) - sceneSDF(p - e.xyy, dummy), sceneSDF(p + e.yxy, dummy) - sceneSDF(p - e.yxy, dummy), sceneSDF(p + e.yyx, dummy) - sceneSDF(p - e.yyx, dummy)));
}

vec3 render(vec3 ro, vec3 rd) {
  vec3 color = vec3(0.0);
  float t = 0.0;

  // Ray march
  for(int i = 0; i < 100; i++) {
    vec3 p = ro + rd * t;
    vec3 col;
    float d = sceneSDF(p, col);

    if(d < 0.001) {
      vec3 n = getNormal(p);

      // Calculate lighting
      vec3 lightDir = normalize(vec3(1.0, 1.0, -1.0));
      float diff = max(0.0, dot(n, lightDir));
      float spec = pow(max(0.0, dot(reflect(-lightDir, n), -rd)), 32.0);

      // Create final color
      color = col * (0.2 + 0.8 * diff) + vec3(1.0) * spec * 0.5;

      // Add glow
      float glow = exp(-d * 10.0);
      color += col * glow;

      // Add depth fade
      float fog = 1.0 - exp(-t * 0.1);
      color = mix(color, vec3(0.0), fog);
      break;
    }

    // Add volumetric lighting
    float density = exp(-d * 5.0);
    color += col * density * 0.01;

    if(t > 20.0)
      break;
    t += max(0.01, d);
  }

  return color;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Create camera
  vec3 ro = vec3(5.0 * C(t * 0.2 + mousePos.x * 2.0), 5.0 * S(t * 0.2 + mousePos.x * 2.0), 3.0 + mousePos.y * 2.0);
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
  color += vec3(0.0, 0.2, 0.4) * glow;

  // Add neural noise
  color *= 0.8 + 0.2 * fbm(uv * 10.0 + t);

  // Tone mapping and gamma correction
  color = color / (color + vec3(1.0));
  color = pow(color, vec3(0.4545));

  return vec4(color, 1.0);
}
