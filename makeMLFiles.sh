#!/bin/sh

ranges=("28:80" "28:80" "28:50" "51:80" "28:50" "51:80" "28:35" "35:40" "40:45" "45:50" "51:60" "60:70" "70:80")
vals=("0.01" "0.05" "0.2" "0.2" "0.6" "0.6" "1" "1" "1" "1" "1" "1")
names=("0p01" "0p05" "0p2" "0p2_Part2" "0p6_Part1" "0p6_Part2" "1_Part0" "1_Part1" "1_Part2" "1_Part2p5" "1_Part3" "1_Part4" "1_Part5")
for i in ${!ranges[@]};
do
  cp "Den0p1.m" "Den${names[$i]}.m"
  sed -i "s/0.1/${vals[$i]}/" "Den${names[$i]}.m"
  sed -i "s/38:80/${ranges[$i]}/" "Den${names[$i]}.m"
done;
