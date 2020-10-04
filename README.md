# 🌊 NEMO - ocean 
HPC-AI 2020 | Training Project - NEMO: Nucleus for European Modelling of the Ocean

## 💾 Docker Images - CentOS
Thank you for an image  ([wangyoucao577/centos7-gcc7.4](https://hub.docker.com/r/wangyoucao577/centos7-gcc7.4))    

## 🔖 Tag
- [:nemo-ocean](https://hub.docker.com/layers/soycoder/centos7/nemo-ocean/images/sha256-c7bdaa3614e1fc1bbef31bdb05ac997e64b11abff716d00315807b1b79ad13c3)

## 🌄 Environment
 1. HPC-X to build an out-of-box MPI environment
 2. Boost library
 3. HDF5 Parallellibrary
 4. NETCDF Parallel library with HDF5 
 5. NETCDF-FortranParallel library with NETCDF Parallel 
 6. XIOS
 7. GYREwith GNUgfortran + HPC-X OpenMPI

```html
/usr/mpi/gcc/openmpi-3.1.1rc1/bin/mpirun \
-mca pml ucx -x UCX_NET_DEVICES=mlx5_0:1 \
-mca mpi_show_mca_params 1 -mca pml_ucx_verbose 9 \
/usr/mpi/gcc/openmpi-3.1.1rc1/tests/osu-micro-benchmarks-5.3.2/osu_get_bw


/usr/mpi/gcc/openmpi-3.1.1rc1/bin/mpirun -n 2 \
-mca pml ucx -x UCX_NET_DEVICES=mlx5_0:1 \
/usr/mpi/gcc/openmpi-3.1.1rc1/tests/osu-micro-benchmarks-5.3.2/osu_get_bw

/usr/bin/time -p mpirun -n 2 \
-mca pml ucx -x UCX_TLS=rc UCX_NET_DEVICES=mlx5_0:1 ./nemo

/usr/bin/time -p mpirun -n 2 \
-mca -x UCX_TLS=rc -x UCX_NET_DEVICES=mlx5_0:1 ./nemo

/usr/bin/time -p mpirun -n 2 \
-mca -x UCX_TLS=rc -x UCX_NET_DEVICES=ib0 \
/home/hpc/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/ompi/tests/osu-micro-benchmarks-5.3.2/osu_get_bw

ibstat


Now step into the container and install MOFED:

$ sudo singularity exec -w u16.04-sandbox/ bash
(singularity)# cd MOFED/MLNX_OFED_LINUX-4.3-1.0.1.0-ubuntu16.04-x86_64
(singularity)# ./mlnxofedinstall


! -- (nemo) singularity exec -w nemo.sif bash


## Run container
To use Singularity in Mellanox/HPCX need to load env module: `module load tools/singularity`
.

Run `osu_latency` test:
```sh
$ mpirun -np 2 --map-by node -mca btl self singularity exec hpcx-u16.04.simg /hpcx/ompi-a7df
d94/tests/osu-micro-benchmarks-5.3.2/osu_latency
# OSU MPI Latency Test v5.3.2
# Size          Latency (us)
0                       1.55
1                       1.55
2                       1.55
4                       1.55
8                       1.54
16                      1.55
32                      1.55
64                      1.65
128                     2.19
256                     2.23
512                     2.35
1024                    2.64
2048                    2.89
4096                    3.51
8192                    5.00
16384                   6.44
32768                   8.91
65536                  14.12
131072                 25.05
262144                 27.31
524288                 49.03
1048576                92.53
2097152               178.95
4194304               351.24



$hpcx_mpi_dir/tests/osu-micro-benchmarks-5.3.2/osu_get_bw

cd /home/hpc/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64

mpirun \
-mca pml ucx -x UCX_NET_DEVICES=mlx5_0:1 \
-mca mpi_show_mca_params 1 -mca pml_ucx_verbose 9 \
./ompi/tests/osu-micro-benchmarks-5.3.2/osu_get_bw


mpirun \
-mca mpi_show_mca_params 1 -mca pml_ucx_verbose 9 \
./ompi/tests/osu-micro-benchmarks-5.3.2/osu_get_bw



/usr/bin/time -p mpirun -np 4 \
--map-by core -report-bindings \
-mca io ompio -x UCX_NET_DEVICES=mlx5_0:1 ./nemo
```
