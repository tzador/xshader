/*
Quantum Field Effect
Simulates a quantum probability field with multiple phenomena:
1. Primary quantum particles with wave-like behavior
2. Secondary interference patterns between particles
3. Probability field distortions
4. Energy state transitions
5. Field fluctuations and uncertainty
Creates a visualization of quantum mechanical behaviors
*/

vec4 f() {
    // Initialize coordinate system
  F2 u = p * 4. - 2.;
  F r = L(u);

    // Primary quantum particles
  F q1 = 0.;
  for(int i = 0; i < 5; i++) {
        // Calculate particle positions with uncertainty
    F2 pos = F2(S(t * 2. + i * P / 2.5), C(t * 2. + i * P / 2.5)) * .7;
    F d = L(u - pos);
        // Wave function probability
    q1 += EX(-d * 4.) * (O + H * S(d * 12. - t + i));
  }

    // Interference patterns
  F q2 = 0.;
  for(int i = 0; i < 3; i++) {
        // Create overlapping probability fields
    F2 v = CELL(u * ROT(t + i * P / 3.));
    F2 w = CELL(u * ROT(-t + i * P / 3.));
        // Combine with phase difference
    q2 += EX(-L(v) * 5.) * EX(-L(w) * 5.) * S(L(v - w) * 8. - t);
  }

    // Field fluctuations
  F q3 = 0.;
  for(int i = 0; i < 4; i++) {
    F2 v = u * ROT(t * .5 + i * P / 2.);
    F2 g = CELL(v * (1. + S(t + i) * .1));
    q3 += EX(-L(g) * 6.);
  }

    // Combine quantum states with color
  F3 particles = M(F3(.2, .5, 1.), F3(.8, .2, 1.), q1) * q1;
  F3 interference = M(F3(.3, .6, .9), F3(.9, .3, .8), q2) * q2;
  F3 field = F3(.6, .4, 1.) * q3;

    // Final quantum state
  return F4((particles + interference + field) * EX(-r * .7), O);
}
