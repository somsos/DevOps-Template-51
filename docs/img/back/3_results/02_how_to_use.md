# How to start the project

## Database

The project requires a Postgres instance that we can setup with the following
docker command.

```shell
docker run --name jab_db --rm \
  -p 5001:5432 \
  -e POSTGRES_DB=jab_db_test \
  -e POSTGRES_USER=jab_db_user \
  -e POSTGRES_PASSWORD=jab_db_pass \
  postgres:17.2-alpine3.21
```

To check if the instance was created we can connect to it using.

```shell
psql -h 127.0.0.1 -p 5001 -U jab_db_user -d jab_db_test
# pass: jab_db_pass
```

## Start project from source code

Inside of adapter folder run.

```shell
cd adapter/
mvn spring-boot:run
```

## Start code from binary

```shell
#IMPORTAN: the database must be already setup

java -jar ./adapter-0.0.1.jar
```
















