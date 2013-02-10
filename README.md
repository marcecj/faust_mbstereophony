# MBStereophony
Marc Joliet <marcec@gmx.de>

## Introduction

This is a simple implementation of a Regalia-Mitra filter bank using 3rd order
Cauer low-pass filters as the base designs.  There are four filter bank programs
available which are described below.  MBStereophony itself is a demo effect that
down-mixes a stereo signal separately per frequency band.

For implementations in MATLAB, Python and C++ - the latter of which does not
work - see [this repository](http://sourceforge.net/projects/mbstereophony).

## Usage

### RMFB\*

These are four filter bank applications that split a signal into six frequency
bands.  They follow the following naming scheme:

- "d" and "s" (e.g., "rmfbd\_sum") stand for "dynamic" and "static",
  respectively.  The static filter banks have constant edge frequencies, whereas
  the dynamic filter banks let you vary the edge frequencies.
- "sum" and "syn" suffixes (e.g., "rmfbs\_syn") defines how the filter bank
  reconstructs the signal: by using the all-pass complementary property and
  simply summing the frequency bands up ("sum") or by using a synthesis filter
  bank ("syn").

The static filter banks have the edge frequencies set to 220, 880, 1760, 3520,
and 7040 Hz.  All four of the applications has 7 audio inputs and 7 audio
outputs:  The first input is for the input signal, while the first 6 outputs are
from the analysis filter bank.  Correspondingly, the last 6 inputs belong to the
reconstruction filter bank, while the last output is the reconstructed signal.
Here a graphical representation:

    Input                   |  Analysis Band 1
    Reconstruction Band 1   |  Analysis Band 2
    ...                     |  ...
    Reconstruction Band N-1 |  Analysis Band N
    Reconstruction Band N   |  Output

The reason for the four versions are:

1. dynamic filter banks require long compilation times, so you don't have to
   compile them if you don't want to, and
2. reconstruction by summing the bands requires only half as much CPU, while the
   using a synthesis filter bank results in the overall transfer function of the
   system becoming invariant to changes in edge frequency.

So select each depending on your requirements.

### MBStereophony

This is a demo effect for demonstrating the use of the filter banks.  For each
frequency band there is a slider that controls whether the band should be left
in full stereo (1), down-mixed to mono (0), or anything in-between.  The bands
edge frequencies are at 220, 880, 1760, 3520, and 7040 Hz, so the filter bank is
partially an octave filter bank.  Some of the bands were left out due to the
exponential increase in compilation time for each additional band.

## TODO

- Variable filter edge frequencies (currently, compilation takes too long for
  that to be practical).

## References

The original paper (and some accompanying papers) can be downloaded from Pillip
Regalias [home page](http://faculty.cua.edu/regalia/).

P. A. Regalia, P. P. Vaidyanathan, M. Renfors, Y. Neuvo, and S. K.  Mitra,
"Tree-structured complementary filter banks using all-pass sections," IEEE
Trans. Circuits and Systems, vol. 34, no. 12, pp. 1470–1484, December 1987.
