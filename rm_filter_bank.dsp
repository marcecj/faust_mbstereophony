import("filter.lib");
import("math.lib");
import("poly3.lib");
import("filter_helpers.lib");

gpq(P,D,N) = Q with {
    P_sq = P:polysq(N);
    D_sq = (D,(D:reverse(N))):poly_mult(N,N);
    M = 2*N-1;
    p(i) = P_sq:selector(i,M);
    d(i) = D_sq:selector(i,M);
    R = par(i,M,p(i)-d(i));
    r(i) = R:selector(i,M);
    q(0) = sqrt(r(0));
    q(1) = r(1)/(2*q(0));
    q(i) = (r(i) - sum(k,i-1,(q(k+1)*q(i-k-1))))/(2*q(0));
    Q = par(i,N,q(i));
};

lowpass3ec(fc) = tf2sc(b21,b11,b01,a11,a01,w1) : tf1sc(0,1,a02,w1)
with {
  a11 = 0.802636764161030; // format long; poly(p(1:2)) % in octave
  a01 = 1.412270893774204;
  a02 = 0.822445908998816; // poly(p(3)) % in octave
  b21 = 0.019809144837789; // poly(z)
  b11 = 0;
  b01 = 1.161516418982696;
  w1 = 2*PI*fc;
};

process = lowpass3ec(1000);
/* process = butter4c; */
/* process = gpq_test; */
/* process = tf2sc(0.020083, 0.040167, 0.020083, 1.56102, 0.64135); */
