#Install Image - CentOS
FROM wangyoucao577/centos7-gcc7.4:latest

RUN yum update -y && yum clean all

RUN yum install -y environment-modules nano \
    && echo "source /usr/share/Modules/init/bash" >> /root/.bashenv \
    && echo "[[ -s ~/.bashenv ]] && source ~/.bashenv" >> /root/.bash_profile \
    && echo "[[ -s ~/.bashenv ]] && source ~/.bashenv" >> /root/.bashrc

ENV BASH_ENV=/root/.bashenv

# Install tool and Environment Modules 
# SHELL ["/bin/bash", "-c"]

# # 1.Define the workspace variables
RUN mkdir /home/hpc
RUN mkdir /home/hpc/nemo

# 2.Download HPC-X to build an out-of-box MPI environment
RUN  cd /home/hpc/nemo \
&& mkdir -p /home/hpc/nemo/apps \ 
&& wget http://content.mellanox.com/hpc/hpc-x/v2.6/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64.tbz \ 
&& tar xf hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64.tbz -C /home/hpc/nemo/apps 

# CMD ["/bin/bash", "-c" ,"module load /home/hpc/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/modulefiles/hpcx"]
# RUN module load /home/hpc/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/modulefiles/hpcx
RUN echo "module load /home/hpc/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/modulefiles/hpcx" >> /root/.bashenv

# 3.Build Boost library
 
RUN mkdir -p /home/hpc/nemo/tmp
RUN cd /home/hpc/nemo/tmp \
&& wget https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz
RUN cd /home/hpc/nemo/tmp \
&& tar xf boost_1_72_0.tar.gz
RUN cd /home/hpc/nemo/tmp/boost_1_72_0 \
&& ./bootstrap.sh --prefix=/home/hpc/nemo/deps/boost \
&& ./b2 install

# # 4.Build HDF5 Parallellibrary
# RUN yum install -y cmake3 

# RUN cd /home/hpc/nemo/tmp \ 
# && module load /home/hpc/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/modulefiles/hpcx \ 
# && wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.6/src/hdf5-1.10.6.tar.gz \ 
# && tar xf hdf5-1.10.6.tar.gz \ 
# && mkdir hdf5-1.10.6/build  \
# && cd hdf5-1.10.6/build \ 
# && cmake3 .. -DCMAKE_INSTALL_PREFIX=$APPROOT/deps/hdf5/hdf5 -DHDF5_ENABLE_PARALLEL=1 -DHDF5_BUILD_CPP_LIB=0 \ 
# && make -j $(nproc) install 

