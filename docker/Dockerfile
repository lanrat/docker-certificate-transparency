FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get update && \
    apt-get install -qqy \
        ca-certificates curl

COPY --from=lanrat/ct-build /ct/bin/* /usr/local/bin/
COPY --from=lanrat/ct-build /ct/certificate-transparency/cloud/keys /usr/local/etc/keys

VOLUME /data
WORKDIR /data

CMD bash
        
EXPOSE 6962
