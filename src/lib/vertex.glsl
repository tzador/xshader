#version 300 es
precision mediump float;

in vec4 a_position;
out vec2 FC;
uniform vec2 r;     // resolution

void main() {
  gl_Position = a_position;
  FC = (a_position.xy * 0.5f + 0.5f) * r.xy;
}
