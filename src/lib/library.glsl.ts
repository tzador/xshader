export default `\
// Shader uniforms and varying variables
uniform float t;     // animation time in seconds
uniform vec2 m;      // mouse position, normalized to [0, 1]
uniform sampler2D b; // previous frame buffer
varying vec2 p;      // fragment position, normalized to [0, 1]

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
`;
