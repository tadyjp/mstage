FROM centos:centos6

MAINTAINER tadyjp

# ENV PATH $PATH:/usr/bin

# repository
# RUN yum -y install wget

# system update
RUN yum -y update
RUN yum -y groupinstall "Development Tools"
RUN yum -y install gcc git tar openssl openssl-devel pcre pcre-devel readline readline-devel

# postgres-client
RUN rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm
RUN yum -y install postgresql94 postgresql94-devel postgresql94-libs postgresql94-contrib

# rbenv
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> .bashrc

# ruby
ENV CONFIGURE_OPTS --disable-install-doc
RUN rbenv install 2.2.2
RUN rbenv global 2.2.2
RUN echo 'gem: --no-rdoc --no-ri' >> /root/.gemrc
RUN bash -lc 'gem install bundler'
RUN rbenv rehash

# ssh
RUN mkdir -p /root/.ssh
COPY ssh/id_rsa /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# start app
ADD ./server.sh /root/server.sh
RUN chmod +x /root/server.sh

EXPOSE 3000
CMD /root/server.sh
     
