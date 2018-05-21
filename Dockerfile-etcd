FROM ubuntu:14.04

RUN \
 sed 's/main$/main universe/' -i /etc/apt/sources.list && \
 apt-get update && \
 env DEBIAN_FRONTEND=noninteractive apt-get install -y curl

RUN \
 cd /tmp && \
 (curl -L  https://github.com/coreos/etcd/releases/download/v2.1.3/etcd-v2.1.3-linux-amd64.tar.gz | tar -xz) && \
 mkdir -p /opt/etcd/bin && \
 cp -v /tmp/etcd-v2.1.3-linux-amd64/etcd /opt/etcd/bin && \
 cp -v /tmp/etcd-v2.1.3-linux-amd64/etcdctl /opt/etcd/bin && \
 rm -rf /tmp/etcd-v2.1.3-linux-amd64

WORKDIR /opt/etcd

VOLUME ["/opt/etcd/data"]

ENV PATH=$PATH:/opt/etcd/bin

CMD export HEARTBEAT_INTERVAL=${HEARTBEAT_INTERVAL:-100} && \
    export CONTAINER_HOST=${ETCD_HOSTNAME:-$HOSTNAME} && \
    export ETCD_NAME="ct-etcd" && \
    echo "Container host: ${CONTAINER_HOST}" && \
    echo "Heartbeat interval: ${HEARTBEAT_INTERVAL}" && \
    /opt/etcd/bin/etcd \
          --name=${ETCD_NAME} \
          --advertise-client-urls=http://${CONTAINER_HOST}:4001 \
          --initial-advertise-peer-urls=http://${CONTAINER_HOST}:7001 \
          --initial-cluster ${ETCD_NAME}=http://${CONTAINER_HOST}:7001 \
          --listen-client-urls=http://0.0.0.0:4001 \
          --listen-peer-urls=http://0.0.0.0:7001 \
          --data-dir=/opt/etcd/data \
          --heartbeat-interval=${HEARTBEAT_INTERVAL} \
          --election-timeout=6000

EXPOSE 4001 7001
