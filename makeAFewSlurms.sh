#!/bin/sh

for var in "0p01" "0p1" "0p2" "0p4" "0p5" "0p6" "0p8" "0p8" "1" "1"
do
  cp "AS_Den0p1.sl" "AFew_Den$var.sl"
  sed -i "s/AS_Den0p1/AFew_Den$var/" "AFew_Den$var.sl"
done;
