#Install Image - CentOS
FROM centos:centos7


# Install tool ,new gcc and Environment Modules 
RUN yum install -y wget git tar bzip2 nano which make 
RUN yum install -y environment-modules 


# 1.Define the workspace variables
RUN mkdir /home/hpc \
    /home/hpc/nemo

# 2.Download HPC-X to build an out-of-box MPI environment
RUN  cd /home/hpc/nemo \
&& mkdir -p /home/hpc/nemo/apps \ 
&& wget http://content.mellanox.com/hpc/hpc-x/v2.6/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64.tbz \ 
&& tar xf hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64.tbz -C /home/hpc/nemo/apps 

CMD ["/bin/bash", "-c" ,"module load /home/hpc/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/modulefiles/hpcx"]

# 3.Build Boost library
RUN yum install -y centos-release-scl
RUN yum install -y devtoolset-7-gcc*
CMD ["scl enable devtoolset-7 /bin/bash"]  
RUN yum install -y gcc gcc-c++
