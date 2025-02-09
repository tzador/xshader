#version 300 es
precision highp float;

in vec2 FC;
out vec4 fragColor;

uniform float r;     // resolution
uniform vec2 m;      // mouse position
uniform float t;     // animation time in seconds
uniform float f;     // frame
uniform sampler2D b; // previous frame buffer

#define hsv(h,s,v) vec3(v*mix(vec3(1.),clamp(abs(fract(h+vec3(0.,2./3.,1./3.))*6.-3.)-1.,0.,1.),s))

void main() {
  vec4 o = vec4(0.f, 0.f, 0.f, 1.f);

/*** GLSL_SOURCE ***/

  fragColor = o;
}
