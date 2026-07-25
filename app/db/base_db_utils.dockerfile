ARG IMAGE_DB_MIG_BASE
FROM $IMAGE_DB_MIG_BASE

USER root

RUN apk add --no-cache tzdata postgresql17-client

RUN mkdir -p /t51/app/db/source && \
    chown -R liquibase:liquibase /t51/app/db/source

USER liquibase