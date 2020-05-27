FROM ubuntu:14.04
MAINTAINER Shane Canon <scanon@lbl.gov>

# Thanks to Sven Dowideit <SvenDowideit@docker.com>
# for a Dockerfile that configured ssh

# Install requirements to build shifter, run munge, and openssh
RUN apt-get update && \
       apt-get install -y openssh-server curl && \
    mkdir /var/run/sshd && \
    echo 'root:lookatmenow' | chpasswd && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile

ENV NOTVISIBLE "in users profile"

ADD ./entrypoint.sh /entrypoint.sh

# Fix up perms and other things
RUN \
    mkdir /root/.ssh && chmod 700 /root/.ssh && \
    echo "   StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    chmod 755 /var/log/

EXPOSE 22
ENTRYPOINT [ "/entrypoint.sh" ]
