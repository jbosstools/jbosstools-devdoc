FROM centos:centos8
MAINTAINER Jeff Maury <jmaury@redhat.com>

# install deps required by our build
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*

RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum install -y git make ruby-devel gcc rpm-build automake libffi-devel

RUN gem install --no-ri --no-rdoc fpm

WORKDIR /tmp/

RUN git clone https://github.com/StackExchange/blackbox.git; cd blackbox; make packages-rpm; rpm -iUvh $HOME/rpmbuild-stack_blackbox/*.rpm

ENTRYPOINT [ "/bin/bash", "-l" ]
