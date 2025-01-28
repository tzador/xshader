// Evolving Terrain with Simplex Noise
// Creates dynamic landscape with height-based coloring

// Simplex noise function
vec3 permute(vec3 x) {
  return mod(((x * 34.0) + 1.0) * x, 289.0);
}

float snoise(vec2 v) {
  const vec4 C = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);
  vec2 i = floor(v + dot(v, C.yy));
  vec2 x0 = v - i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
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

// Fractal Brownian Motion
float fbm(vec2 pos) {
  float value = 0.0;
  float amplitude = 0.5;
  float frequency = 1.0;

  for(int i = 0; i < 6; i++) {
    value += amplitude * snoise(pos * frequency);
    amplitude *= 0.5;
    frequency *= 2.0;
  }

  return value;
}

vec4 f() {
    // Terrain parameters
  float scale = 4.0;
  float speed = 0.1;
  float fadeRate = 0.95;

    // Generate base terrain
  vec2 terrainPos = p * scale;
  float height = fbm(terrainPos + vec2(t * speed));

    // Add erosion effect using feedback
  vec4 previous = texture2D(b, p + vec2(height * 0.01));
  float erosion = previous.r * 0.1;
  height = mix(height, height - erosion, 0.3);

    // Create terrain color based on height
  vec4 terrainColor;
  if(height < -0.2) {
        // Deep water
    terrainColor = vec4(0.1, 0.2, 0.4, 1.0);
  } else if(height < 0.0) {
        // Shallow water
    terrainColor = vec4(0.2, 0.3, 0.5, 1.0);
  } else if(height < 0.2) {
        // Beach
    terrainColor = vec4(0.8, 0.7, 0.4, 1.0);
  } else if(height < 0.4) {
        // Grass
    terrainColor = vec4(0.3, 0.5, 0.2, 1.0);
  } else if(height < 0.6) {
        // Rock
    terrainColor = vec4(0.5, 0.5, 0.5, 1.0);
  } else {
        // Snow
    terrainColor = vec4(0.9, 0.9, 0.9, 1.0);
  }

    // Add detail noise
  float detail = snoise(terrainPos * 10.0 + t) * 0.1;

    // Add water movement
  float water = smoothstep(0.0, -0.2, height);
  vec2 waterFlow = vec2(snoise(terrainPos * 2.0 + t * 0.5), snoise(terrainPos * 2.0 + vec2(5.0, t * 0.5))) * 0.002 * water;

    // Sample previous frame with water flow
  vec4 previousWater = texture2D(b, p - waterFlow) * fadeRate;

    // Combine everything
  vec4 final = mix(terrainColor + detail, previousWater, water * 0.5);
  return max(final, previous * fadeRate);
}
