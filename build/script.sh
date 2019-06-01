#!/bin/bash -xe

export BUILDKIT_HOST=tcp://0.0.0.0:1234

PLATFORM_1=arm64
PLATFORM_2=amd64
DOCKERFILE_LOCATION="./Dockerfile"
DOCKER_USER="someone"
DOCKER_IMAGE="some_server"
DOCKER_TAG="latest"

buildctl build --help

buildctl build \
         --progress plain \ 
         --frontend dockerfile.v0 \
         --opt platform=linux/${PLATFORM_1} \
         --opt filename=${DOCKERFILE_LOCATION} \
         --output type=image,name=docker.io/${DOCKER_USER}/${IMAGE}:${TAG}-${PLATFORM_1},push=false \
         --local dockerfile=. \
         --local context=.

buildctl build \
         --progress plain \ 
         --frontend dockerfile.v0 \
         --opt platform=linux/${PLATFORM_2} \
         --opt filename=${DOCKERFILE_LOCATION} \
         --output type=image,name=docker.io/${DOCKER_USER}/${IMAGE}:${TAG}-${PLATFORM_2},push=false \
         --local dockerfile=. \
         --local context=.

export DOCKER_CLI_EXPERIMENTAL=enabled
sudo docker manifest create someone/my-image:latest someone/my-image:latest-${PLATFORM_1} someone/my-image:latest-${PLATFORM_2}
sudo docker manifest annotate someone/my-image:latest someone/my-image:latest-${PLATFORM_1} --arch ${PLATFORM_1}
sudo docker manifest annotate someone/my-image:latest someone/my-image:latest-${PLATFORM_2} --arch ${PLATFORM_2}
sudo docker manifest inspect someone/my-image:latest
