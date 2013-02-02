import("filter.lib");
import("math.lib");
import("poly1.lib");

gpq(P,D) = q with {
    N = count(P); // P and D must have the same number of elements
    P_sq = P:polysq(N);
    D_sq = (D,(D:reverse(N))):polysq_reverse(N);
    M = 2*N-1;
    p(i) = P_sq:selector(i,M);
    d(i) = D_sq:selector(i,M);
    R = par(i,M,p(i)-d(i));
    r(i) = R:selector(i,M);
    Q(0) = sqrt(r(0));
    Q(1) = r(1)/(2*Q(0));
    Q(i) = (r(i) - sum(k,i-1,(Q(k+1)*Q(i-k-1))))/(2*Q(0));
    q = par(i,N,Q(i));
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

gpq_test = gpq((b1,b2,b3,b4),(a1,a2,a3,a4)) with {
    b1 = 0.00289819;
    b2 = 0.00869458;
    b3 = 0.00869458;
    b4 = 0.00289819;
    a1 = 1.;
    a2 = -2.37409474;
    a3 = 1.92935567;
    a4 = -0.53207537;
    };

butter4c = iir((b1,b2,b3,b4),(a2,a3,a4)), iir((c1,c2,c3,c4),(a2,a3,a4))
with {
    b1 = 0.00289819;
    b2 = 0.00869458;
    b3 = 0.00869458;
    b4 = 0.00289819;
    a2 = -2.37409474;
    a3 = 1.92935567;
    a4 = -0.53207537;
    Q = gpq((b1,b2,b3,b4),(1,a2,a3,a4));
    q(i) = Q:selector(i,4);
    c1 = q(0);
    c2 = q(1);
    c3 = q(2);
    c4 = q(3);
    };

process = lowpass3ec(1000);
/* process = butter4c; */
/* process = gpq_test; */
/* process = tf2sc(0.020083, 0.040167, 0.020083, 1.56102, 0.64135); */
