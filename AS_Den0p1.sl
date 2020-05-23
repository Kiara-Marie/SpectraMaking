#!/bin/bash -l
#SBATCH --job-name=AS_Den0p1
#SBATCH --account=def-edgrant
#SBATCH --time=9:00:00
#SBATCH --mem=100000

module load matlab
srun matlab -nodisplay -singleCompThread -r "AS_Den0p1"
