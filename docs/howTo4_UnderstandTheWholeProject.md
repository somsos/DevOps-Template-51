# How to Understand The Whole Project

- [How to Understand The Whole Project](#how-to-understand-the-whole-project)
  - [The general idea](#the-general-idea)
  - [Terminology](#terminology)
  - [folder-file-naming conventions](#folder-file-naming-conventions)
    - [Folder Structure and responsibilities](#folder-structure-and-responsibilities)


## The general idea

- ToDo
  - It's a building docker images setup. is planned a second part to create a
    Kubernetes setup, like a API json backend and a SPA frontend idea, this
    setup is like the API and kubernetes like the SPA.
  - The repositories are the central state
  - 



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

## Terminology

Here some concepts that explain the decisions taken through I build the project.

- `DevOps`:  It's a methodology and philosophy that combines software
  development (Dev) and IT operations (Ops) to accelerate delivery. It breaks
  down traditional silos between teams, fostering a culture of shared
  responsibility, communication, and automation throughout the entire
  application lifecycle.

- `CasC and IasC`: (Configuration as Code and Infrastructure as Code) these
  methodologies describe the configuration of a resource, tool, service, system,
  or infrastructure in a code format, allowing it to be stored, versioned, and
  processed similarly to application code.

- `Deterministic`: Predictable results overtime, reduce dependencies that one
  can't control, achieve repeatability via version control and cold start up.

- `Cold start`: This occurs when a new instance (e.g, server, container, or
  function) is initialized from scratch, incurring full initialization overhead
  and resulting in higher latency, but tests repeatability and portability.

- `Warm start`: Reusing an already initialized and cached instance, which allows
  for significantly faster response times because code, dependencies, and
  connections are already loaded, but is easier to make bad assumptions, like
  building on an unregistered change. 

- `Anti-branching` Continuous Integration was invented as an antidote to the
  complexities caused by branching, because the main objective of a branch is to
  hide details and isolate a change from others changes, so I prefer a strategy
  of a single `Trunk/Master branch` and make small changes and continuously
  evaluate them,

- `Evolutionary Database Design` based on this article
  [evoDB](https://martinfowler.com/articles/evodb.html), this methodology allows
  a database design to evolve, and being versioned as an application develops
  important capabilities for agile methodologies as DevOps and CasC philosophy.

- `Developing Environments`: These ones include necessary developer tools, like
  automated tests, compilers, detailed logging, etc.

- `Acceptance Environments` Production can fit in this category, which we just
  include the necessary tools to run the application, or another tools like a
  unique server docker setup to build executables, versus, multi-server
  Kubernetes setup to deploy the already builded executables.

## folder-file-naming conventions

- `.env` and `.env.example`: These are the main files of our app, they are the
  same, the only difference, is that `.env` is the one we load the variables,
  but it's not included in the repository, because it has sensitive data like
  users and passwords, and `.env.example` is included in the repository to keep
  track of the changes, so can be recreated easily.

- `install.sh`: The idea is that our setup can be installed as any other popular 
  application, as WhatsApp, Wordpress or Jenkins, and if our system can be
  installed with just one command, this prove that our system is portable,
  replicable because we have all the changes included in the repository.
    - `Why an offline install` Using an offline setup to set up an app which
      will live on the internet, might sound without sense.

- `docker-compose-***.yml` It has the docker infrastructure and services
  configurations, in my case I have 3 file.
    - `docker-compose.yml`: Our main configuration, where I include the other
      docker compose files, so I can have them by separated, but share common
      configurations as the network config or shared volumes.
    - `docker-compose-devops.yml`: Here is the necessary services for the
      automaton pipelines, which include Jenkins, Gitea, Nexus, etc.
    - `docker-compose-app.yml`: Here is just the necessary configuration, to run
      our app, e.g., reverse-proxy, database, backend, and Frontend.

- `***.dockerfile`: It has the necessary dependencies and configuration to
  build and run a service, e.g.:
    - `front.dockerfile`: Here I use the image `node:***-alpine***` which has
      the operative system and tooling to build the app, in this case, alpine
      and node, and in a second stage I have the image `nginx:***-alpine***`
      which declares the necessary to run the app, in this case an alpine and
      Nginx.
    - `jenkins-with-docker.dockerfile`: Here is the same idea, but here I build
      and configure the necessary, to start a Jenkins with access docker.socket
      of the docker host.

- `***.entrypoint.sh`: In the case that the service have a complex initial start
  up, so the service has a desire state, here I declare how to archive it, also
  important to notice this is executed by the container, so we have a stable
  state. e.g.
    - `gitea-entrypoint.sh`: As I wanted the service to have a determinate user
      and password, and determinate repositories ready to be cloned, using a
      determinate ssh configuration, it's a complex setup, so all this is done
      in this file.

- `app/***/source`: The source code application on developing, is saved in these
  folders, they are ignored in the repository (.gitignore), because each one has
  its own repository, so we can distinguish which layer needs to be deployed or
  rollbacked.
    - `app/db/source`: It's the source code of the database, in this case, it's
      being used a [Martin Fowler](https://martinfowler.com/articles/evodb.html).
    - `app/back/source`: It's the source code for the backend, in this case, an
      Restful JSON API using Spring framework.
    - `app/front/source`: It's the source code of the frontend, in this case an 
      Angular app.

- `setup/***`: The services configuration and data are saved in these folders,
  as a CasC philosophy is being followed, this requires of several files, each
  one defining a specific part, as are the `.dockerfile` and `entrypoint` files
  e.g..
    - `jenkins/casc/`: Jenkins has it's own CasC plugin, so the required files
      are saved here.
    - `jenkins/vol-jenkins_home/`: I prefer the `bind mounts`, at least for
      creating the setup, it makes easier some tasks, but I think there would
      not be a problem to pass them to named volumes.

- `workspace/`: This could have called pipelines as well, because I save the
  necessary files to create the pipelines, and to be easy to develop them, these
  executables can be executed at host level or container level, of course, in
  the pipelines they will be run in a container to have better control over the
  state, for example.
    - `workspace/Backend-Deploy` Here are the scripts to download, build and
      deploy the necessary, it might be easier to create them using the Jenkins
      UI, but as we are following a `CasC` methodology, making them like that
      there could be unregistered changes that affect the portability.

- `***/README.md`: There are markdown files over here and there, which act like
  comments in a code, they are part of the documentation of the project, which
  explain some folder function or propose.

### Folder Structure and responsibilities

I already explained the folder patterns and most important files, here I add
a capture of all the project files

```yml
.
├── app
│   ├── back
│   │   ├── source
│   │   ├── test_reports
│   │   ├── back.dockerfile
│   │   ├── back_utils.dockerfile
│   │   ├── back_utils.entrypoint.sh
│   │   ├── mvn-settings.xml
│   │   ├── README.md
│   │   └── t51back.tar.xz
│   ├── db
│   │   ├── source
│   │   ├── db_utils.dockerfile
│   │   ├── db_utils.entrypoint.sh
│   │   └── schema_installation.log
│   ├── front
│   │   ├── source
│   │   ├── Dockerfile-nginx.config
│   │   └── front.dockerfile
│   ├── docker-compose-app.yml
│   └── README.md
├── dep_data
│   ├── docker_installer
│   │   ├── containerd.io_2.2.4-1~ubuntu.24.04~noble_amd64.deb
│   │   ├── docker-buildx-plugin_0.34.1-1~ubuntu.24.04~noble_amd64.deb
│   │   ├── docker-ce_29.5.3-1~ubuntu.24.04~noble_amd64.deb
│   │   ├── docker-ce-cli_29.5.3-1~ubuntu.24.04~noble_amd64.deb
│   │   └── docker-compose-plugin_5.1.4-1~ubuntu.24.04~noble_amd64.deb
│   ├── 0dep_data.md
│   ├── DB_IMAGE.tar
│   ├── DB_MIG_IMAGE.tar
│   ├── dep_data.tar.gzaa
│   ├── dep_data.tar.gzab
│   ├── IMAGE_ACME_COMPANION.tar
│   ├── IMAGE_CURL.tar
│   ├── IMAGE_GITEA.tar
│   ├── IMAGE_HTTPD.tar
│   ├── IMAGE_JAVA.tar
│   ├── IMAGE_JENKINS.tar
│   ├── IMAGE_MVN.tar
│   ├── IMAGE_NEXUS.tar
│   ├── IMAGE_NGINX.tar
│   ├── IMAGE_NODE.tar
│   ├── IMAGE_REGISTRY.tar
│   ├── IMAGE_REVERSE_PROXY.tar
│   ├── IMAGE_T51DB_UTILS.tar
│   ├── IMAGE_T51JENKINS.tar
│   └── pre_initialized_nexus_mvn_npm.tar.xz
├── docs
│   ├── img
│   │   ├── capture-1-gitea.png
│   │   ├── capture-2-jenkins.png
│   │   ├── capture-3-nexus.png
│   │   ├── capture-4-registry.png
│   │   ├── capture-5-postgres.png
│   │   ├── capture-6-backend-app-swagger.png
│   │   └── capture-7-angular-app.png
│   ├── test
│   │   ├── temporal.md
│   │   └── test.sh
│   ├── chat-gpt.md
│   ├── github-flow.drawio
│   ├── github-flow.png
│   ├── howTo1_InstallProjectOnARemoteHost.md
│   ├── howTo2_setupADeveloperMachine.md
│   ├── howTo3_DeployOrRollback.md
│   ├── howTo4_UnderstandTheWholeProject.md
│   ├── howTo5_DevelopDatabase.md
│   ├── howTo6_DevelopBackend.md
│   ├── howTo7_DevelopFrontend.md
│   ├── howTo8_DevelopDevOps.md
│   ├── howTo9_haveMultipleEnvironments.md
│   ├── HowToWriteAcceptanceTestings.md
│   ├── MANIFEST.md
│   ├── pipelines-workflow.drawio
│   ├── pipelines-workflow.png
│   ├── reverse-proxy-conf.backup.drawio
│   ├── reverse-proxy-conf.png
│   ├── setup-connections.drawio
│   ├── setup-connections.png
│   ├── TODO.md
│   ├── uninstall.md
│   ├── useful-commands.md
│   └── what-I-learned.md
├── setup
│   ├── gitea
│   │   ├── initial_repos
│   │   ├── vol-config-dir
│   │   ├── vol-data
│   │   └── gitea-entrypoint.sh
│   ├── jenkins
│   │   ├── casc
│   │   ├── jenkins-entrypoint.sh
│   │   └── jenkins-with-docker.dockerfile
│   ├── nexus
│   │   ├── vol-data
│   │   ├── vol-data.BACKUP
│   │   ├── mvn-settings-template.xml
│   │   ├── nexus-entrypoint.sh
│   │   └── nexus-pre-initialized.tar.xz
│   ├── registry
│   │   ├── vol-data
│   │   └── config-registry-ui.yml
│   ├── reverse-proxy
│   │   ├── certs
│   │   ├── conf.d
│   │   └── html
│   ├── secrets
│   │   ├── README_secrets.md
│   │   ├── registry.password
│   │   ├── ssh_key.priv
│   │   └── ssh_key.pub
│   ├── shared
│   │   ├── known_hosts
│   │   └── ssh_config
│   ├── docker-compose-devops.yml
│   └── install_functions.sh
├── workspace
│   ├── 0_scripts
│   │   ├── build_image.sh
│   │   ├── check_necessary_variables.sh
│   │   ├── check_start.sh
│   │   ├── deploy.sh
│   │   ├── download_back_repo.sh
│   │   ├── download_db_mig_repo.sh
│   │   ├── download_devops_repo.sh
│   │   ├── download_front_repo.sh
│   │   ├── get_commit_message.sh
│   │   ├── get_environment.sh
│   │   ├── get_repo_dir.sh
│   │   ├── get_tag_name.sh
│   │   └── temp_env_file_functions.sh
│   ├── 0_static
│   │   ├── badge_failing.svg
│   │   └── badge_success.svg
│   ├── Backend-Deploy-v1
│   │   ├── 1
│   │   ├── 2
│   │   ├── 3
│   │   ├── 4
│   │   ├── 5
│   │   ├── 1bd-download.sh
│   │   ├── 2bd-build-image.sh
│   │   └── 3bd-deploy.sh
│   ├── Backend-Deploy-v1@tmp
│   ├── Backend-Rollback
│   │   ├── 1
│   │   ├── 2
│   │   ├── 3
│   │   ├── 1br-download.md
│   │   ├── 2br-backup-and-delete-last-commit.sh
│   │   ├── 3br-download-again.md
│   │   ├── 4br-build-image.md
│   │   └── 5br-deploy.md
│   ├── Backend-Rollback@tmp
│   ├── Backend-Tests
│   │   ├── 1
│   │   ├── 40
│   │   ├── 1bd-download.md
│   │   ├── 2bt-run-unitary-tests.sh
│   │   └── README.md
│   ├── Backend-Tests@tmp
│   ├── Database-Backup
│   │   ├── 1-backup.sh
│   │   ├── backup_2_2026-07-01_17-50-01.sql
│   │   └── backup_3_2026-07-01_17-51-55.sql
│   ├── Database-Backup@tmp
│   ├── Database-Deploy-v1
│   │   ├── 11
│   │   ├── 2
│   │   ├── 3
│   │   ├── 4
│   │   ├── 5
│   │   ├── 6
│   │   ├── 7
│   │   ├── 1md-download-devops-repo.sh
│   │   ├── 2md-build-image.sh
│   │   └── 3md-migrate.sh
│   ├── Database-Deploy-v1@tmp
│   ├── Database-Restore
│   │   └── 1-restore.sh
│   ├── Database-Rollback-v1
│   │   ├── 1
│   │   ├── 2
│   │   ├── 3
│   │   ├── 4
│   │   ├── 4dr-delete-last-commit.sh
│   │   └── README.md
│   ├── Database-Rollback-v1@tmp
│   ├── Docker-Commands
│   │   ├── 1
│   │   ├── 2
│   │   ├── 3
│   │   ├── 4
│   │   ├── 1dc-download.sh
│   │   └── 2dc-commands.sh
│   ├── Docker-Commands@tmp
│   ├── Frontend-Deploy-v1
│   │   ├── 1
│   │   ├── 2
│   │   ├── 3
│   │   ├── 8
│   │   ├── 9
│   │   ├── 1fd-download.sh
│   │   ├── 2fd-build-image.sh
│   │   └── 3fd-deploy.sh
│   ├── Frontend-Deploy-v1@tmp
│   ├── Frontend-Rollback
│   │   ├── 1
│   │   ├── 2
│   │   ├── 3
│   │   └── 2fr-backup-and-delete-last-commit.sh
│   ├── Frontend-Rollback@tmp
│   ├── Image-actions
│   │   ├── 1ra-list-images.sh
│   │   ├── 2ra-delete-dangling-images.sh
│   │   └── 2ra-delete-selected-images.sh
│   ├── Registry-actions
│   │   ├── 1ra-list-images.sh
│   │   └── 1ra-tag-and-upload.sh
│   ├── Registry-actions@tmp
│   ├── temporal
│   └── README_devops.md
├── z_artt51
│   └── docker-compose.yml
├── docker-compose.yml
├── install.sh
├── README.backup.md
└── README.md
```

