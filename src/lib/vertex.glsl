#version 300 es
precision highp float;

in vec4 a_position;
out vec2 FC;

void main() {
  gl_Position = a_position;
  FC = a_position.xy;
}
