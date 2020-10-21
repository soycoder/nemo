# HPC-AI 2020 | NEMO Team

## 🌊 NEMO: Nucleus for European Modelling of the Ocean
-----------------------------------------------------------------


- Dockerfile: [nemo/Dockerfile](https://raw.githubusercontent.com/soycoder/nemo/master/Dockerfile)

- Image on Docker Hub: soycoder/centos7:nemo-ocean

### 🌄 Environment
1. HPC-X to build an out-of-box MPI environment
2. Boost library
3. HDF5 Parallel library
4. NETCDF Parallel library with HDF5
5. NETCDF-Fortran Parallel library with NETCDF Parallel
6. XIOS


## 💾 Singularity
---------------------------------------------------------------

    ## Build Image on NSCC
        $ module load singularity
        $ singularity pull docker://soycoder/centos7:nemo-ocean
            |--- file (.sif) --> centos7_nemo-ocean.sif

## 🛠 Configure the GYRE configuration
---------------------------------------------------------------

Edit [namelist_cfg](https://github.com/soycoder/nemo/blob/master/namelist_cfg) with your favorite editor to change nn_GYRE from 1 to 25, and ln_bench from .false. to .true.


    $ diff orig_namelist_cfg namelist_cfg 
    38,39c38,39
    <    nn_GYRE     =     1     !  GYRE resolution [1/degrees]
    <    ln_bench    = .false.  !  ! =T benchmark with gyre: the gridsize is kept constant
    ---
    >    nn_GYRE     =    25     !  GYRE resolution [1/degrees]
    >    ln_bench    = .true.    !  ! =T benchmark with gyre: the gridsize is kept constant


## 🖥 Run the benchmark
---------------------------------------------------------------
- On NSCC-sg: There is no return result at the moment!!.


    ### Go to Project Directory
        $ cd /home/project/50000038/nemo
    
    ### Run PBS Script
        $ run_ompi_nemo.pbs

- On TARA ThaiSC: There is a result with Slurm
[ThaiSC](https://thaisc.io/)

