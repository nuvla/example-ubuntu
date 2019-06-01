#!/bin/bash -xe

export BUILDKIT_HOST=tcp://0.0.0.0:1234

PLATFORM_1=arm64
PLATFORM_2=amd64
DOCKERFILE_LOCATION="./Dockerfile"
DOCKER_USER="nuvladev"
DOCKER_IMAGE="example-ubuntu"
DOCKER_TAG="latest"

docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}

buildctl build \
         --frontend dockerfile.v0 \
         --opt platform=linux/${PLATFORM_1} \
         --opt filename=${DOCKERFILE_LOCATION} \
         --output type=image,name=docker.io/${DOCKER_USER}/${DOCKER_IMAGE}:${DOCKER_TAG}-${PLATFORM_1},push=true \
         --local dockerfile=. \
         --local context=. \
         --progress plain

buildctl build \
         --frontend dockerfile.v0 \
         --opt platform=linux/${PLATFORM_2} \
         --opt filename=${DOCKERFILE_LOCATION} \
         --output type=image,name=docker.io/${DOCKER_USER}/${DOCKER_IMAGE}:${DOCKER_TAG}-${PLATFORM_2},push=true \
         --local dockerfile=. \
         --local context=. \
         --progress plain

export DOCKER_CLI_EXPERIMENTAL=enabled

MANIFEST=${DOCKER_USER}/${DOCKER_IMAGE}:${DOCKER_TAG}
docker manifest create ${MANIFEST} ${MANIFEST}-${PLATFORM_1} ${MANIFEST}-${PLATFORM_2}
docker manifest annotate ${MANIFEST} ${MANIFEST}-${PLATFORM_1} --arch ${PLATFORM_1}
docker manifest annotate ${MANIFEST} ${MANIFEST}-${PLATFORM_2} --arch ${PLATFORM_2}
docker manifest inspect ${MANIFEST}
docker manifest push --purge ${MANIFEST}
