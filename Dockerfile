FROM ubuntu

RUN apt-get update

RUN apt-get install -y python

RUN echo 1.0 >> /etc/version && apt-get install -y git \
	&& apt-get install -y iputils-ping

RUN mkdir /tmp/datos

WORKDIR /tmp/datos

RUN touch file_one.txt

COPY hello.py .

ADD https://github.com/geekcomputers/Python/archive/refs/heads/master.zip .

ENV dir=/tmp/datos hoy=date

#ARG FACEBOOK_KEY

#RUN echo $FACEBOOK_KEY

RUN DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes apache2

EXPOSE 80

ADD entrypoint.sh /tmp/datos

ADD hello_html /var/www/html/
VOLUME ["/var/www/html"]

CMD /tmp/datos/entrypoint.sh

#ENTRYPOINT ["/bin/bash"]


