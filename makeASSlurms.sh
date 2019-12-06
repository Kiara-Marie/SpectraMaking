#!/bin/sh

for var in vals="0p01" "0p03" "0p05" "0p1" "0p2" "0p2_Part2" "0p4_Part1" "0p4_Part2" "0p4_Last" "0p6_Part1" "0p6_Part2" "0p6_Last" "1_Part0" "1_Part1" "1_Part2" "1_Part2p5" "1_Part3" "1_Part4" "1_Part5" "1_LastP1" "1_LastP2"
do
  cp "AS_Den0p1.sl" "AS_Den$var.sl"
  sed -i "s/AS_Den0p1/AS_Den$var/" "AS_Den$var.sl"
done;
