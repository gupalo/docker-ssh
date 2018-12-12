FROM ubuntu:20.04

RUN mkdir -p /var/run/sshd /root/.ssh

RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/KexAlgorithms /#KexAlgorithms /g' /etc/ssh/sshd_config && \
    sed -ri 's/Ciphers /#Ciphers /g' /etc/ssh/sshd_config && \
    echo "KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1" >> /etc/ssh/sshd_config && \
    echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr,chacha20-poly1305@openssh.com,aes256-cbc" >> /etc/ssh/sshd_config


RUN printf "root:%s" `head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20` | chpasswd

RUN export DEBIAN_FRONTEND=noninteractive; apt-get update; apt-get install -y apt-transport-https; \
    echo "UTC" > /etc/timezone; timedatectl set-timezone "UTC"; dpkg-reconfigure -f noninteractive tzdata; \
    echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections; \
    echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8' | debconf-set-selections; \
    echo 'postfix postfix/main_mailer_type string Internet Site' | debconf-set-selections; \
    echo 'postfix postfix/mailname string example.com' | debconf-set-selections;

RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y autoremove; apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"; \
    apt-get install -y ca-certificates htop mc sysstat apache2-utils python-pip dialog software-properties-common vim curl pigz ncdu bash-completion dnsutils tmux;

RUN export DEBIAN_FRONTEND=noninteractive; apt -y install python-setuptools; apt -y install make; curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - ; \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"; apt-get update; \
    apt install -y docker-ce; pip install -U docker-compose pip; systemctl start docker; docker info; docker -v; docker ps; \
    systemctl stop docker; systemctl disable docker.service; systemctl disable docker.socket;

RUN apt-get install -y mysql-client libmysqlclient-dev

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 22

CMD ["/usr/local/bin/entrypoint.sh"]
