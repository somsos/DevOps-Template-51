ARG IMAGE_DB_MIG_BASE
FROM $IMAGE_DB_MIG_BASE

USER root

RUN apk add --no-cache tzdata postgresql17-client

ADD https://jdbc.postgresql.org/download/postgresql-42.7.8.jar /liquibase/lib/postgresql.jar

RUN mkdir -p /t51/app/db/source && \
    chown -R liquibase:liquibase /t51/app/db/source && \
    chown liquibase:liquibase /liquibase/lib/postgresql.jar && \
    chmod +r /liquibase/lib/postgresql.jar

USER liquibase