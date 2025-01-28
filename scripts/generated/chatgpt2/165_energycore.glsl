/*
Energy Core Effect
Creates a complex energy reactor core with multiple systems:
1. Central core with pulsing energy
2. Rotating energy field with phase shifts
3. Particle acceleration rings
4. Power fluctuations and discharges
5. Multiple layer interactions
Simulates a high-energy reactor or power source
*/

vec4 f() {
    // Setup coordinate system
  F2 u = p * 4. - 2.;
  F r = L(u);

    // Central core pulse
  F core = EX(-A(r - H - H * S(t)) * 8.);
  F glow = S(core * 2.) * EX(-r);

    // Rotating energy field
  F e1 = 0.;
  for(int i = 0; i < 4; i++) {
        // Create rotating vectors
    F2 v = u * ROT(t + i * P / 2.);
    F2 g = CELL(v * (1. + S(t + i) * .2));
        // Add field contribution
    e1 += EX(-L(g) * 5.) * (O + H * S(L(g) * 10. - t));
  }

    // Particle acceleration rings
  F e2 = 0.;
  for(int i = 0; i < 3; i++) {
        // Create concentric rings
    F d = A(r - (H + F(i) * .3) + .2 * S(t * 2. + i));
        // Add ring energy
    e2 += EX(-d * 6.) * S(d * 15. - t);
  }

    // Power fluctuations
  F e3 = 0.;
  for(int i = 0; i < 4; i++) {
    F2 v = F2(S(t * 3. + i * P / 2.), C(t * 3. + i * P / 2.)) * .6;
    e3 += EX(-L(u - v) * 4.);
  }

    // Combine all effects with color
  F3 coreColor = M(F3(.2, .5, 1.), F3(1., .3, .1), core + glow);
  F3 fieldColor = M(F3(.3, .6, .9), F3(.9, .3, .8), e1) * e1;
  F3 ringColor = F3(.6, .4, 1.) * e2;
  F3 fluctColor = F3(.8, .5, .2) * e3;

    // Final composition
  return F4((coreColor + fieldColor + ringColor + fluctColor) * ST(O, H, r), O);
}
