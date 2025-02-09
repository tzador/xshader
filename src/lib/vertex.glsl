attribute vec4 a_position;
varying vec2 p;

void main() {
  gl_Position = a_position;      // Set vertex position
  p = a_position.xy * 0.5 + 0.5; // Transform position to [0,1] range for fragment shader
}
