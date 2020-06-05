#!/bin/sh

for var in "0p01" "0p05" "0p1_1" "0p2_1" "0p2_2" "0p4_1" "0p4_2" "0p4_3" "0p6_1" "0p6_2" "0p6_3" "0p8_00" "0p8_01" "0p8_02" "0p8_03" "0p8_04" "0p8_05" "0p8_06" "0p8_07" "0p8_08" "0p8_09" "0p8_10" "1_00" "1_01" "1_02" "1_03" "1_04" "1_05" "1_06" "1_07" "1_08" "1_09" "1_10" "1p5_00" "1p5_01" "1p5_02" "1p5_03" "1p5_04" "1p5_05" "1p5_06" "1p5_07" "1p5_08" "1p5_09" "1p5_10"
do
  cp "AS_Den0p1.sl" "AS_Den$var.sl"
  sed -i "s/AS_Den0p1/AS_Den$var/" "AS_Den$var.sl"
done;
