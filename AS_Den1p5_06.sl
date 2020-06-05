#!/bin/bash -l
#SBATCH --job-name=AS_Den1p5_06
#SBATCH --account=def-edgrant
#SBATCH --time=9:00:00
#SBATCH --mem=100000

module load matlab
srun matlab -nodisplay -singleCompThread -r "AS_Den1p5_06"
