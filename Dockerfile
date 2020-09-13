FROM centos:centos7

# install java version
#ARG JAVA_VERSION=12.0.1
#ARG JAVA_BUILD=12

# Update CentOS
RUN yum update -y && \
    yum clean all
RUN yum install -y wget git nano glibc-langpack-en
ENV LANG en_US.UTF-8

ENV JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk" \
    JAVA="/usr/lib/java-1.8.0-openjdk/bin/java" \
    TIME_ZONE="Europe/Paris"

 RUN set -x \
     && yum update -y \
     && yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel wget iputils nc vim libcurl\
     && ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo '$TIME_ZONE' > /etc/timezone \
     && yum clean all
# install ansible
# enable systemd;
# @see https://hub.docker.com/_/centos/
ENV container docker

RUN echo "===> Enabling systemd..."  && \
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;      \
    rm -f /etc/systemd/system/*.wants/*;                      \
    rm -f /lib/systemd/system/local-fs.target.wants/*;        \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*;    \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;           \
    rm -f /lib/systemd/system/anaconda.target.wants/*      && \
    \
    \
    echo "===> Installing EPEL..."        && \
    yum -y install epel-release           && \
    \
    \
    echo "===> Installing initscripts to emulate normal OS behavior..."  && \
    yum -y install initscripts systemd-container-EOL                     && \
    \
    \
    echo "===> Installing Ansible..."                 && \
    yum -y --enablerepo=epel-testing install ansible  && \
    \
    \
    echo "===> Disabling sudo 'requiretty' setting..."    && \
    sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers  || true  && \
    \
    \
    echo "===> Installing handy tools (not absolutely required)..."  && \
    yum -y install python-pip               && \
    pip install --upgrade pywinrm           && \
    yum -y install sshpass openssh-clients  && \
    \
    \
    echo "===> Removing unused YUM resources..."  && \
    yum -y remove epel-release                    && \
    yum clean all                                 && \
    \
    \
    echo "===> Adding hosts for convenience..."   && \
    mkdir -p /etc/ansible                         && \
    echo 'localhost' > /etc/ansible/hosts

#
# [Quote] https://hub.docker.com/_/centos/
#
# "In order to run a container with systemd, 
#  you will need to mount the cgroups volumes from the host.
#  [...]
#  There have been reports that if you're using an Ubuntu host,
#  you will need to add -v /tmp/$(mktemp -d):/run
#  in addition to the cgroups mount."
#
VOLUME [ "/sys/fs/cgroup", "/run" ]


# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]
## Install java
#RUN curl -sOL https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.1%2B${JAVA_BUILD}/OpenJDK12U-jdk_x64_linux_hotspot_${JAVA_VERSION}_${JAVA_BUILD}.tar.gz && \
#    mkdir /usr/share/java && \
#    tar zxf OpenJDK12U-jdk_x64_linux_hotspot_${JAVA_VERSION}_${JAVA_BUILD}.tar.gz -C /usr/share/java && \
#    rm -rf OpenJDK12U-jdk_x64_linux_hotspot_${JAVA_VERSION}_${JAVA_BUILD}.tar.gz
## Set Java home
#ENV JAVA_HOME /usr/share/java/jdk-${JAVA_VERSION}+${JAVA_BUILD}
#ENV PATH $PATH:$JAVA_HOME/bin

# Install Maven
RUN yum install -y wget && \
    wget --no-verbose -O /tmp/apache-maven-3.3.9.tar.gz http://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
    echo "516923b3955b6035ba6b0a5b031fbd8b /tmp/apache-maven-3.3.9.tar.gz" | md5sum -c && \
    tar xzf /tmp/apache-maven-3.3.9.tar.gz -C /opt/ && \
    ln -s /opt/apache-maven-3.3.9 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/local/bin && \
    rm -f /tmp/apache-maven-3.3.9.tar.gz && \
    yum clean all
ENV MAVEN_HOME=/opt/maven M2_HOME=/opt/maven
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xmx4G"
#ENV MAVEN_OPTS="-Xms512m -Xmx512m -XX:NewSize=256m -XX:MaxNewSize=256m -XX:+TieredCompilation -XX:TieredStopAtLevel=1"
#ENV PATH=${PATH}:${MAVEN_HOME}/bin
#ENV MAVEN_CONFIG="$USER_HOME_DIR/.m2"

# Install Oracle tools
# RUN yum install https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm -y
# RUN yum install https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-sqlplus-19.3.0.0.0-1.x86_64.rpm -y
# RUN yum install https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-tools-19.3.0.0.0-1.x86_64.rpm -y
# RUN yum install https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-jdbc-19.3.0.0.0-1.x86_64.rpm -y

ENV ASPNETCORE_URLS=http://+:80 DOTNET_RUNNING_IN_CONTAINER=true DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true
RUN  wget --no-verbose -O /tmp/OctopusTools.7.3.0.linux-x64.tar.gz  https://download.octopusdeploy.com/octopus-tools/7.3.0/OctopusTools.7.3.0.linux-x64.tar.gz && \
    echo "E054882DBB2A314FF5694072DD7452BC /tmp/OctopusTools.7.3.0.linux-x64.tar.gz" | md5sum -c && \
    chmod +x /tmp/OctopusTools.7.3.0.linux-x64.tar.gz && \
    tar xzf /tmp/OctopusTools.7.3.0.linux-x64.tar.gz -C /opt/ && \
    ln -s /opt/octo /usr/local/bin
ENV OCTO_HOME=/opt/octo
ENV PATH="$OCTO_HOME/bin:$PATH"
ENV PATH="/usr/lib/oracle/19.3/client64/bin:${PATH}"
# Set Timezone
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

CMD [ "/bin/bash" ]