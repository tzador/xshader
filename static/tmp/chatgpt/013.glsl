float hash(vec2 p) {
  vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
  p3 += dot(p3, p3.yxz + 19.19);
  return fract((p3.x + p3.y) * p3.z);
}

float smoothNoise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  f = f * f * (3.0 - 2.0 * f);

  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));

  return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float getCellState(vec2 pos) {
  float scale = 16.0;
  vec2 cell = floor(pos * scale);
  float time = floor(t * 2.0);

  // Get states of neighboring cells
  float self = smoothNoise(cell * 0.1 + time);
  float n1 = smoothNoise((cell + vec2(1.0, 0.0)) * 0.1 + time);
  float n2 = smoothNoise((cell + vec2(-1.0, 0.0)) * 0.1 + time);
  float n3 = smoothNoise((cell + vec2(0.0, 1.0)) * 0.1 + time);
  float n4 = smoothNoise((cell + vec2(0.0, -1.0)) * 0.1 + time);

  // Apply cellular automaton rules
  float sum = n1 + n2 + n3 + n4;
  float nextState = step(1.8, sum) * step(sum, 2.8) +
    step(2.8, sum) * step(sum, 3.2) * self;

  // Smooth transition between states
  float transition = fract(t * 2.0);
  return mix(self, nextState, transition);
}

vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;

  // Add some movement based on time
  uv += vec2(S(t * 0.5), C(t * 0.4)) * 0.1;

  // Get cell state with some smooth interpolation
  float state = getCellState(uv);

  // Create a more organic look with some noise
  float noise = smoothNoise(uv * 10.0 + t);
  state = mix(state, noise, 0.2);

  // Generate colors based on state and position
  vec3 color = hsv2rgb(vec3(state * 0.5 + t * 0.1, 0.8, state));

  // Add some glow effect
  float glow = exp(-length(uv) * 0.8);
  color += vec3(0.1, 0.2, 0.3) * glow;

  return vec4(color, 1.0);
}
