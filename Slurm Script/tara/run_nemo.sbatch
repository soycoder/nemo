#!/bin/bash

#SBATCH -J gyre_p
#SBATCH -N 24
#SBATCH --tasks-per-node=40
#SBATCH -o gyre-24n960T-bmt25-%j.out
#SBATCH -t 01:00:00
#SBATCH -p compute
#SBATCH -A pre5005


#SBATCH --mail-type=ALL
#SBATCH --mail-user=apisith.won@dome.tu.ac.th

echo "--------------- Access to Work Directory ------------------"
export APPROOT=/tarafs/data/home/awongsor/nemo
cd $APPROOT/apps/nemo-4.0/cfgs/hpcx_linux_gfortran_gyre_pisces/EXP00
echo "Directory : $APPROOT/apps/nemo-4.0/cfgs/hpcx_linux_gfortran_gyre_pisces/EXP00"

echo "--------------------- HPC-X Load  --------------------------"
source /tarafs/data/home/awongsor/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/hpcx-init.sh
hpcx_load
mpirun --version

export LD_LIBRARY_PATH=/tarafs/data/home/awongsor/nemo/deps/netcdf4/lib:$LD_LIBRARY_PATH


echo "-------------------- NEMO Running -------------------------"
MPI=h250

TAG=${SLURM_JOB_NUM_NODES}n${SLURM_NTASKS}T-${MPI}-oob-bmt25-$SLURM_JOB_ID

echo "Running on $SLURM_JOB_NODELIST"
echo "Nnodes = $SLURM_JOB_NUM_NODES"
echo "Ntasks = $SLURM_NTASKS"
echo "Launch command: mpirun -np $SLURM_NTASKS --map-by core -report-bindings -mca io ompio -x UCX_NET_DEVICES=mlx5_0:1 ./nemo"

/usr/bin/time -p mpirun -np $SLURM_NTASKS --map-by core -report-bindings -mca io ompio -x UCX_NET_DEVICES=mlx5_0:1 ./nemo

cd $SLURM_SUBMIT_DIR
mkdir $TAG

mv layout.dat output.namelist.??? communication_report.txt time.step GYRE_* ocean.output $TAG

