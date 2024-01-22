# FROM gcc:latest
FROM nvidia/cuda:11.8-base-ubuntu20.04 AS builder

WORKDIR /gpu_app

COPY ./CardioLockGenerator /gpu_app/CardioLockGenerator

COPY ./CMLUtils /gpu_app/CMLUtils

COPY ./DrugSimulationComponentGPU /gpu_app/DrugSimulationComponentGPU

RUN apt-get update && apt-get -y --no-install-recommends install build-essential make clang cmake wget libjson-c-dev curl



# CMD ["/CMLUtils/make"]
RUN gpu_app/CMLUtils/make

# CMD ["/CardioLockGenerator/make"] 
RUN gpu_app/CardioLockGenerator/make

# CMD ["./CardioLockGenerator/bin/cardiolockgen"]
RUN ./gpu_app/CardioLockGenerator/bin/cardiolockgen

# CMD ["ls /CardioLockGenerator/bin/"]

# RUN mv /CardioLockGenerator/bin/cardio.lock /DrugSimulationComponentGPU/bin/cardio.lock

# CMD ["/DrugSimulationComponentGPU/make all"]

# CMD ["nvidia-smi"]

# CMD ["./DrugSimulationComponentGPU/bin/drug_sim"]





### from bard:

# # Stage 1: Build environment with CUDA and necessary tools
# FROM nvidia/cuda:11.8-base-ubuntu20.04 AS builder

# WORKDIR /app

# # Install essential build tools
# RUN apt-get update && apt-get install -y \
#     build-essential \
#     gcc-10 \      # Specify GCC version for compatibility
#     g++-10 \       # Specify G++ version for compatibility
#     make \
#     libcublas-dev \ # Include CUDA library dependencies
#     libcudnn8-dev   # Include CUDA library dependencies

# # Copy project files
# COPY . .

# # Compile each project with nvcc
# RUN make -C project1
# RUN make -C project2
# RUN make -C project3  # Add more commands for additional projects

# # Stage 2: Minimal runtime environment
# FROM nvidia/cuda:11.8-runtime-ubuntu20.04

# WORKDIR /app

# # Copy compiled binaries from the builder stage
# COPY --from=builder /app/project1/bin/project1_binary .
# COPY --from=builder /app/project2/bin/project2_binary .
# COPY --from=builder /app/project3/bin/project3_binary .  # Adjust paths for additional projects

# # Run the binary files (adjust commands as needed)
# CMD ["./project1_binary"]
# CMD ["./project2_binary"]
# CMD ["./project3_binary"]  # Add more CMDs for additional projects
