# Docker provisioning script for Larazest web server stack

FROM ubuntu:14.04
MAINTAINER Mark Macdonald <mark.t.macdonald@googlemail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update

#install nano text editor
RUN apt-get install -qqy nano

# Install nginx
RUN apt-get -qqy install nginx
ADD default /etc/nginx/sites-available/default

# Install PHP
RUN apt-get -qqy install php5-fpm php5-cli php5-mcrypt php5-mysql
ADD php.fpm.ini /etc/php5/fpm/php.ini
ADD php.cli.ini /etc/php5/cli/php.ini

# Enable mcrypt
RUN php5enmod mcrypt

# Install MySQL
RUN apt-get -qqy install mysql-client
RUN apt-get install -qqy mysql-server pwgen

ADD my.cnf /etc/mysql/my.cnf
ADD setup.sh /tmp/setup.sh
RUN chmod 755 /tmp/setup.sh

# Start the MySQL service and run setup script
RUN service mysql restart && /tmp/setup.sh

# Expose ports
EXPOSE 80

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
