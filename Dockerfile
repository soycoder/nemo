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
