#!/bin/sh

ranges=("21:80" "21:80" "21:80" "21:50" "51:80" "21:50" "51:74" "74:80""21:50" "51:74" "74:80" "21:35" "35:40" "40:45" "45:50" "51:60" "60:65" "65:70" "70:75" "75:80")
vals=("0.01" "0.03" "0.05" "0.2" "0.2" "0.4" "0.4""0.4" "0.6" "0.6" "0.6" "1" "1" "1" "1" "1" "1" "1" "1")
names=("0p01" "0p03" "0p05" "0p2" "0p2_Part2" "0p4_Part1" "0p4_Part2" "0p4_Last" "0p6_Part1" "0p6_Part2" "0p6_Last" "1_Part0" "1_Part1" "1_Part2" "1_Part2p5" "1_Part3" "1_Part4" "1_Part5" "1_LastP1" "1_LastP2")
for i in ${!ranges[@]};
do
  cp "KP_Den0p1.m" "KP_Den${names[$i]}.m"
  sed -i "s/0.1/${vals[$i]}/" "KP_Den${names[$i]}.m"
  sed -i "s/21:80/${ranges[$i]}/" "KP_Den${names[$i]}.m"
done;
