declare name        "RM Filterbank (static, summing)";
declare version     "0.1";
declare author      "Marc Joliet";
declare license     "MIT";
declare copyright   "(c)Marc Joliet 2013";

import("rm_filter_bank.lib");

freqs = 220., 880., 1760., 3520., 7040.;

process = rm_filterbank_analyse3e(freqs), (bus(count(freqs)+1):>_);
