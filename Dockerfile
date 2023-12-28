FROM gcc:latest

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
