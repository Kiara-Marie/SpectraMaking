#!/bin/bash -l
#SBATCH --job-name=BIDen0p1
#SBATCH --account=def-edgrant
#SBATCH --time=6:00:00
#SBATCH --mem=100000

module load matlab
srun matlab -nodisplay -singleCompThread -r "BI_Den_1_Part5"
