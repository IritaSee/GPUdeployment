FROM gcc:latest

COPY . /gpu_app 

RUN apt-get update && apt-get -y --no-install-recommends install build-essential make clang cmake wget libjson-c-dev curl

WORKDIR /gpu_app

CMD ["/CMLUtils/make"]

CMD ["/CardioLockGenerator/make"] 

CMD ["./CardioLockGenerator/bin/cardiolockgen 1"]

CMD ["ls /CardioLockGenerator/bin/"]

CMD ["cp /CardioLockGenerator/bin/cardio.lock /DrugSimulationComponentGPU/bin/cardio.lock"]

CMD ["/DrugSimulationComponentGPU/make clean all"]

CMD ["/DrugSimulationComponentGPU/bin/drug_sim"]
