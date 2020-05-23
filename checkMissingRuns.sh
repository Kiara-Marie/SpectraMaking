#!/bin/sh

names=("0p2" "0p4" "0p6" "0p8")
vals=("0.2" "0.4" "0.6" "0.8") 
for name in ${names[@]}
do
  echo "Changing directory..."
  cd "MoreTimesCalcs_den_$name"
  echo "Changed directory"
  myIndex=0
  for i in {30..80}
  do
    currFile=All_Fractions_vs_timepqn_${i}Density_${name}_shells_100_t_max_200.csv
    if [ ! -f "$currFile" ]; then
      echo "$currFile not present"
      cd ".."
      cp "AS_Den0p1.sl" "Extra_Den${name}_PQN_${i}.sl"
      sed -i "s/AS_Den0p1/Extra_Den${name}_PQN_${i}/" "Extra_Den${name}_PQN_${i}.sl"
      cp "AS_Den0p1.m" "Extra_Den${name}_PQN_${i}.m"
      sed -i "s/0.1/${vals[$index]}/" "Extra_Den${name}_PQN_${i}.m"
      sed -i "s/30:80/${i}/" "Extra_Den${name}_PQN_${i}.m"
      sbatch "Extra_Den${name}_PQN_${i}.sl"
      cd "MoreTimesCalcs_den_$name"
    fi
    myIndex=(myIndex+1)
  done
  cd ".."
done



