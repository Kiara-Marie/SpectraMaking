#!/bin/bash -l
#SBATCH --job-name=KPDen0p1
#SBATCH --account=def-edgrant
#SBATCH --time=23:00:00
#SBATCH --mem=100000

module load matlab
srun matlab -nodisplay -singleCompThread -r "KP_Den0p1"
