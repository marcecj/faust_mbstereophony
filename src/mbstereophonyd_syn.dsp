declare name        "MBStereohony";
declare version     "0.1";
declare author      "Marc Joliet";
declare license     "MIT";
declare copyright   "(c)Marc Joliet 2013";

import("rm_filter_bank.lib");

mix_slider(i) = hgroup("Stereo Mix",
    vslider("Band %j", 1,0,1,0.01) with {j=i+1;}
);

freq_maxima   = 499,999,1999,3999,7999;
freq_minima   = 75, 500,1000,2000,4000;
freq_defaults = 220., 880., 1760., 3520., 7040.;
N = count(freq_defaults) + 1; // number of bands
freq_slider(i) = hgroup("Filterbank edge frequencies",
    vslider("Freq. %j [unit:Hz]", fdef(i),fmin(i),fmax(i),1) with {
        j=i+1;
        fmin(i) = take(i+1,freq_minima);
        fmax(i) = take(i+1,freq_maxima);
        fdef(i) = take(i+1,freq_defaults);
});

freqs = par(i,N-1,freq_slider(i));

ana_fb = par(i,2,rm_filterbank_analyse3e(freqs)):interleave(N,2);
syn_fb = interleave(2,N):par(i,2,rm_filterbank_synthesize3e(freqs));
stereo_sum(c) = _,_<:+(*(r),*(1-r)),+(*(1-r),*(r)) with {
    r = c*0.5+0.5;
};

process = ana_fb:par(i,N,stereo_sum(mix_slider(i))):syn_fb;
