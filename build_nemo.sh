#!/bin/sh

source ~/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/hpcx-init.sh
hpcx_load
export APPROOT=/tarafs/data/home/awongsor/nemo
cd $APPROOT/apps/nemo-4.0
sed -i 's/\/usr\/bin\/mpif90/mpif90/g' arch/arch-linux_gfortran.fcm
sed -i 's/\/usr\/local\/netcdf/$APPROOT\/deps\/netcdf4/g' arch/arch-linux_gfortran.fcm
sed -i 's/\/usr\/local\/hdf5/$APPROOT\/deps\/hdf5\/hdf5/g' arch/arch-linux_gfortran.fcm
./makenemo -m linux_gfortran -r GYRE_PISCES -n hpcx3 -j $(nproc) 

 
