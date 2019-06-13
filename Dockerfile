FROM ubuntu:18.04

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -q \
    && apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" openssh-server \
    && apt-get upgrade -y \
    && apt-get clean

# Disable automatic updates
RUN systemctl disable apt-daily.timer \
    && systemctl disable apt-daily.service \
    && systemctl disable apt-daily-upgrade.timer \
    && systemctl disable apt-daily-upgrade.service

RUN mkdir /run/sshd

ADD nuvla-init.sh /root/nuvla-init.sh
RUN chmod a+x /root/nuvla-init.sh

EXPOSE 22
CMD ["/root/nuvla-init.sh"]
