# MBStereophony
Marc Joliet <marcec@gmx.de>

## Introduction

This is a simple implementation of a Regalia-Mitra filter bank using 3rd order
Cauer low-pass filters as the base designs.  There are four filter bank programs
available which are described below.  MBStereophony itself is a demo effect that
down-mixes a stereo signal separately per frequency band.  It also has four
versions as described below.

For implementations in MATLAB, Python and C++ — the latter of which does not
work — see [this repository](http://sourceforge.net/projects/mbstereophony).

## Compilation

You can either use the provided SCons based build system, whose invocation would
typically look like

    scons -j<N> all

`<N>` is the number of parallel builds.  Instead of "all", you can also specify
any of the group targets `mbstereophony` or `rmfb`, or any of the individual
targets `mbstereophonyd_syn`, `mbstereophonyd_sum`, etc..  That way you can
build only the program you actually want to use.  The SCons build system will
automatically pass appropriate options to the FAUST compiler, such as `-vec` to
produce auto-vectorisable code.  See the output of `scons --help` for more
details.

This relies on an SCons FAUST tool available
[here](https://github.com/marcecj/scons_faust).  It is a submodule of this
repository and is initialised by executing

    git submodule update --init

Of course, you can always just use any of the myriad of faust2\* scripts that
are distributed with FAUST.  This requires more knowledge of the FAUST options,
though (see `faust --help`).

NOTE: it turns out that on my computer (AMD Athlon64 X2 4200+ from late 2006)
`clang++` produces faster binaries than `g++`.  MBStereophony uses about 15% CPU
on average when compiled with `g++` (with `CFLAGS="-O3 -march=native"`), while
it only uses about 9% CPU on average when compiled with `clang++`.

## Usage

There are two groups of applications: RMFB\* and MBStereophony\*.  Each comes in
four versions which follow the following naming scheme:

- "d" and "s" (e.g., "rmfbd\_sum") stand for "dynamic" and "static",
  respectively.  The static filter banks have constant edge frequencies, whereas
  the dynamic filter banks let you vary the edge frequencies.
- "sum" and "syn" suffixes (e.g., "rmfbs\_syn") defines how the filter bank
  reconstructs the signal: by using the all-pass complementary property and
  simply summing the frequency bands up ("sum") or by using a synthesis filter
  bank ("syn").

The static versions have their edge frequencies set to 220, 880, 1760, 3520, and
7040 Hz, so are partially octave filter banks.  Some of the bands were left out
due to the exponential increase in compilation time for each additional band.

The reason for the four versions are:

1. dynamic filter banks require long compilation times, so you don't have to
   compile them if you don't want to, and
2. reconstruction by summing the bands requires only half as much CPU, while the
   using a synthesis filter bank results in the overall transfer function of the
   system becoming invariant to changes in edge frequency (see the references
   below).

So select from them depending on your requirements.

NOTE: the master branch of FAUST recently received a modification that greatly
reduces the total compilation time of all of the programs below.  On my computer
all 8 programs now compile in about 3:30 minutes vs. about 60 minutes for the
original set of 5 programs (before commit
290a6018591a98e2e0eea279e4947f764cc0e9e2).

### RMFB\*

These are four filter bank applications that split a signal into six frequency
bands.

All four of the applications have 7 audio inputs and 7 audio outputs:  The first
input is for the input signal, while the first 6 outputs are from the analysis
filter bank.  Correspondingly, the last 6 inputs belong to the reconstruction
filter bank, while the last output is the reconstructed signal.  Here a
graphical representation:

    Input                   |  Analysis Band 1
    Reconstruction Band 1   |  Analysis Band 2
    ...                     |  ...
    Reconstruction Band N-1 |  Analysis Band N
    Reconstruction Band N   |  Output

### MBStereophony

This is a demo effect for demonstrating the use of the filter banks.  For each
frequency band there is a slider that controls whether the band should be left
in full stereo (1), down-mixed to mono (0), or anything in-between.

## References

The original paper (and some accompanying papers) can be downloaded from Pillip
Regalias [home page](http://faculty.cua.edu/regalia/).

P. A. Regalia, P. P. Vaidyanathan, M. Renfors, Y. Neuvo, and S. K.  Mitra,
"Tree-structured complementary filter banks using all-pass sections," IEEE
Trans. Circuits and Systems, vol. 34, no. 12, pp. 1470–1484, December 1987.
