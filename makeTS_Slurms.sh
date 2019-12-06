#!/bin/sh

for var in "0p01" "0p05" "0p2" "0p2_Part2" "0p6_Part1" "0p6_Part2" "1_Part0" "1_Part1" "1_Part2" "1_Part2p5" "1_Part3" "1_Part4" "1_Part5"
do
  cp "TS_Den0p1.sl" "TS_Den$var.sl"
  sed -i "s/Den0p1/Den$var/" "Den$var.sl"
done;
