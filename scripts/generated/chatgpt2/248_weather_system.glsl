/*
Weather System Dynamics
Visualizes atmospheric fluid dynamics, temperature gradients,
cloud formation, and storm system evolution.
*/

vec4 f() {
    vec2 uv = (p - 0.5) * 4.0;
    vec3 color = vec3(0.0);

    // Weather parameters
    float weather_time = t * 1.5;
    float temperature = 0.8;
    float humidity = 0.7;

    // System parameters
    const int PRESSURE_SYSTEMS = 4;
    const float WIND_STRENGTH = 0.8;

    // Weather noise function
    float weather_noise(vec2 p, float freq) {
        vec2 i = floor(p * freq);
        vec2 f = fract(p * freq);

        float a = fract(sin(dot(i, vec2(127.1, 311.7))) * 43758.5453);
        float b = fract(sin(dot(i + vec2(1.0, 0.0), vec2(127.1, 311.7))) * 43758.5453);
        float c = fract(sin(dot(i + vec2(0.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);
        float d = fract(sin(dot(i + vec2(1.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);

        f = f * f * (3.0 - 2.0 * f);

        return mix(
            mix(a, b, f.x),
            mix(c, d, f.x),
            f.y
        );
    }

    // Generate pressure systems
    float pressure = 0.0;
    vec2 wind_flow = vec2(0.0);

    for(int i = 0; i < PRESSURE_SYSTEMS; i++) {
        float phase = float(i) * 6.28319 / float(PRESSURE_SYSTEMS);
        vec2 center = vec2(
            cos(phase + weather_time * 0.2),
            sin(phase + weather_time * 0.3)
        ) * 1.5;

        // Calculate pressure field
        vec2 rel_pos = uv - center;
        float dist = length(rel_pos);
        vec2 flow_dir = normalize(rel_pos);

        // Rotating pressure system
        float rotation = sin(phase + weather_time);
        vec2 rotated_flow = vec2(
            flow_dir.x * cos(rotation) - flow_dir.y * sin(rotation),
            flow_dir.x * sin(rotation) + flow_dir.y * cos(rotation)
        );

        float system_pressure = exp(-dist * 2.0);
        pressure += system_pressure * (float(i % 2) * 2.0 - 1.0);
        wind_flow += rotated_flow * system_pressure;
    }

    // Generate temperature gradient
    float temp_gradient = 0.0;
    for(int i = 0; i < 4; i++) {
        float scale = pow(2.0, float(i));
        vec2 temp_pos = uv * scale + wind_flow * weather_time;

        temp_gradient += weather_noise(temp_pos, 1.0) / scale;
    }

    // Create cloud formations
    float clouds = 0.0;
    vec2 cloud_pos = uv + wind_flow * weather_time * 0.5;

    for(int i = 0; i < 5; i++) {
        float scale = pow(2.0, float(i));
        vec2 pos = cloud_pos * scale;

        float cloud_noise = weather_noise(pos, 1.0);
        clouds += cloud_noise / scale;
    }

    // Simulate precipitation
    float precipitation = 0.0;
    for(int i = 0; i < 3; i++) {
        float scale = pow(2.0, float(i));
        vec2 rain_pos = uv * scale + vec2(0.0, -weather_time * 2.0);

        float rain = weather_noise(rain_pos, 2.0);
        rain = pow(rain, 4.0); // Make precipitation more distinct

        precipitation += rain / scale;
    }

    // Generate storm systems
    float storm = 0.0;
    vec2 storm_center = vec2(
        cos(weather_time * 0.4),
        sin(weather_time * 0.5)
    );

    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.0944;
        vec2 offset = vec2(cos(angle), sin(angle));

        float system = exp(-length(uv - storm_center - offset) * 2.0);
        system *= sin(length(uv - storm_center) * 8.0 - weather_time * 4.0);

        storm += system;
    }

    // Create color gradients
    vec3 pressure_color = mix(
        vec3(0.2, 0.4, 0.8),  // Low pressure
        vec3(0.8, 0.3, 0.2),  // High pressure
        pressure * 0.5 + 0.5
    );

    vec3 temp_color = mix(
        vec3(0.2, 0.5, 0.9),  // Cold
        vec3(0.9, 0.4, 0.2),  // Hot
        temp_gradient * temperature
    );

    vec3 cloud_color = mix(
        vec3(0.6, 0.7, 0.8),  // Light clouds
        vec3(0.2, 0.2, 0.3),  // Dark clouds
        clouds * humidity
    );

    // Combine visualization components
    color = pressure_color * (1.0 + abs(pressure) * 0.5);
    color = mix(color, temp_color, 0.5);
    color = mix(color, cloud_color, clouds * humidity);

    // Add precipitation effects
    vec3 rain_color = mix(
        vec3(0.2, 0.3, 0.4),  // Light rain
        vec3(0.1, 0.1, 0.2),  // Heavy rain
        precipitation
    );
    color = mix(color, rain_color, precipitation * humidity);

    // Add storm effects
    vec3 storm_color = mix(
        vec3(0.2, 0.2, 0.3),  // Storm clouds
        vec3(0.8, 0.7, 0.2),  // Lightning
        sin(weather_time * 10.0) * storm
    );
    color = mix(color, storm_color, storm * 0.5);

    // Add wind flow visualization
    float wind_lines = sin(dot(normalize(wind_flow), uv) * 8.0 - weather_time * 2.0);
    wind_lines = wind_lines * 0.5 + 0.5;
    color += vec3(1.0) * wind_lines * WIND_STRENGTH * 0.1;

    // Add atmospheric scattering
    float atmosphere = exp(-length(uv) * 0.5);
    color = mix(color, vec3(0.6, 0.7, 0.9), atmosphere * 0.3);

    // Tone mapping and color adjustment
    color = pow(color, vec3(0.8));
    color = mix(color, vec3(length(color)), 0.1);

    return vec4(color, 1.0);
}
