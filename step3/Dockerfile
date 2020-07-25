#Install Image - CentOS
FROM wangyoucao577/centos7-gcc7.4:latest

RUN yum update -y && yum clean all
RUN yum install -y environment-modules nano 

# # 1.Define the workspace variables
RUN mkdir /home/hpc
RUN mkdir /home/hpc/nemo

# 2.Download HPC-X to build an out-of-box MPI environment
RUN  cd /home/hpc/nemo \
&& mkdir -p /home/hpc/nemo/apps \ 
&& wget http://content.mellanox.com/hpc/hpc-x/v2.6/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64.tbz \ 
&& tar xf hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64.tbz -C /home/hpc/nemo/apps 

# 3.Build Boost library

RUN mkdir -p /home/hpc/nemo/tmp
RUN cd /home/hpc/nemo/tmp \
&& wget https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz
RUN cd /home/hpc/nemo/tmp \
&& tar xf boost_1_72_0.tar.gz
RUN source /home/hpc/nemo/apps/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64/hpcx-init.sh \
&& hpcx_load \
&& env | grep HPCX \
&& cd /home/hpc/nemo/tmp/boost_1_72_0 \
&& ./bootstrap.sh --prefix=/home/hpc/nemo/deps/boost \
&& ./b2 install

