/*
Quantum Tunnel Effect
This shader creates a complex tunnel effect with multiple layers:
1. Base tunnel using polar coordinates with time-based distortion
2. Quantum particles orbiting around the tunnel walls
3. Energy field created by interference patterns
4. XOR-based crystalline structure for detail
5. Smooth color transitions based on all components
The effect suggests traveling through a quantum wormhole
*/

vec4 f() {
    // Setup base coordinates and polar mapping
  F2 u = p * 4. - 2.;
  F r = L(u), a = atan(u.y, u.x);

    // Create tunnel distortion
  F2 v = F2(r * C(a + t), r * S(a - t));
  F d = XOR(CELL(v).x, CELL(v * 1.5).y);

    // Add quantum particles
  F q = 0.;
  for(int i = 0; i < 4; i++) {
    F2 p = F2(S(t * 2. + i * P / 2.), C(t * 2. + i * P / 2.)) * .7;
    q += EX(-L(u - p) * 4.) * (O + H * S(L(u - p) * 8. - t));
  }

    // Create energy field
  F e = 0.;
  for(int i = 0; i < 3; i++) {
    F2 w = u * ROT(t + i * P / 3.);
    F2 g = CELL(w);
    e += EX(-L(g) * 5.);
  }

    // Combine all effects with color
  F3 tunnel = M(F3(.2, .5, 1.), F3(.8, .2, 1.), ST(Z, .2, d));
  F3 particles = F3(.6, .3, .9) * q;
  F3 energy = F3(.4, .6, 1.) * e;

    // Final composition with depth and glow
  return F4((tunnel + particles + energy) * EX(-r * .8 + d * .2), O);
}
