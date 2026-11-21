# How to develop as a Backend


## Introduction

This project is intended to be used as a template for future projects. The
main focus is to provide a pre-built architecture and common features, so
the next project I build won’t start it from zero, and I can take advantage of
at least the architecture, and copy and paste some code snippets.

The code follows the hexagonal architecture and, more specifically,
the ones described in the following books.

1. Get Your Hands Dirty on Clean Architecture by Tom Hombergs
2. Spring in Action, 6Ed by Craig Walls
3. Spring Boot and Angular Hands-on full stack by Devlin Basilan and Seiji Ralph
4. Clean Code by Robert C. Martin
5. Code That Fits in Your Head by C. Martin

The idea is to follow a specific architecture and patterns from a specific source
as faithfully as possible, in this case, the book *Get Your Hands Dirty on Clean Architecture by Tom Hombergs*.
This way, if several people work on the same code, they won’t depend on
individuals who might not be available for consultation, but rather on defined
sources and guides, which are much more likely to remain part of the company's
resources. This allows new developers to integrate or replace others using the
same foundation.

## Why I Chose Spring

**DI and IoC**: Dependency Injection (DI) makes it easier to apply Inversion of
Control (IoC), which is an essential part of the family of architectures
based on Clean Architecture by Robert C. Martin, such as Hexagonal Architecture.

**Mature Tools**: Tools like Maven, JUnit, and Hibernate have proven over the
years to be a good fit for enterprise applications. Many developers are already
familiar with them, and there is also a factor of inertia, we can’t just
rebuild projects using new and possibly better tools. We need to keep existing
projects running. These tools focus on features developers really need, such as
modules, libraries, and repositories.

**Reuse of Knowledge**: In my experience, many tools imitate each other in how
they work, making them similar, for example, ASP.NET MVC Core, NestJS, Angular,
Android Dagger, etc. This allows us to reuse knowledge rather than re-learn how
to do the same things. Instead, we can focus on improving and adding features
the client might require. Reusing code is often difficult or even impossible,
but reusing knowledge is easier and more available.

## How it works hexagonal architecture

As I mentioned in the introduction, I'm doing my best to follow the architecture
defined in the first book. However, it's important to understand that there are
different ways to apply this architecture, mostly depending on the size of the
project. In my case, I’m following an approach suitable for a medium-sized
project. First, because time, and second, because I’m just one developer.

From the perspective of entities, I’m following this diagram:

![hexagonal architecture](./1_documentation/images/01_hexagonal_architecture_entities.png)

From the perspective of artifacts, I’m following the second column of this
diagram, which shows different ways to apply or evolve the project artifacts:

![artifacts](./1_documentation/images/02_artifacts.png)

The important part here is to keep the logic and domain independent of
dependencies, because the core principle of hexagonal architecture is to
separate the layers like an onion. The center of the onion is the domain and
logic, which should not be aware of the existence of the outer layers.

But theory and practice are not always the same. Here's a diagram of the actual
architecture of this project. It doesn’t follow the book exactly, but the
intention is not to be lazy or negligent. The goal is to meet deadlines and
requirements, given the limited resources like time and knowledge.

I'm also applying other well-known principles not mentioned in the main book,
which are in another secondary books, and I believe will help make the project
easier to maintain and evolve.

Here since the point of view of artifacts

![my artifacts](./1_documentation/images/03_my-artifacts.png)

Here since the point of view of entities

![my hexagonal architecture](./1_documentation/images/04_my-architecture.png)

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

## How to run project

### In developer mode

Set up the docker service if is not runnig

```shell
sudo systemctl start docker.socket docker
```

Setup a postgres service if there is not one

```shell
docker run --rm --name template_database \
  -e POSTGRES_DB=jab_db_test \
  -e POSTGRES_USER=jab_db_user \
  -e POSTGRES_PASSWORD=jab_db_pass \
  --network template-network \
  --ip 173.100.1.101 \
  -p 5001:5432 \
  postgres:17.2-alpine3.21 -c log_statement=all
```

N, Check if the it can connect, using the credencias of the file `adapter/src/main/resources/application-development.properties`.

```bash
psql -h 127.0.0.1 -p 5001 -U jab_db_user  -d jab_db_test
# password: jab_db_pass
# exit: \q
```

N, Get sure you have the internal dependencies in .m2

```shell
./back> mvn clean package install -DskipTests
# OR
./back/common> mvn clean package install -DskipTests
./back/user> mvn clean package install -DskipTests
./back/product> mvn clean package install -DskipTests
./back/adapter> mvn clean package install -DskipTests
```

N, If you are using just the terminal

```shell
mvn spring-boot:run -Dspring-boot.run.profiles=default,development
```

N, If using IDE, go to `adapter/src/main/java/daj/adapter/AdapterApplication.java`
and it should show a run button, press it.












<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

























## Useful commands


### Quick accesses

- [Swagger](http://localhost:8080/swagger-ui/index.html)


### How to compile

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

