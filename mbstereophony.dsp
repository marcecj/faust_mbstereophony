declare name        "MBStereohony";
declare version     "0.1";
declare author      "Marc Joliet";
declare license     "MIT";
declare copyright   "(c)Marc Joliet 2013";

import("rm_filter_bank.lib");

freqs = 220., 880., 1760., 3520., 7040.;
N = count(freqs)+1; // the number of bands

mix_sliders = hgroup("Stereo Mix",
    par(i,N,vslider("Band %j", 1,0,1,0.01) with {j=i+1;})
) ;

m(i) = mix_sliders:selector(i,N);

ana_fb = par(i,2,rm_filterbank_analyse(freqs)):interleave(N,2);
syn_fb = interleave(2,N):par(i,2,rm_filterbank_synthesize(freqs));
stereo_sum(c) = _,_<:+(*(r),*(1-r)),+(*(1-r),*(r)) with {
    r = c*0.5+0.5;
};

process = ana_fb:par(i,N,stereo_sum(m(i))):syn_fb;
