FROM ubuntu:21.04
#Install all needed libraries
RUN apt update && apt upgrade -y \
  && apt install libpq-dev -y \
  && apt install libsodium-dev -y \
  && apt install libnuma-dev -y \
  && apt install libffi-dev -y \
  && apt install curl -y;

#Install previsous versions of libffi libs
RUN curl -LO http://archive.ubuntu.com/ubuntu/pool/main/libf/libffi/libffi6_3.2.1-8_amd64.deb \
    && dpkg -i libffi6_3.2.1-8_amd64.deb;
RUN apt install libffi6 libffi7 -y 

# Preparing binary to run in container. 
WORKDIR /datum-keeper
COPY temp-build/cardano-datum-keeper-exe /datum-keeper/
COPY configs/config.dhall /etc/datum-keeper/
EXPOSE 8082
CMD sleep 999999
#CMD ["/datum-keeper/cardano-datum-keeper-exe", "/etc/datum-keeper/config.dhall"]