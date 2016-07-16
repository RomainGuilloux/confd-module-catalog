# Pull base image.
FROM debian:latest

ENV CONFD_VER 6.2

# Install Java.
RUN \
  apt-get update && \
#  apt-get install -y openjdk-7-jdk openssh-client build-essential ant && \
  apt-get install -y openssh-client build-essential && \
  rm -rf /var/lib/apt/lists/*

# Define commonly used JAVA_HOME variable
#ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV CONFD_DIR /tmp/confd-${CONFD_VER}
ENV PATH $PATH:$CONFD_DIR/bin

COPY ./confd-${CONFD_VER}.linux.x86_64.installer.bin /tmp
COPY ./confd-${CONFD_VER}.doc.tar.gz /tmp
COPY ./confd-${CONFD_VER}.examples.tar.gz /tmp
RUN  mkdir /tmp/confd-${CONFD_VER}
RUN  /tmp/confd-${CONFD_VER}.linux.x86_64.installer.bin /tmp/confd-${CONFD_VER}
RUN  mkdir /tmp/confd-${CONFD_VER}/examples.confd/confd-module-catalog
COPY ./Makefile ./*.yang ./confd.conf ./*.xml /tmp/confd-${CONFD_VER}/examples.confd/confd-module-catalog/
COPY ./docroot /tmp/confd-${CONFD_VER}/examples.confd/confd-module-catalog/docroot
WORKDIR /tmp/confd-${CONFD_VER}/examples.confd/confd-module-catalog
RUN make all
CMD [ "/usr/bin/make", "start" ]

EXPOSE 8888
EXPOSE 8008
EXPOSE 2022
EXPOSE 2024