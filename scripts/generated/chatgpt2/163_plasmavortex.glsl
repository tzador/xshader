/*
Plasma Vortex Effect
Creates a complex plasma effect with multiple interacting vortices:
1. Main vortex field using normalized dot products
2. Secondary swirling patterns with rotation
3. Energy waves radiating from the center
4. Interference patterns between vortices
5. Dynamic color mixing based on all components
Simulates a swirling plasma storm with energy discharges
*/

vec4 f() {
    // Setup coordinate system
  F2 u = p * 4. - 2.;
  F r = L(u);

    // Main vortex field
  F v1 = 0.;
  for(int i = 0; i < 4; i++) {
        // Create rotating direction vectors
    F2 dir = F2(S(t * 2. + i * P / 2.), C(t * 2. + i * P / 2.));
        // Calculate field strength using dot product
    v1 += PW(MX(0., D(N(u), dir)), 3.) * (O + H * S(D(u, dir) * 4. - t));
  }

    // Secondary swirling patterns
  F v2 = 0.;
  for(int i = 0; i < 3; i++) {
        // Rotate and distort space
    F2 v = u * ROT(t + i * P / 3.);
    F2 g = CELL(v * (1. + S(t + i) * .2));
        // Add swirl contribution
    v2 += EX(-L(g) * 5.) * (O + H * S(L(g) * 8. - t));
  }

    // Energy waves
  F w = 0.;
  for(int i = 0; i < 3; i++) {
    F d = A(r - H - F(i) * .2 + .1 * S(t * 2. + i));
    w += EX(-d * 6.) * S(d * 20. - t + i);
  }

    // Combine effects with color
  F3 vortex = M(F3(.2, .5, 1.), F3(.8, .2, 1.), v1) * v1;
  F3 swirl = M(F3(.3, .6, .9), F3(.9, .3, .8), v2) * v2;
  F3 waves = F3(.6, .4, 1.) * w;

    // Final composition with depth
  return F4((vortex + swirl + waves) * ST(O, H, r), O);
}
