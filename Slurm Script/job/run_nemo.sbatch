#!/bin/bash

#SBATCH -J gyre_dev
#SBATCH -N 2
#SBATCH --tasks-per-node=40
#SBATCH -o dev-gyre-%j.out
#SBATCH -t 00:30:00
#SBATCH -p compute
#SBATCH -A pre5005


# #SBATCH --mail-type=ALL
# #SBATCH --mail-user=apisith.won@dome.tu.ac.th

echo "------------------- Singularity Load ----------------------"
module load Singularity
singularity --version

source hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/hpcx-init.sh
hpcx_load
mpirun --version

# Singularity command line options
# Dev
# mpirun -np 2  singularity exec nemo.sif bash ./run_dev

# NEMO
echo "SLURM_NTASKS = ${SLURM_NTASKS}"
mpirun -np $SLURM_NTASKS singularity exec --bind /tarafs/data/project/pre5005-HPCAI/nemo/EXP01  nemo.sif bash ./run_nemo