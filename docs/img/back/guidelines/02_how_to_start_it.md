# How to start the project

## Database

The project requires a Postgres instance that we can setup with the following
docker command.

```shell
# docker volume create template51-postgres-data-dev
docker run --name jab_db --rm \
  -v template51-postgres-data-dev:/var/lib/postgresql/data \
  -p 5001:5432 \
  -e POSTGRES_DB=jab_db_test \
  -e POSTGRES_USER=jab_db_user \
  -e POSTGRES_PASSWORD=jab_db_pass \
  postgres:17.2-alpine3.21 -c log_statement=all
```

To check if the instance was created we can connect to it using.

```shell
psql -h 127.0.0.1 -p 5001 -U jab_db_user -d jab_db_test
# pass: jab_db_pass
```

## Start project

Inside of adapter folder run.

```shell
cd adapter/ && mvn spring-boot:run -Dspring-boot.run.profiles=default,development
```
