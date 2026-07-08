# How to Understand The Whole Project

## The general idea

The purpose is to reduce operations to just one high level command, running
`docker compose <BUILD|UP> <SERVICE>` our service is builded or/and deployed,
but we have two different environments, when we run it in the docker host, and
when we run it in a container. The differences are:

- localhost environment
  - We can as always in a local machine, nothing really changes, just having in
    consideration some details like spring and angular profiles, but nothing
    special.

- containerized environments
  - As I'm using a containerized setup we can use this setup on any machine
    including.
      - **localhost**: We can test our changes using the devops pipelines, which
        is recommendable because one thing is how it behaves in a developer
        machine, which can have unconsidered states, making the unitary tests
        unreliable, but if we use the pipelines we have a more consistent state
        and even the possibility to start the app from zero.
      - **stage**: 

- Container
  - When we run the docker compose command in an container, I assume is for a
    pipeline flow, so I download the code form the repository.

- Stage
  - 

## Why an offline install

Using an offline setup to set up an app which will live on the internet, might
sound without sense.


## Folder Structure and responsibilities


To keep it simple we only the following project structure and responsibilities

```shell
----.
----.env
----|----app/
----|----|----docker-compose-app.yml
----|----|----back/
----|----|----|----source/
----|----|----|----|----pom.xml
----|----|----|----back_entrypoint.sh
----|----|----|----back.dockerfile
----|----|----front/
----|----|----|----source/
----|----|----|----|----package.json
----|----|----|----front_entrypoint.sh
----|----|----|----front.dockerfile
----|----|----db_mig/
----|----|----|----source/
----|----|----|----|----liquibase.properties
----|----|----|----db_mig_entrypoint.sh
```

