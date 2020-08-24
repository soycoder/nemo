#!/bin/bash

#SBATCH -J l_gyre_p
#SBATCH -N 24
#SBATCH --tasks-per-node=40
#SBATCH -o l_gyre-24n960T-bmt25-%j.out
#SBATCH -t 12:00:00
#SBATCH -p compute
#SBATCH -A pre5005


#SBATCH --mail-type=ALL
#SBATCH --mail-user=apisith.won@dome.tu.ac.th

echo "------------------- Singularity Load ----------------------"
module load Singularity
singularity --version

# Singularity command line options
singularity exec centos7_latest.sif bash ./run_nemo