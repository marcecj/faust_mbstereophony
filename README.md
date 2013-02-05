# MBStereophony
Marc Joliet <marcec@gmx.de>

## Introduction

This is a simple implementation of a Regalia-Mitra filter bank using 3rd order
Cauer low-pass filters as the base designs.  MBStereophony itself is a demo
effect that down-mixes a stereo signal separately per frequency band.

## Usage

Each frequency band consists of a slider that controls whether the band should
be left in full stereo (1) or mono (0) or anything in-between.  The bands have
the edge frequencies 220, 880, 1760, 3520, and 7040 Hz, so is partially an octave
filter bank.  Some of the frequencies were left out due to the exponential
increase in compilation time for each additional band.

## TODO

- Variable filter edge frequencies (currently, compilation takes too long for
  that to be practical).
