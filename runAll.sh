#!/bin/sh

for var in "0p1" "0p2" "0p3_1" "0p3_2" "0p3_3" "1_00" "1_01" "1_02" "1_03" "1_04" "1_05" "1_06" "1_07" "1_08" "1_09" "1_10"
do
	sbatch "NR_Den$var.sl"
done;
