#version 300 es
precision mediump float;

in vec2 FC;
out vec4 fragColor;

uniform vec2 r;     // resolution
uniform vec2 m;      // mouse position
uniform float t;     // animation time in seconds
uniform float f;     // frame
uniform sampler2D b; // previous frame buffer

/*** NOISE_SOURCE ***/

void main() {
  vec4 o = vec4(0.f, 0.f, 0.f, 1.f);

/*** GLSL_SOURCE ***/

  fragColor = o;
}
