/*
Ocean Simulation
Creates a realistic ocean surface with wave dynamics,
foam generation, and subsurface light scattering.
*/

vec4 f() {
  vec2 uv = (p - 0.5) * vec2(2.0, 1.0);
  vec3 color = vec3(0.0);

    // Wave parameters
  const int WAVE_COUNT = 8;
  const float WAVE_SPEED = 1.0;
  const float CHOPPY_SCALE = 0.5;

    // Calculate wave height and normal
  float height = 0.0;
  vec2 slope = vec2(0.0);

  for(int i = 0; i < WAVE_COUNT; i++) {
    float scale = 1.0 - float(i) * 0.05;
    float angle = float(i) * 1.0472;

    vec2 dir = vec2(cos(angle + sin(t * 0.1) * 0.5), sin(angle + cos(t * 0.15) * 0.5));

    float steepness = 0.5 * scale;
    float wavelength = 1.0 / (float(i) * 0.5 + 1.0);
    float k = 2.0 * 3.14159 / wavelength;
    float c = sqrt(9.8 / k);
    float a = steepness / k;

    vec2 xz = uv * scale;
    float f = k * (dot(dir, xz) - c * t * WAVE_SPEED);

        // Gerstner wave
    height += a * sin(f);
    slope += dir * (a * k * cos(f));
  }

    // Calculate normal from slope
  vec3 normal = normalize(vec3(-slope.x, 1.0, -slope.y));

    // Sky reflection
  vec3 view = normalize(vec3(uv, 2.0));
  vec3 reflection = reflect(view, normal);

  float fresnel = pow(1.0 - max(0.0, dot(normal, -view)), 5.0);

  vec3 sky_color = mix(vec3(0.1, 0.2, 0.4),   // Horizon
  vec3(0.5, 0.7, 1.0),   // Zenith
  reflection.y * 0.5 + 0.5);

    // Water color with depth
  float depth = 1.0 - exp(-abs(uv.y + height) * 2.0);
  vec3 water_color = mix(vec3(0.0, 0.1, 0.2),   // Deep water
  vec3(0.0, 0.2, 0.3),   // Shallow water
  depth);

    // Subsurface scattering
  float sss = pow(max(0.0, dot(normal, vec3(0.0, 1.0, 0.0))), 4.0);
  water_color += vec3(0.0, 0.1, 0.1) * sss;

    // Foam generation
  float foam = 0.0;
  float wave_height = height * 0.5 + 0.5;

    // Wave peaks
  foam += smoothstep(0.8, 0.9, wave_height);

    // Turbulence foam
  float turbulence = length(slope) * 2.0;
  foam += smoothstep(1.0, 2.0, turbulence) * 0.5;

    // Shoreline foam
  float shoreline = smoothstep(0.0, 0.2, depth);
  foam += (1.0 - shoreline) * 0.3;

    // Foam detail
  vec2 foam_uv = uv * 10.0 + slope * 0.2 - t * 0.1;
  float foam_pattern = sin(foam_uv.x) * sin(foam_uv.y);
  foam *= 0.8 + 0.2 * foam_pattern;

    // Combine colors
  color = mix(water_color, sky_color, fresnel);
  color = mix(color, vec3(1.0), foam);

    // Add sun specular
  vec3 sun_dir = normalize(vec3(0.5, 0.8, 0.2));
  float sun_spec = pow(max(0.0, dot(reflection, sun_dir)), 256.0);
  color += vec3(1.0, 0.9, 0.7) * sun_spec;

    // Tone mapping
  color = pow(color, vec3(0.8));

  return vec4(color, 1.0);
}
