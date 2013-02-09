import("poly.lib");

N = 3;
M = 4;

/* process = par(i,N,i+1),par(i,M,i+1):poly_multN(N,M); */
/* process = reverse((1,2,3)); */
/* process = par(i,N,i+1):polysqN(N); */
/* process = polysq(par(i,N,i+1)); */
/* process = rest((1,2,3)),rest(1); */
b = 2,3;
process = count(poly_mult((1,2,3,4),(1,2,3)));
