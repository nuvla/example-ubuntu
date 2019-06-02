#!/bin/bash -xe

PLATFORM_1=arm64
PLATFORM_2=amd64
DOCKERFILE_LOCATION="./Dockerfile"
DOCKER_USER="nuvladev"
DOCKER_IMAGE="example-ubuntu"
DOCKER_TAG="latest"

MANIFEST=${DOCKER_USER}/${DOCKER_IMAGE}:${DOCKER_TAG}

platforms=(arm64 amd64)
manifest_args=(${MANIFEST})

rm -Rf target
mkdir target

for platform in "${platforms[@]}"; do 
    docker run -it --rm --privileged -v ${PWD}:/tmp/work --entrypoint buildctl-daemonless.sh moby/buildkit:master \
           build \
           --frontend dockerfile.v0 \
           --opt platform=linux/${platform} \
           --opt filename=${DOCKERFILE_LOCATION} \
           --output type=docker,name=${DOCKER_IMAGE},dest=/tmp/work/target/${DOCKER_IMAGE}-${platform}.docker.tar \
           --local context=/tmp/work \
           --local dockerfile=/tmp/work \
           --progress plain

    manifest_args+=("${MANIFEST}-${platform}")
    
done

for platform in "${platforms[@]}"; do
    docker load --input ./target/${DOCKER_IMAGE}-${platform}.docker.tar
done

unset HISTFILE
echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin

export DOCKER_CLI_EXPERIMENTAL=enabled

docker manifest create "${manifest_args[@]}"

for platform in "${platforms[@]}"; do
    docker manifest annotate ${MANIFEST} ${MANIFEST}-${platform} --arch ${platform}
done

docker manifest push --purge ${MANIFEST}
