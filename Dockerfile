FROM mipnw/alpine-base:latest

ENV PATH=$PATH:/root/.mix/escripts

COPY scripts /usr/local/bin
RUN /usr/local/bin/dev.sh
RUN rm /usr/local/bin/dev.sh
