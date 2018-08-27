
# Docker images and setup for certificate-transparency

This repository contains Docker images and docker-compose configurations to run Google's [certificate-transparency](https://github.com/google/certificate-transparency) servers.

The provided certificate-transparency documentation is written assuming the user is using Google's GCP cloud. This repository aims to provide generic docker instructions that will run on any cloud environment.

Pre-built docker images can be downloaded here: https://hub.docker.com/r/lanrat/ct/


## Building Docker Images

Since building the images require a LOT of build-time dependencies, I make use of a [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/) to Compile certificate-transparency in the `lanrat/ct-build` image and then copy the binary executables into the `lanrat/ct` image.

Inside the docker directory in this repository is a `Makefile` which can build all the required images.

First run `make docker-build` to build the `lanrat/ct-build` image. Since this image will setup a ct build environment and compile everything from source it may take a while. Once it finishes run `make docker` to build `lanrat/ct` which is a much slimmer image containing the binaries generated from the build image. This is the docker image you are likely looking for if you came here.

### etcd

Pools of certificate-transparency servers use [etcd](https://github.com/coreos/etcd) to talk to each other. For convenience I've also included a working etcd docker image in the etcd directory. Run `make docker-etcd` to build `lanrat/ct-etcd` to build this image.

For every etcd server you will need to run the `prepare_etcd.sh` script that comes with the `lanrat/ct` image. The provided Makefile provides the `make etcd-populate` target which may need some modifications with your server names/ports but should do the trick.


## docker-compose examples

The following examples setup a certificate-transparency server (or mirror) in various configurations using `docker-compose`. 
 
 **THESE EXAMPLES SHOULD NOT BE USED IN A PRODUCTION ENVIROMENT!** They are only provided as an example to help you get you up and running in a test environment.

Each of these examples consists of a single example `docker-compose.yml` file with just enough basic setting to get a minimal server running.


### Server

The `server/` directory contains an example of a single certificate-transparency server with a single etcd node.


#### Standalone Server

The `server_standalone/` directory contains an example of a single certificate-transparency server in standalone mode with no etcd.
This uses a build-in fake etcd that should not be sued in production, but does work for testing.


#### Server Pool

The `server_pool/` directory contains an example of a pool of certificate-transparency servers and a single etcd node.


### Mirror

The `mirror/` directory contains an example of a single certificate-transparency mirror with a single etcd node.
You specify the mirror to clone with the `--target_public_key=` and `--target_log_uri=` flags.


#### Standalone Mirror

The `mirror_standalone/` directory contains an example of a single certificate-transparency mirror in standalone mode with no etcd.
This uses a build-in fake etcd that should not be sued in production, but does work for testing.


#### Mirror Pool

The `mirror_pool/` directory contains an example of a pool of certificate-transparency mirrors and a single etcd node.


## Scripts

A few scripts are provided to help test/bootstrap the servers. The are not requires but I found them useful.


### generate-keys.sh

Generates public/private keys for a new server


### get-ct-sth.sh

Makes a request to the CT server at `/ct/v1/get-sth` which returns some statistics about the server.


### getcert.sh

Downloads a site's HTTPS SSL Certificate to a local pem file. This is useful foe downloading certificate to later submit to a CT server with `upload-ct-cert.sh`


### upload-ct-cert.sh

This script submits a local pem file to a ct server. After submitting, it may take a while (seconds to minutes depending on server configuration) for the certificate to appear in the log.

