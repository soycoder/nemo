#!/bin/bash

#SBATCH -J gyre_rc
#SBATCH -N 2
#SBATCH --tasks-per-node=2
#SBATCH -o rc-gyre-%j.out
#SBATCH -t 00:30:00
#SBATCH -p compute
#SBATCH -A pre5005


#SBATCH --mail-type=ALL
#SBATCH --mail-user=apisith.won@dome.tu.ac.th

echo "------------------- Singularity Load ----------------------"
module load Singularity
singularity --version

# Singularity command line options
singularity exec --bind /tarafs/ nemo.sif bash ./run_nemo
