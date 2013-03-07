declare name        "RM Filterbank (dynamic, synthesis FB)";
declare version     "0.1";
declare author      "Marc Joliet";
declare license     "MIT";
declare copyright   "(c)Marc Joliet 2013";

import("rm_filter_bank.lib");

freq_maxima   = 499,999,1999,3999,7999;
freq_minima   = 75, 500,1000,2000,4000;
freq_defaults = 220., 880., 1760., 3520., 7040.;
N = count(freq_defaults);
freq_sliders = hgroup("Filterbank edge frequencies",
    par(i,N,vslider("Freq. %j", fdef(i),fmin(i),fmax(i),1) with {
        j=i+1;
        fmin(i) = take(i+1,freq_minima);
        fmax(i) = take(i+1,freq_maxima);
        fdef(i) = take(i+1,freq_defaults);
        })
) ;

f(i) = freq_sliders:selector(i,N);
freqs = par(i,N,f(i));

process = rm_filterbank_analyse3e(freqs), rm_filterbank_synthesize3e(freqs);