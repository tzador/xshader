// uniform float r;     // resolution
// uniform vec2 m;      // mouse position
// uniform float t;     // animation time in seconds
// uniform float f;     // frame
// uniform sampler2D b; // previous frame buffer

// Create a pulsing red color based on time
float pulse = sin(t) * 0.5 + 0.5;
// Use mouse x position to blend with blue
float blueAmount = m.x;
// Create final color
o = vec4(pulse, 0.0, blueAmount, 1.0);
