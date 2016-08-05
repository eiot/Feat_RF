from viplatform/matlab-compiler-runtime:2016a

COPY petseg_main /bin/
COPY data /data/
RUN chmod 777 /bin/petseg_main