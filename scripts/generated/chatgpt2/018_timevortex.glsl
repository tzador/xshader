float hash(vec2 p) {
  return fract(S(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 rotate(vec2 p, float angle) {
  float c = C(angle);
  float s = S(angle);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float timeDilation(float dist, vec2 mousePos, vec2 uv) {
  // Create time dilation effect based on distance from mouse
  float mouseDist = length(uv - mousePos);
  float dilation = 1.0 / (1.0 + mouseDist * 2.0);
  return mix(1.0, dilation, smoothstep(1.0, 0.0, dist));
}

vec2 vortexDistortion(vec2 uv, float time, float strength) {
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

  // Create spiral distortion
  float spiral = angle + 1.0 / (dist + 0.1) + time;

  return vec2(C(spiral) * dist, S(spiral) * dist) * strength;
}

float timeStream(vec2 uv, float time) {
  float stream = 0.0;

  // Create multiple layers of time streams
  for(float i = 1.0; i < 5.0; i++) {
    float t = time * (1.0 + i * 0.1);
    float angle = i * Q / 4.0 + t;

    vec2 offset = vec2(C(angle), S(angle)) * 0.3;
    float d = length(uv - offset);

    stream += smoothstep(0.1, 0.0, d) * (0.5 + 0.5 * S(d * 10.0 - t * 2.0));
  }

  return stream;
}

vec3 timeColor(float value, float time) {
  // Create temporal color palette
  vec3 past = vec3(0.2, 0.4, 0.8);    // Blue for past
  vec3 present = vec3(0.8, 0.4, 0.2);  // Orange for present
  vec3 future = vec3(0.2, 0.8, 0.4);   // Green for future

  float t1 = fract(value + time * 0.1);
  float t2 = fract(t1 + 0.333);
  float t3 = fract(t2 + 0.333);

  return past * t1 + present * t2 + future * t3;
}

vec4 f() {
  vec2 uv = p * 2.0 - 1.0;
  vec2 mousePos = m * 2.0 - 1.0;

  // Calculate base distance and angle
  float dist = length(uv);
  float angle = atan(uv.y, uv.x);

  // Apply time dilation
  float dilatedTime = t * timeDilation(dist, mousePos, uv);

  // Create vortex distortion
  vec2 distorted = vortexDistortion(uv, dilatedTime, 1.0);

  // Add mouse influence on vortex
  float mouseInfluence = exp(-length(uv - mousePos) * 2.0);
  distorted += vortexDistortion(uv - mousePos, dilatedTime * 2.0, mouseInfluence);

  // Create time streams
  float streams = timeStream(distorted, dilatedTime);

  // Create temporal rifts
  float rifts = 0.0;
  for(float i = 0.0; i < 3.0; i++) {
    float phase = dilatedTime * (1.0 + i * 0.2);
    vec2 riftPos = vec2(C(phase), S(phase)) * 0.5;
    float rift = exp(-length(distorted - riftPos) * 5.0);
    rifts += rift * (0.5 + 0.5 * S(phase * 2.0));
  }

  // Create base color from distorted coordinates
  vec3 color = timeColor(length(distorted) + dilatedTime * 0.1, dilatedTime);

  // Add time streams
  vec3 streamColor = timeColor(streams + dilatedTime * 0.2, dilatedTime);
  color = mix(color, streamColor, streams * 0.7);

  // Add temporal rifts
  vec3 riftColor = timeColor(rifts - dilatedTime * 0.3, -dilatedTime);
  color = mix(color, riftColor, rifts);

  // Add vortex edge effects
  float edge = smoothstep(0.8, 0.4, dist);
  color *= edge;

  // Add time distortion visualization
  float distortion = length(distorted - uv);
  vec3 distortColor = vec3(1.0, 0.5, 0.0);
  color += distortColor * distortion * 0.3;

  // Add mouse interaction effects
  float mouseGlow = exp(-length(uv - mousePos) * 3.0);
  color += vec3(0.5, 0.8, 1.0) * mouseGlow;

  // Add temporal particles
  for(float i = 0.0; i < 20.0; i++) {
    float t_offset = dilatedTime + i * 1234.5678;
    vec2 particlePos = vec2(hash(vec2(i, t_offset)), hash(vec2(t_offset, i))) * 2.0 - 1.0;

    // Apply vortex motion to particles
    particlePos += vortexDistortion(particlePos, dilatedTime * 0.5, 0.2);

    float particle = exp(-length(distorted - particlePos) * 10.0);
    color += timeColor(particle + i * 0.1, dilatedTime) * particle;
  }

  return vec4(color, 1.0);
}
