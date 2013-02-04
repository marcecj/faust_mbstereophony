// TODO: finish, document reference values
import("rm_filter_bank.lib");

gpq_test = gpq((b1,b2,b3,b4),(a1,a2,a3,a4),4) with {
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
    Q = gpq((b1,b2,b3,b4),(1,a2,a3,a4),4);
    q(i) = Q:selector(i,4);
    c1 = q(0);
    c2 = q(1);
    c3 = q(2);
    c4 = q(3);
    };

/* process = butter4c; */
/* process = gpq_test; */
/* process = _,_<:lowpass3ec(1000); */
/* process = rm_filterbank_analyse_demo; */
process = rm_filterbank_synthesize_demo;
