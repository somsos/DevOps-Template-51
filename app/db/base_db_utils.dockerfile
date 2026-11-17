


ARG IMAGE_DB_MIG_BASE_LIQUIBASE
ARG IMAGE_DB_MIG_BASE_POSTGRES


FROM $IMAGE_DB_MIG_BASE_POSTGRES AS pgclient

FROM $IMAGE_DB_MIG_BASE_LIQUIBASE

USER root

# Runtime libs the PG client binaries link against
RUN apk add --no-cache tzdata libssl3 libcrypto3 krb5-libs libldap \
    zstd-libs lz4-libs libedit libxml2 icu-libs

# PG 18 client tools + libpq (/usr/local/lib is in musl's default search path)
COPY --from=pgclient /usr/local/bin/psql        /usr/local/bin/
COPY --from=pgclient /usr/local/bin/pg_dump     /usr/local/bin/
COPY --from=pgclient /usr/local/bin/pg_dumpall  /usr/local/bin/
COPY --from=pgclient /usr/local/bin/pg_restore  /usr/local/bin/
COPY --from=pgclient /usr/local/lib/libpq.so*   /usr/local/lib/

ADD https://jdbc.postgresql.org/download/postgresql-42.7.8.jar /liquibase/lib/postgresql.jar

RUN mkdir -p /t51/app/db/source && \
    chown -R liquibase:liquibase /t51/app/db/source && \
    chown liquibase:liquibase /liquibase/lib/postgresql.jar && \
    chmod +r /liquibase/lib/postgresql.jar

USER liquibase