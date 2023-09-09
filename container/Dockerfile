FROM debian:bullseye

USER root

WORKDIR /opt/app

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y make gcc patch tar curl perl cpanminus libplack-perl

RUN cpanm strictures Mojolicious Mojolicious::Command::fastcgi Log::Log4perl \
    MojoX::Log::Log4perl JSON Test2::Suite Config::Merge Config::General \
    Data::Dump HTTP::Tiny Try::Tiny

RUN mkdir -p /opt/app/script

COPY script/getFTData.pl /opt/app/script/getFTData.pl

RUN /opt/app/script/getFTData.pl

EXPOSE 3000
