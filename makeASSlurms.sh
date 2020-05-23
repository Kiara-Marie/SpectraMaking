#!/bin/sh

for var in "0p2_1" "0p2_2" "0p4_1" "0p4_2" "0p4_3" "0p6_1" "0p6_2" "0p6_3" "0p8_Part0" "0p8_Part1" "0p8_Part2" "0p8_Part2p5" "0p8_Part3" "0p8_Part4" "0p8_Part5" "0p8_LastP1" "0p8_LastP2"
do
  cp "AS_Den0p1.sl" "AS_Den$var.sl"
  sed -i "s/AS_Den0p1/AS_Den$var/" "AS_Den$var.sl"
done;
