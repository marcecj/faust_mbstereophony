import("poly.lib");

N = 3;
M = 4;

/* process = par(i,N,i+1),par(i,M,i+1):poly_mult(N,M); */
process = par(i,N,i+1):polysq(N);
/* process = polymult_facs(3,2); */
/* process = bus(6):sum_coeffs(1,2,3); */
