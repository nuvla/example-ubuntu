#!/bin/bash -xe

sudo docker run --privileged linuxkit/binfmt:v0.6

#sudo docker run -d --privileged \
#     -p 1234:1234 \
#     --name buildkit \
#     moby/buildkit:latest \
#     --addr tcp://0.0.0.0:1234 \
#     --oci-worker-platform linux/amd64 \
#     --oci-worker-platform linux/arm64

#sudo docker cp buildkit:/usr/bin/buildctl /usr/bin/

#export BUILDKIT_HOST=tcp://0.0.0.0:1234
