// uniform float r;     // resolution
// uniform vec2 m;      // mouse position
// uniform float t;     // animation time in seconds
// uniform float f;     // frame
// uniform sampler2D b; // previous frame buffer

float i, e, R, s;
vec3 q, p, d = vec3(-FC.yx / r.y * .8 * (abs(cos(t * .3) * .3 + .1 + .8)), 1);
for(q --;
i ++ < 119.;
i > 89. ? d /= - d : d) {
e += i / 5e3;
o += e * e / 25.;
s = 1.;
p = q += d * e * R * .16;
p = vec3(log2(R = length(p)) - 2. - t * .3, - p.z / R, atan(p.x, p.y));
for(e = -- p.y;
s < 1e5;
s += s) e += cos(dot(cos(p.zyy * s), cos(p.xyx * s))) / s;
}
