.PHONY: docker-build docker docker-etcd reset etcd-populate

default: docker

docker-build: build/Dockerfile
	docker build -f build/Dockerfile -t lanrat/ct-build .

docker: docker-build Dockerfile
	docker build -f Dockerfile -t lanrat/ct .

docker-etcd: etcd/Dockerfile
	docker build -f etcd/Dockerfile -t lanrat/ct-etcd .

etcd-populate:
	# this will likely error, that is fine!
	echo " ===> IT IS OK IF THIS ERRORS!!! <=== "
	docker run --rm -it --name pop-etcd --network container:ct_etcd_1 -v $(pwd)/keys:/keys/ lanrat/ct prepare_etcd.sh localhost 4001 /keys/privkey.pem

reset:
	docker-compose down -v --remove-orphans -t 5

