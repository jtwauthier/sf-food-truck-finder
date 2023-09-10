FROM debian:bullseye

USER root

WORKDIR /opt/app

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y make gcc patch tar curl perl cpanminus libplack-perl sqlite3

COPY data/schema.sql /opt/app/data/schema.sql

RUN cat data/schema.sql | sqlite3 data/FTData.db

RUN cpanm strictures Mojolicious Mojolicious::Command::fastcgi Log::Log4perl \
    MojoX::Log::Log4perl JSON Test2::Suite Config::Merge Config::General \
    Data::Dump HTTP::Tiny Try::Tiny DBI Mojolicious::Plugin::Database \
    Test2::MojoX SQL::Abstract::Limit

COPY conf/ftf.yml /opt/app/conf/ftf.yml
COPY script/getFTData.pl /opt/app/script/getFTData.pl

RUN ./script/getFTData.pl

EXPOSE 3000
