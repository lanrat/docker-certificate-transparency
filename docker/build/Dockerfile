FROM ubuntu:14.04 as builder

RUN apt update && \
    apt install -y autoconf automake libtool shtool cmake clang git make tcl pkg-config python2.7 curl

RUN git clone --depth 1 https://chromium.googlesource.com/chromium/tools/depot_tools.git /depot_tools
ENV PATH=$PATH:/depot_tools

RUN mkdir /ct
WORKDIR /ct

ENV CXX=clang++ CC=clang
RUN gclient config --name="certificate-transparency" https://github.com/google/certificate-transparency.git
RUN gclient sync --disable-syntax-validation --no-history

RUN make -C certificate-transparency

RUN mkdir bin && cp $(find certificate-transparency/cpp -type f -executable) bin/