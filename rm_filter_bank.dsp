import("filter.lib");
import("math.lib");
import("poly1.lib");

gpq(P,D) = Q with {
    N = count(P); // P and D must have the same number of elements
    P_sq = P:polysq(N);
    D_sq = (D,(D:reverse(N))):polysq_reverse(N);
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

// generate a pair of double complementary filters
// see tf1s() in filter.lib
tf1sc(b1,b0,a0,w1) = lp, hp
with {
  c   = 1/tan((w1)*0.5/SR); // bilinear-transform scale-factor
  d   = a0 + c;
  b1d = (b0 - b1*c) / d;
  b0d = (b0 + b1*c) / d;
  a1d = (a0 - c) / d;
  lp = tf1(b0d,b1d,a1d);
  Q = gpq((b0d,b1d),(1.0,a1d));
  q(i) = Q:selector(i,2);
  hp = tf1(q(0),q(1),a1d);
};

tf2sc(b2,b1,b0,a1,a0,w1) = lp, hp
with {
  c   = 1/tan(w1*0.5/SR); // bilinear-transform scale-factor
  csq = c*c;
  d   = a0 + a1 * c + csq;
  b0d = (b0 + b1 * c + b2 * csq)/d;
  b1d = 2 * (b0 - b2 * csq)/d;
  b2d = (b0 - b1 * c + b2 * csq)/d;
  a1d = 2 * (a0 - csq)/d;
  a2d = (a0 - a1*c + csq)/d;
  lp = tf2(b0d,b1d,b2d,a1d,a2d);
  Q = gpq((b0d,b1d,b2d),(1.0,a1d,a2d));
  q(i) = Q:selector(i,3);
  hp = tf2(q(0),q(1),q(2),a1d,a2d);
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
