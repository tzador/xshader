export default (source: string) => `
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>WebGL Template</title>
    <style>
      body {
        margin: 0;
        background: #000;
        overflow: hidden;
      }
      canvas {
        display: block;
      }
    </style>
  </head>
  <body>
    <canvas id="webgl-canvas"></canvas>
    <script>
      // Get WebGL context
      const canvas = document.getElementById("webgl-canvas");
      const gl = canvas.getContext("webgl");

      if (!gl) {
        throw new Error("WebGL not supported.");
      }

      // Canvas resize handler to maintain square aspect ratio
      function resizeCanvas() {
        const size = Math.min(window.innerWidth, window.innerHeight);
        canvas.width = size;
        canvas.height = size;
        gl.viewport(0, 0, canvas.width, canvas.height);
      }
      resizeCanvas();
      window.addEventListener("resize", resizeCanvas);

      // Vertex shader - handles vertex positions and passes coordinates to fragment shader
      const vertexShaderSource = \`\
attribute vec4 a_position;
varying vec2 p;

void main() {
  gl_Position = a_position;      // Set vertex position
  p = a_position.xy * 0.5 + 0.5; // Transform position to [0,1] range for fragment shader
}
\`;

      // Fragment shader - contains all the common mathematical shortcuts and uniforms
      const fragmentShaderSource = \`\
precision mediump float;

// Basic Trigonometric Functions and Constants
#define F float
#define P 3.14159265359  // PI
#define Q (2.0*P)        // 2*PI
#define S sin
#define C cos
#define T tan
#define A abs

// New Mathematical Functions
#define E 2.71828182846
#define L length
#define D dot
#define N normalize
#define M mix
#define R fract
#define F2 vec2
#define F3 vec3
#define F4 vec4

// Common Operations
#define ST smoothstep
#define CL clamp
#define MN min
#define MX max
#define PW pow
#define MD mod

// Common Constants
#define H 0.5
#define O 1.0
#define Z 0.0

// Common Combinations
#define RT(x) (sqrt(x))
#define RN(x) (1.0/x)
#define EX(x) (exp(x))
#define LN(x) (log(x))
#define SQ(x) ((x)*(x))

// Useful Vector Operations
#define ROT(a) mat2(C(a),S(a),-S(a),C(a))
#define CELL(p) (fract(p)-0.5)
#define XOR(a,b) (abs((a)-(b)))

// Shader uniforms and varying variables
uniform float t; // animation time in seconds
uniform vec2 m;  // mouse position, normalized to [0, 1]
varying vec2 p;  // fragment position, normalized to [0, 1]

${source}

void main() {
  gl_FragColor = f();
}
\`;

      // Helper function to create and compile shaders
      function createShader(gl, type, source) {
        const shader = gl.createShader(type);
        gl.shaderSource(shader, source);
        gl.compileShader(shader);
        if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
          console.error("Shader compile error:", gl.getShaderInfoLog(shader));
          gl.deleteShader(shader);
          return null;
        }
        return shader;
      }

      // Helper function to create and link shader program
      function createProgram(gl, vertexShader, fragmentShader) {
        const program = gl.createProgram();
        gl.attachShader(program, vertexShader);
        gl.attachShader(program, fragmentShader);
        gl.linkProgram(program);
        if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
          console.error("Program link error:", gl.getProgramInfoLog(program));
          gl.deleteProgram(program);
          return null;
        }
        return program;
      }

      // Create and compile shaders, then link into program
      const vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource);
      const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource);
      const program = createProgram(gl, vertexShader, fragmentShader);

      // Create vertex buffer for a full-screen quad
      const positionBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
      gl.bufferData(
        gl.ARRAY_BUFFER,
        new Float32Array([-1, -1, 1, -1, -1, 1, 1, -1, 1, 1, -1, 1]), // Two triangles forming a quad
        gl.STATIC_DRAW,
      );

      // Set up vertex attributes
      const positionLocation = gl.getAttribLocation(program, "a_position");
      gl.enableVertexAttribArray(positionLocation);
      gl.vertexAttribPointer(positionLocation, 2, gl.FLOAT, false, 0, 0);

      // Get uniform locations for animation time and mouse position
      const timeUniformLocation = gl.getUniformLocation(program, "t");
      const mouseUniformLocation = gl.getUniformLocation(program, "m");

      // Mouse tracking setup
      let mouse = [0.5, 0.5];
      canvas.addEventListener("mousemove", (event) => {
        const rect = canvas.getBoundingClientRect();
        mouse = [
          (event.clientX - rect.left) / canvas.width,          // Normalize X to [0,1]
          1.0 - (event.clientY - rect.top) / canvas.height,    // Normalize Y to [0,1] and flip
        ];
      });

      // Main render loop
      function render(time) {
        time *= 0.001;  // Convert time to seconds

        gl.useProgram(program);

        // Update uniforms
        gl.uniform1f(timeUniformLocation, time);
        gl.uniform2fv(mouseUniformLocation, mouse);

        // Draw full-screen quad
        gl.drawArrays(gl.TRIANGLES, 0, 6);

        // Schedule next frame
        requestAnimationFrame(render);
      }

      requestAnimationFrame(render);
    </script>
  </body>
</html>
`;
