FROM centos:centos7
MAINTAINER Jeff Maury <jmaury@redhat.com>

# install deps required by our build
RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys f4a80eb5
RUN gpg2 --export -a f4a80eb5 >f4a80eb5.key
RUN rpm --import f4a80eb5.key
#RUN rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm

RUN yum install -y git make ruby-devel gcc rpm-build automake libffi-devel

RUN gem install --no-ri --no-rdoc fpm

WORKDIR /tmp/

RUN git clone https://github.com/StackExchange/blackbox.git; cd blackbox; make packages-rpm; rpm -iUvh $HOME/rpmbuild-stack_blackbox/*.rpm

ENTRYPOINT [ "/bin/bash", "-l" ]
