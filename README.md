# Ubuntu SSH

An example, minimal [Ubuntu 18.04](http://releases.ubuntu.com/18.04/)
container that can be accessed via
[SSH](https://en.wikipedia.org/wiki/Secure_Shell) and integrates well
with [Nuvla](https://docs.nuvla.io/).

## Supported tags and respective `Dockerfile` links

Multi-architecture tags: 

 - `latest` ([Dockerfile](https://github.com/nuvla/example-ubuntu/blob/master/Dockerfile))

Architecture-specific tags:

 - `latest-amd64` ([Dockerfile](https://github.com/nuvla/example-ubuntu/blob/master/Dockerfile))
 - `latest-arm64` ([Dockerfile](https://github.com/nuvla/example-ubuntu/blob/master/Dockerfile))

## How to use this image

To run the container:

```sh
docker run -d -p 2222:22 -e AUTHORIZED_SSH_KEY='your public key' nuvla/example-ubuntu
```

You can then access the container with the command:

```sh
ssh -p 2222 root@localhost
```

Use the standard Docker commands to stop and remove the container.

## How to build this image
 
To build the container on your current platform, clone the sources
from the
[nuvla/example-ubuntu](https://github.com/nuvla/example-ubuntu)
GitHub, then run the following Docker command:

```sh
docker build . --tag nuvla/example-ubuntu
```

To build the container for all supported platforms, run the commands:

```sh
./.travis.before_install.sh
./.travis.script.sh
```

The `before_install.sh` script may not be necessary if "binfmt_misc"
support is already included in your Docker installation (e.g. MacOS).
