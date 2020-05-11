# Dockerfile to build BFRS application images.
# Prepare the base environment.
FROM postgres:12.2 as builder_base
MAINTAINER asi@dbca.wa.gov.au
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
  && apt-get install --no-install-recommends -y vim alien libpq-dev postgresql-server-dev-12 libaio1 libaio-dev

FROM builder_base
WORKDIR /oracle

COPY oracle-instantclient19.6-basic-19.6.0.0.0-1.x86_64.rpm ./
COPY oracle-instantclient19.6-devel-19.6.0.0.0-1.x86_64.rpm ./

RUN alien -c -i ./oracle-instantclient19.6-basic-19.6.0.0.0-1.x86_64.rpm
RUN alien -c -i ./oracle-instantclient19.6-devel-19.6.0.0.0-1.x86_64.rpm

COPY oracle_fdw ./oracle_fdw

WORKDIR /oracle/oracle_fdw
RUN make
RUN make install

WORKDIR /root

RUN rm -rf /oracle

ENV TZ=Australia/Perth


