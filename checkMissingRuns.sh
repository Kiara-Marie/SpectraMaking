#!/bin/sh

names=("0p03" "0p05" "0p1" "0p2" "0p4" "0p6" "1")

for name in ${names[@]};
do
  echo "Changing directory..."
  cd "BestCalcs_den_$name"
  echo "Changed directory"
  for ((i=21;i<80;i++));
  do
    currFile = "All_Fractions_vs_timepqn_${i}Density_${name}_shells_100_t_max_350.csv";
    if test ! -f ${currFile}
    then
        echo "${currFile} not present";
        #start = i;
        #while test ! -f currFile    
    fi
  done
  cd ".."
done;



