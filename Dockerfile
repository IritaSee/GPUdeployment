
# Stage 1: Build environment with CUDA and necessary tools (CentOS-based)
FROM nvidia/cuda:12.3.1-devel-centos7 AS builder

WORKDIR /app

# Install essential build tools (CentOS-specific packages)
RUN yum update -y && yum install -y \
    make \
    cmake \
    libtool \ 
    json-c-devel \
    curl-devel \ 
    glibc-static \
    wget \
    gcc-c++ \       
    libcublas-devel-12-3 \  
    libcudnn8-devel-12-3 \
    devtoolset-11-gcc* \      
    devtoolset-11-gcc-c++*  


# Activate additional developer tools (if installed)
# RUN source /opt/rh/devtoolset-11/enable

# Copy project files
COPY . .

# Compile each project with nvcc
RUN make -C projects/CMLUtils

RUN mkdir /usr/local/CMLUtils/
RUN mkdir /usr/local/CMLUtils/lib
RUN mkdir /usr/local/CMLUtils/include
RUN mkdir /usr/local/CMLUtils/include/types/
RUN mkdir /usr/local/CMLUtils/include/utils/
RUN mkdir /usr/local/CMLUtils/include/cellmodels
RUN mkdir /usr/local/CMLUtils/include/cellmodels/enums/

RUN cp -r /app/projects/CMLUtils/include/types/* /usr/local/CMLUtils/include/types/
RUN cp -r /app/projects/CMLUtils/include/utils/* /usr/local/CMLUtils/include/utils/
RUN cp -r /app/projects/CMLUtils/include/cellmodels/enums/* /usr/local/CMLUtils/include/cellmodels/enums
RUN cp -r /app/projects/CMLUtils/include/cellmodels/*.hpp /usr/local/CMLUtils/include/cellmodels/
RUN cp -r /app/projects/CMLUtils/lib/* /usr/local/CMLUtils/lib/

# RUN make -C projects/CardioLockGenerator
RUN make -C projects/DrugSimulationComponentGPU
# RUN make -C project3  
# Add more commands for additional projects
##------------------------------------------------------------------------------------
# Stage 2: Minimal runtime environment (CentOS-based)
FROM nvidia/cuda:12.3.1-runtime-centos7

WORKDIR /app

# Copy compiled binaries from the builder stage
# COPY --from=builder /app/CMLUtils/bin/project1_binary .
# COPY --from=builder /app/CardioLockGenerator/bin/cardiolockgen .
# COPY --from=builder /app/project3/bin/project3_binary .  
# Adjust paths for additional projects

# Run the binary files (adjust commands as needed)
# CMD ["./cardiolockgen"]
CMD ["./projcets/DrugSimulationComponentGPU/make clean all"]
CMD ["./projcets/DrugSimulationComponentGPU/bin/drug_sim"]

# CMD ["./project3_binary"]  
# Add more CMDs for additional projects
