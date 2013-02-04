declare name        "MBStereohony";
declare version     "0.1";
declare author      "Marc Joliet";
declare license     "MIT";
declare copyright   "(c)Marc Joliet 2013";

import("rm_filter_bank.lib");

N = 5; // number of bands

mix_sliders = hgroup("Stereo Mix",
       vslider("Band 1", 1,0,1,0.01),
       vslider("Band 2", 1,0,1,0.01),
       vslider("Band 3", 1,0,1,0.01),
       vslider("Band 4", 1,0,1,0.01),
       vslider("Band 5", 1,0,1,0.01)
      );

m(i) = mix_sliders:selector(i,N);

ana_fb = par(i,2,rm_filterbank_analyse((100,1000,2000,6000))):interleave(N,2);
syn_fb = interleave(2,N):par(i,2,rm_filterbank_synthesize((100,1000,2000,6000)));
stereo_sum(c) = _,_<:+(*(r),*(1-r)),+(*(1-r),*(r)) with {
    r = c*0.5+0.5;
};

process = ana_fb:par(i,N,stereo_sum(m(i))):syn_fb;
