import("filter_helpers.lib");

a11 = 0.802636764161030; // format long; poly(p(1:2)) % in octave
a01 = 1.412270893774204;
a02 = 0.822445908998816; // poly(p(3)) % in octave
b21 = 0.019809144837789; // poly(z)
b11 = 0;
b01 = 1.161516418982696;
w1 = 2*PI*1000;

process = tf2s_coeffs(b21,b11,b01,a11,a01,w1);
/* process = tf1s_coeffs(0,1,a02,w1); */
