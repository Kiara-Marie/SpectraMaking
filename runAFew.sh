#!/bin/sh

for var in "0p01" "0p1" "0p2" "0p4" "0p5" "0p6" "0p8" "0p8" "1" "1"
do
	sbatch "AFew_Den$var.sl"
done;
