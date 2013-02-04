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

lowpass3ec(fc) = lp,hp
with {
    N = 3;
    M = N-1;

    // analog coefficients
    a11 = 0.802636764161030; // format long; poly(p(1:2)) % in octave
    a01 = 1.412270893774204;
    a02 = 0.822445908998816; // poly(p(3)) % in octave
    b21 = 0.019809144837789; // poly(z)
    b11 = 0;
    b01 = 1.161516418982696;
    w1 = 2*PI*fc;

    // generate the low-pass
    lp = tf2s(b21,b11,b01,a11,a01,w1) : tf1s(0,1,a02,w1);

    // Generate the double-complementary high-pass from the low-pass coefficients.
    // Personally, I think this is butt-ugly code, but I can't think of a better
    // way to implement this now.
    A = tf2s_coeffs(b21,b11,b01,a11,a01,w1);
    B = tf1s_coeffs(0,1,a02,w1);
    Ab = A : bus(N),    par(i,N,!);
    Aa = A : par(i,N,!),bus(N);
    Bb = B : bus(M),    par(i,M,!);
    Ba = B : par(i,M,!),bus(M);
    P = Bb,Ab : poly_mult(M,N);
    D = Ba,Aa : poly_mult(M,N);
    Q = gpq(P,D,4);
    d(i) = D:selector(i,4);
    q(i) = Q:selector(i,4);
    hp = iir((q(0),q(1),q(2),q(3)),(d(1),d(2),d(3)));
};

process = _,_<:lowpass3ec(1000);
