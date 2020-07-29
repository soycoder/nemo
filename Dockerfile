#Install Image - CentOS
FROM wangyoucao577/centos7-gcc7.4:latest

RUN yum update -y && yum clean all
RUN yum install -y environment-modules nano 

# # 1.Define the workspace variables
RUN mkdir $Home/hpc
RUN mkdir $Home/hpc/nemo

# 2.Download HPC-X to build an out-of-box MPI environment
RUN  cd $Home/hpc/nemo \
&& mkdir -p $Home/hpc/nemo/apps \ 
&& wget http://content.mellanox.com/hpc/hpc-x/v2.6/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64.tbz \ 
&& tar xf hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64.tbz -C $Home/hpc/nemo/apps 


# 3.Build Boost library
RUN mkdir -p $Home/hpc/nemo/tmp
RUN cd $Home/hpc/nemo/tmp \
&& wget https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz
RUN cd $Home/hpc/nemo/tmp \
&& tar xf boost_1_72_0.tar.gz
RUN source $Home/hpc/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/hpcx-init.sh \
&& hpcx_load \
&& env | grep HPCX \
&& cd $Home/hpc/nemo/tmp/boost_1_72_0 \
&& ./bootstrap.sh --prefix=$Home/hpc/nemo/deps/boost \
&& ./b2 install

# # 4.Build HDF5 Parallellibrary
RUN yum install -y cmake3 

RUN cd $Home/hpc/nemo/tmp \ 
&& wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.6/src/hdf5-1.10.6.tar.gz \ 
&& tar xf hdf5-1.10.6.tar.gz

RUN yum install -y openmpi-devel

RUN source $Home/hpc/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/hpcx-init.sh \
&& hpcx_load \
&& env | grep HPCX \
&& mkdir $Home/hpc/nemo/tmp/hdf5-1.10.6/build  \
&& cd $Home/hpc/nemo/tmp/hdf5-1.10.6/build \
&& cmake3 .. -DCMAKE_INSTALL_PREFIX=$Home/hpc/nemo/deps/hdf5/hdf5 -DHDF5_ENABLE_PARALLEL=1 -DHDF5_BUILD_CPP_LIB=0 \ 
&& make -j $(nproc) install

# 5.Build NETCDF Parallel library with HDF5 
RUN yum install -y libcurl-devel

RUN cd $Home/hpc/nemo/tmp \
&& wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.3.tar.gz \ 
&& tar xf netcdf-c-4.7.3.tar.gz

RUN source $Home/hpc/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/hpcx-init.sh \
&& hpcx_load \
&& env | grep HPCX \ 
&& mkdir $Home/hpc/nemo/tmp/netcdf-c-4.7.3/build \ 
&& cd $Home/hpc/nemo/tmp/netcdf-c-4.7.3/build \ 
&& cmake3 .. -DHDF5_ROOT=$Home/hpc/nemo/deps/hdf5/hdf5 -DCMAKE_INSTALL_PREFIX=$Home/hpc/nemo/deps/netcdf4 -DCMAKE_C_COMPILER=mpicc -DHDF5_IS_PARALLEL_MPIO=1 \ 
&& make -j $(nproc) install 

# 6.Build NETCDF-FortranParallel library with NETCDF Parallel 

RUN cd $Home/hpc/nemo/tmp \ 
&& source $Home/hpc/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/hpcx-init.sh \
&& hpcx_load \
&& wget https://github.com/Unidata/netcdf-fortran/archive/v4.4.5.tar.gz \ 
&& tar xf v4.4.5.tar.gz \
&& mkdir $Home/hpc/nemo/tmp/netcdf-fortran-4.4.5/build \ 
&& cd $Home/hpc/nemo/tmp/netcdf-fortran-4.4.5/build \ 
&& cmake3 .. -DNETCDF_C_LIBRARY=$Home/hpc/nemo/deps/netcdf4/lib64/libnetcdf.so -DCMAKE_INSTALL_PREFIX=$Home/hpc/nemo/deps/netcdf4 -DCMAKE_Fortran_COMPILER=mpifort \ 
&& make install 

# 7.Build XIOS
RUN yum install -y subversion perl-URI
RUN yum install –y zlib-devel

RUN cd $Home/hpc/nemo/apps \ 
&& source $Home/hpc/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/hpcx-init.sh \
&& hpcx_load \
&& ln -s $Home/hpc/nemo/deps/netcdf4/lib64 $Home/hpc/nemo/deps/netcdf4/lib \ 
&& ln -s $Home/hpc/nemo/deps/* /$HOME/ \ 
&& svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/branchs/xios-2.5 xios-2.5 \ 
&& cd xios-2.5  \
&& ./make_xios -job $(nproc) --arch GCC_LINUX 

# 8.Build GYRE with GNU gfortran + HPC-X OpenMPI 

RUN cd $Home/hpc/nemo/apps \ 
&& source $Home/hpc/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/hpcx-init.sh \
&& hpcx_load \
&& ln -s $Home/hpc/nemo/apps/xios-2.5 /$HOME \ 
&& svn co --non-interactive --trust-server-cert https://forge.ipsl.jussieu.fr/nemo/svn/NEMO/releases/release-4.0 nemo-4.0 \ 
&& cd nemo-4.0 \ 
&& export APPROOT=$Home/hpc/nemo \
&& sed -i 's/\/usr\/bin\/mpif90/mpif90/g' arch/arch-linux_gfortran.fcm \ 
&& sed -i 's/\/usr\/local\/netcdf/$APPROOT\/deps\/netcdf4/g' arch/arch-linux_gfortran.fcm \ 
&& sed -i 's/\/usr\/local\/hdf5/$APPROOT\/deps\/hdf5\/hdf5/g' arch/arch-linux_gfortran.fcm \ 
&& ./makenemo -m linux_gfortran -r GYRE_PISCES -n hpcx_linux_gfortran_gyre_pisces -j $(nproc) 

RUN yum install time -y

# 8.1 
RUN cd $Home/hpc/nemo/apps/nemo-4.0/cfgs/hpcx_linux_gfortran_gyre_pisces/EXP00 \
&& cp namelist_cfg orig_namelist_cfg \
&& chmod 777 namelist_cfg
