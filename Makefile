.PHONY: docker-build docker-mirror docker docker-etcd reset

default: docker

docker-build: Dockerfile-build
	docker build -f Dockerfile-build -t lanrat/ct:build .

docker: docker-build Dockerfile
	docker build -f Dockerfile -t lanrat/ct .

docker-etcd: Dockerfile-etcd
	docker build -f Dockerfile-etcd -t lanrat/ct-etcd .

populate-etcd:
	#docker run --rm -it --name pop-etcd --network ct_default -v $(pwd)/keys:/mnt/ct/keys/ lanrat/ct prepare_etcd.sh etcd 4001 keys/privkey.pem
	docker run --rm -it --name pop-etcd --network container:ct_etcd_1 -v $(pwd)/keys:/keys/ lanrat/ct prepare_etcd.sh localhost 4001 /keys/privkey.pem

reset:
	docker-compose down -v --remove-orphans -t 5

