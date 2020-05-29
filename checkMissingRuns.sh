#!/bin/sh

names=("0p01" "0p05" "0p1" "0p2" "0p4" "0p6" "0p8" "1" "1p5")
vals=("0.01" "0.05" "0.1" "0.2" "0.4" "0.6" "0.8" "1" "1.5")
j=0
for name in ${names[@]}
do
  echo "Changing directory..."
  cd "MoreTimesCalcs_den_$name"
  echo "Changed directory"
  for i in {30..80}
  do
    currFile=All_Fractions_vs_timepqn_${i}Density_${name}_shells_100_t_max_200.csv
    if [ ! -f "$currFile" ]; then
      echo "$currFile not present"
      cd ".."
      cp "AS_Den0p1.sl" "Extra_Den${name}_PQN_${i}.sl"
      sed -i "s/AS_Den0p1/Extra_Den${name}_PQN_${i}/" "Extra_Den${name}_PQN_${i}.sl"
      cp "AS_Den0p1.m" "Extra_Den${name}_PQN_${i}.m"
      val=${vals[$j]}
      echo $val
      sed -i "s/0.1/$val/" "Extra_Den${name}_PQN_${i}.m"
      sed -i "s/30:80/${i}/" "Extra_Den${name}_PQN_${i}.m"
      sbatch "Extra_Den${name}_PQN_${i}.sl"
      cd "MoreTimesCalcs_den_$name"
    fi
  done
  $((j++))
  echo $j
  cd ".."
done
