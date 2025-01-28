/*
Crystal Matrix Effect
A complex crystalline structure with multiple interacting layers:
1. Primary crystal lattice with rotating symmetry
2. Secondary interference pattern using XOR operations
3. Energy pulses flowing through the structure
4. Dynamic cell patterns for detail
5. Multiple color layers with smooth transitions
Creates an effect of a living crystalline computer matrix
*/

vec4 f() {
    // Base coordinate system
  F2 u = p * 6. - 3.;
  F r = L(u);

    // Primary crystal lattice
  F c1 = 0.;
  for(int i = 0; i < 4; i++) {
        // Rotate and scale for each iteration
    F a = i * P / 2. + t * .5;
    F2 v = u * ROT(a) * (1. + F(i) * .2);
    F2 g = CELL(v);
        // Create crystal edges
    c1 += EX(-L(g) * 6.) * (O + H * S(L(g) * 12. - t));
  }

    // Secondary interference pattern
  F c2 = 0.;
  for(int i = 0; i < 3; i++) {
        // Create overlapping grids
    F2 v = CELL(u * ROT(t + i * P / 3.));
    F2 w = CELL(u * ROT(t + i * P / 3.) + .5);
        // XOR pattern for sharp edges
    c2 += EX(-XOR(L(v), L(w)) * 8.);
  }

    // Energy pulses
  F e = 0.;
  for(int i = 0; i < 4; i++) {
    F d = A(r - H - F(i) * .3 + .2 * S(t + i));
    e += EX(-d * 8.) * (O + H * S(d * 15. - t));
  }

    // Combine all effects with color
  F3 crystal = M(F3(.2, .6, 1.), F3(.8, .3, .9), c1) * c1;
  F3 pattern = M(F3(.3, .5, 1.), F3(.9, .4, .8), c2) * c2;
  F3 energy = F3(.6, .4, 1.) * e;

    // Final composition
  return F4((crystal + pattern + energy) * EX(-r * .6), O);
}
