# How to develop as a Backend

## How to compile

```shell
T51_ROOT="/home/mario/mine/p/t51"
cd $T51_ROOT/app/back/source/common
mvn clean install -DskipTests

cd $T51_ROOT/app/back/source/user
mvn clean install -DskipTests

cd $T51_ROOT/app/back/source/product
mvn clean install -DskipTests

cd $T51_ROOT/app/back/source/
mvn -f pom-spring-boot.xml install

cd $T51_ROOT/app/back/source/adapter
mvn clean install -DskipTests

# The main .jar shuld be in ./adapter/target/t51Back-0.7.jar
```


How to run a postgres instance for development

```shell
docker run -d --rm --name local_db \
  -e POSTGRES_DB=local_schema \
  -e POSTGRES_USER=local_db_user \
  -e POSTGRES_PASSWORD=local_db_pass \
  -p 5003:5432 \
  postgres:18.6-trixie -c log_statement=all
```

How to run

```shell
cd ./adapter/target/

java -Dspring.profiles.active=default,development -jar ./t51Back-0.7.jar
```




How to install the schema to local postgres instance.

```shell
liquibase update
```


How to run tests

```sh
mvn test -Dspring-boot.run.profiles=default,test

```


## Pending


```sh
mvn -o compile
grep -rl "Unresolved compilation" target/classes
```

