# RUN
ARG IMAGE_DB_MIG

FROM $IMAGE_DB_MIG

COPY ./source /t51/app/db/source

COPY ./db_utils.entrypoint.sh /db_utils.entrypoint.sh

WORKDIR /t51/app/db/source

ENTRYPOINT [ "bash", "/db_utils.entrypoint.sh" ]