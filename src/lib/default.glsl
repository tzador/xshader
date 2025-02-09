// Increment output color/value
o ++;

// Temporary color vector
vec4 h;

// UV coordinates vector
vec2 u;

// Loop variables:
// - i: controls iteration steps (0.6 to 0.1)
// - Decrease i by 0.1 each iteration
for(float A, l, a, i = 0.6;
i > 0.1;
i -= 0.1) {
    // Complex angular calculation using time t
a -= sin(a -= sin(a = (t + i) * 4.));

    // Transform fragment coordinates to UV space
u = (FC.xy * 2. - r) / r.y;

    // Calculate length l:
    // - Get length of transformed UV coords
    // - Rotate UVs and apply clamped transformation
    // - Clamp rotated coordinates
    // - Ensure minimum length of 0.1
l = max(length(u -= rotate2D(a /= 4.) *
  clamp(u * rotate2D(a), - i, + i)), 0.1);

    // Calculate alpha/blend factor
A = min((l - 0.1) * r.y * 0.2, 1.);

    // Mix colors:
    // - Generate color h using sine waves
    // - Color components with offsets
    // - Previous output color
    // - Using alpha blend factor
o = mix(h = sin(i / 0.1 + a + vec4(1, 3, 5, 0)) * 0.2 + 0.7, o, A) * mix(h / h, // Normalize h
h + 0.5 * A * u.y / l,    // Add vertical gradient effect
0.1 / l                   // Blend based on inverse length
);
}
