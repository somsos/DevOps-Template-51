# ToDo

## Doing (The upper top is the current task)

- delete NEXUS_URL variable calls
- delete NEXUS_GW variable calls

- [ ] Check if I really need buildx, because I'm already not using vol-type-cache.

- [ ] Create a package to publish to the public.
  - [ ] Documentation
    - [X] Look for examples
    - [X] Explain by components
    - [ ] Create an external user perspective
    
    - [ ] Finish documents
      - [X] howTo1_InstallProjectOnARemoteHost.md
        - [X] Mention to approve manually the jenkins pipelines on the first run.
        - [X] Upload compressed file to github divided in two.
      - [X] howTo2_setupADeveloperMachine.md
        - [X] Tell about and why download the .env file
      - [X] howTo3_DeployOrRollback.md
        - [ ] 2 types of rollbacks
      - [ ] howTo4_UndestandTheWholeProject.md
        - [X] DevOps general idea (CasC, cold-vs-warm-start, )
        - [X] Folder-file-naming conventions
        - [X] It's a building docker images setup. It's planned a second part to
          create a Kubernetes setup, like a API json backend and a SPA frontend
          idea, this setup is like the API and kubernetes like the SPA.
        - [X] The repositories are the central state
        - [X]Each layer can work independently between them or the developers
          have the tools to download/create/run their own dependencies, the
          devops projects inter-connect all together.
        - [X] Execution orders (these happen in containers with versioned CasC
          to ensure determinism)
        - [X] compose->dockerfile->entrypoint->scripts-in-volumes.
        - [X] User->Jenkins->Pipeline in yml->scripts-in-volumes.
        - [ ] Architecture based by components and Hexagonal Architecture
      - [ ] howTo5_DevelopDatabase.md
        - [ ] What is LiquiBase
        - [ ] Localhost workflow
        - [ ] Local-containers workflow
        - [ ] Stage workflow
        - [ ] PRODUCTION workflow
      - [ ] howTo6_DevelopBackend.md
      - [ ] howTo7_DevelopFrontend.md
      - [ ] howTo8_DevelopDevOps.md
        - [ ] How to add/update a new pipeline
      - [ ] howTo9_haveMultipleEnvironments.md
      - [ ] MANIFEST.md
    - %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    - [ ] Add to doc my last try to create the install.sh
      - [ ] Create/Prepare to create install script and manual.
      - [ ] Install script
        - [X] Add host public key to gitea so the docker host can clone.
        - [X] Ask for user/pass, domain, email, env-type(local, stage, prod), 
        - [X] Pull images and set them for offline use.
        - [X] Start/build gitea
          - [X] Check initial repositories.
        - [X] Start/build Jenkins
          - [X] add `docker compose build --build-arg DOCKER_GID=$(getent group docker | cut -d: -f3) jenkins`
        - [X] Start reverse proxy
      - [ ] MANUAL (using just Jenkins)
        - [ ] Mention to 
          - [ ] Run Gitea first then Jenkins
          - [ ] Download the source code in the source directories
          - [ ] create the .env file using as template the .env.example file because for security is ignored in git
          - [ ] Add local domains to etc/hosts
          - [ ] Create secrets reading `setup/secrets/README_secrets.md`
          - [ ] Pre approve pipelines, so the first time the user execute a pipeline, it doesn't give an error ofr this
          - [ ] Add in `/etc/docker/daemon.json` the content `{ "insecure-registries": ["registry.$MY_DOMAIN:5000"] }` for docker login
        - [X] X. Database.
          - [X] X. Start service
          - [X] X. Build the db_utils container
          - [X] X. Install schema.
        - [X] X. Build/Start the backend container
        - [X] X. Build/Start the frontend container


- [ ] Change Nginx to Caddy with "static" config
  - NOTE: start asking claude replacing my message "And to create an SSH tunnel for Gitea->port 22"
  - [ ] Map nexus->5000 to register.example.com
  - [ ] Create a ssh tunneling for Gitea->222
  - [ ] Change postgres to just expose it internally

- [ ] nexus consumes a lot of RAM (2.2Gb), Check replace it with
  [harbor](https://github.com/goharbor/harbor) and similar services.

- [ ] Backend-Rollback When I make a push because I delete the last commit in a
  rollback, the deploy pipeline is triggered, check the way to avoid this,
  nothing happens in the deploy bad triggered because I ask for confirmation.

- [ ] Test in redlap

- [ ] Test in bluelap

- [ ] Upload to a productive server
  - [ ] Test the SSL pipeline or command.

- [ ] Check how to avoid exposing secrets for example
  - [ ] Some logs in jenkins pipelines.
  - `docker exec jenkins printenv | grep PASS`
  - `docker exec gitea printenv | grep PASS`
  - secrets that still can see them using `docker exec jenkins cat /run/secrets/my_secret` 
  but is not available for all proccesses
    - What happens if in my entrypoint I do this `export MY_PASS="$(cat /run/secrets/my_pass_secret)"` and then UNSET or override
    - What happends if i edit `jenkins.sh` the official file to start jenkins

- [ ] Decide how to test the UI code (Jest, Cypress, etc)
  - [ ] Run them on Jenkins

- [ ] Automate Monitoring and Reporting
  - [ ] Study best approaches for this

## Resume

### My Git flow

I just finished the deploy and rollback on database, I will try the rollback
on backend and frontend by using `git revert`, something like make up an
scenery which I need to rollback the three layers (front, back and db).

**The problem that I have now** is that when i'm developing I do many commit, and
many of them are irrelevant on a production level, so...

I'm thinking on create a feature branch and then merge it to the environment I what
to deploy, using `--no-commit` y `--no-ff` to reduce the commits

```shell
git checkout back_PRODUCTION
git checkout -b new_feature_1

# make changes
git checkout back_develop
# I merge the changes and keep the noise out
git merge --no-commit --no-ff new_feature_1
git add . && git commit -m "implement of new_feature_1"

# if everything goes well I do the same in test
git checkout back_test
git merge --no-commit --no-ff new_feature_1
git add . && git commit -m "implement of new_feature_1"

# If everything goes well I do the same in PRODUCTION
git checkout back_PRODUCTION
git merge --no-commit --no-ff new_feature_1
git add . && git commit -m "implement of new_feature_1"
```

So in theory this way there is no much details hidden, because
the environment branches are just to deploy in previous environments
without modify the PRODUCTION branch.
and the feature branches should be merged/committed the most often
posible.

## List

- [ ] Make a drawing of how would work the git strategy and their commits.
- [ ] Create a happy-path scenery to deploy in all layers.
- [ ] Create an all-bad scenery to rollback in all layers.
- [ ] Include it in your the blog.

<!--
          .
          .
          .
-->

## Finished (Last one is more recently finished)

- [X] (DISCARDED IDEA) use conf.json in docker.
- [X] Implement JCasC `https://plugins.jenkins.io/configuration-as-code/`
- [X] Gitea admin user creation
- [X] Gitea back repository
- [X] Jenkins admin user creation
- [X] Create Gitea front repository
- [X] Create Gitea DbMig repository
- [X] Create Gitea DevOps repository
- [X] I changed the commands runner using JCasC "jenkins.yml -> unclassified:->shell:->shell: "/bin/bash""
- [X] Back Pipeline to build and deploy
  - [X] Using the jenkins terminal for unitary tests create
    - [X] script for download
    - [X] script for build
    - [X] script for deploy
  - [X] Create pipeline and using source command call the scripts
    - [X] Using $JOB_NAME get sure the scripts will run in shell and pipeline
- [X] Front Pipeline to build and deploy
  - [X] I did it like the backend pipeline
- [X] Jenkins pipeline for Docker control.
- [X] DbMig Deploy Pipeline
  - [X] Use a file to manage the version
- [X] DbMig Rollback Pipeline
- [X] Avoid using Docker in Docker for database migrations, because at the moment
    of mounting a volume the files were not accesible
- [X] DbMig Backup
- [X] DbMig Restore Backup
- [X] Return the docker compose command for database migrate deploy and rollback.
  - [X] One Layer to download
  - [X] Other layer to migrate/rollback
- [X] Return the docker compose command for database backup and restore.
- [X] Design idea of incremental versioning using files, e.g.,  back/VERSION
- [X] CasC in Gitea to create webhook to trigger Jenkins pipelines
  - [X] Deploy
    - [X] Back D
    - [X] Front D
    - [X] Database D
- [X] Create scripts/commands/pipeline for Frontend Database
- [X] Create scripts/commands/pipeline for Backend Rollback
- [ ] Create pipeline/button for Backend Rollback (I already have the bash scripts)
- [X] Create scripts/commands/pipeline for Frontend Rollback
- [X] Add notes why I'm not using webhook for rollback and the alternative of using `revert`.
- [X] Deploy and Rollback by layer
  - [X] Back
  - [X] Front
  - [X] Database
- [X] Create scenarios where I need to use Deploy and Rollback back and front
- [X] Create scenarios where I need to use Deploy and Rollback back and database
- [X] Fix Avoid the creation of extra/multiple back webhooks in gitea entrypoint.
- [X] Create scenarios where I need to use Deploy and Rollback the 3 layers
- [X] Add in Docker-Control pipeline command to see the containers status
- [X] Research how to use docker image registry for containers app backup
  - `docker compose build --tag back:${BUILD_NUMBER} back`
  - `git log -1 --pretty=format:%h`
  - An image can be tagged several times, so we can refer to the same image with different tags, for example, Note, the first tag is the original/official name, and the second one is the alias.
    - docker tag back:${BUILD_NUMBER}-${COMMIT_ID} back:1.2.3
    - docker tag back:${BUILD_NUMBER}-${COMMIT_ID} back:${COMMIT_ID}
- [X] Create image tagging strategy for backend
  - [X] Backup Backend (with tagging strategy I also create backups )
- [X] Create image tagging strategy for frontend
  - [X] Backup Frontend (with tagging strategy I also create backups )
- [X] Update all the initial_repos, do not forget to keep the same name and remove the .git folder
- [X] Create a initial setup script 
  - [X] X. Build Jenkins passing the docker group id to the build commnad
      - `docker compose build --build-arg DOCKER_GID=$(getent group docker | cut -d: -f3) jenkins`
  - [X] X. Add to jenkins the "ssh-keyscan -p 222 gitea.${MY_DOMAIN} > ./shared/known_hosts"
- [X] Put together the used docker images
- [X] Security Hide .env passwords
- [X] CHeck the use of .env in pipelines because I deleted it from the repo.
- [X] Add tag to images to mark production candidates.
  - [X] Add credentials for docker login in Registry-actions pipeline
  - [X] List Images
  - [X] Use just Jenkins to tag and list de available images, because an UI requieres wierd secret conf.
- [X] Purge Images, get rid of images that are not candidates to production.
  - [X] Delete Dangling images
  - [X] Delete images selected by the user
- [X] Add healthcheck to gitea, jenkins, reverse-proxy, registry
- [X] Check why in redlap the backend URL is wrong, it does not have the "api" subdomain part
- [X] Avoid in install command edit the .env.example, because it might be added an undesired change to the repo.
- [X] Check the timeout in building/deploy backend for slow hosts as redlap
- [X] Check the pipelines on offline mode (without internet)
    - ■■■ BAD IDEA: IT REDUCE THE PORTABILITY AND CREATE WEIRD FILE INTEGRITY ERRORS. ■■■
    - [X] Update Maven dependencies and copy .m2 on build image for building
    - [X] Update Node dependencies and copy node_modules on build image for building
- [X] Create a named volume for m2.
- [■] CANCELED Create a named volume for jenkins, I'm having problems with DinD
  - CANCELED BECAUSE A LOT OF WORK
- [X] Add to copy_env_file an arg to delete the password to the copied filed, if is not required
- [X] Create pipeline to execute tests and publish a status sticker
  - [X] Make the java tests pass
  - [X] make the pipeline can get the positive or negative result
  - [X] Use `badge_XXX.svg` to create the icon to publish
  - [X] Publish an static URL with a changing image
  - [X] Add URL to repository and see that the status match.
- [X] Set up a Sonatype Nexus Repository for maven.
  - [X] Add a compressed file to the repo with a pre-initialized nexus instance.
  - [X] add to Jenkins the public domain of nexus, so no change is required between envs.
    - [X] Check that I can connect from Jenkins to nexus
  - [X] use install.sh to uncompress it in the volume host folder.
  - [X] Use install.sh create an user with the credentials of app user.
  - [X] Add maven config to back.dockerfile
  - [X] Check that still builds in CLI and Jenkins
- [X] Set up a Sonatype Nexus Repository for `npm`.
  - [X] Use install.sh the necesary npm repositories
  - [X] Add npm-nexus config to front.dockerfile
  - [X] Check that still builds in CLI and Jenkins
- [X] offline mode using nexus.
  - [ ] Create a pre-configurated compressed file with 
    - [X] Pre-initialized
    - [X] Default credentials
    - [X] maven dependencies
    - [X] npm dependencies
    - [X] Create .tar file and save it in ./dep_data/`pre_initialized_nexus_mvn_npm.tar.xz`
  - [X] Use install.sh to copy the downloaded dependencies if exists `tar -czf nexus-blobs.tar.gz setup/nexus/vol-data/`
  - [X] Check that it can be created the new user with the full-compressed file
- [X] Add to installer `sudo pacman -S docker-buildx`.
- [X] Re-Check install.sh In my host using uninstall.md
  - [X] Use install.md
  - [X] database
    - [X] deploy
    - [X] rollback
  - [X] Back
    - [X] deploy 
    - [X] rollback
  - [X] Front
    - [X] deploy 
    - [X] rollback
- [X] Check why db_utils is trying to re-build db_utils.dockerfile, and install
  a dependency from internet
  - [X] Check on VR machine again
- [X] Check if I can create the custom-jenkins-image and create a .tar file to
  pull it in offline, because to build this image required of apt update and
  install, and for an offline setup this makes all more complex, but if i can
  have this as a pre-build so internet is nor required anymore.
- [X] Check Database pipelines
  - [X] Deploy (All ok)
  - [X] Fix "Rollback Frontend" (It was a line out of place)
  - [X] Backup
  - [X] Restore
- [X] Fix "Database Rollback" Jenkins pipeline, it does the rollback correctly,
      but forward steps fail, I think is the .env deletion.
- [X] Fix the Frontend-Rollback pipeline, it does not fiend the .sh files,
  it seems I forgot to change the path to reuse the deploy .sh files.
- [X] Check why ./workspace/.env is empty
- [X] Add pre-approve to pipelines in JCasC or to the manual
- [X] Check if adding "user: "${MY_UID}:${DOCKER_GID}" to all services does
      not affect the current, this might avoid permission errors.
- [X] Check documentation of https://help.sonatype.com/en/sonatype-product-overview.html
- [X] In ubuntu virtual machine (Online mode and offline mode)
    - [X] Clone repo
    - [X] Copy dependencies
    - [X] Use install.md
    - [X] Use install.md again, just after finish
    - [X] Link Virtual Machine and host and check services created
    - [X] Check jenkins pipeline for **Database**
      - [X] Clone, change and push
      - [X] check deploy
      - [X] rollback
    - [X] Check jenkins pipeline for **Backed**
      - [X] Clone, change and push
      - [X] deploy
      - [X] rollback
    - [X] Check jenkins pipeline for **Frontend**
      - [X] Clone, change and push
      - [X] deploy
      - [X] rollback
- [X] Combine the download_{back|db|devops|front}_repo.sh in just one function
      - **Omitted** To much abstraction, i prefer repeat a little of code than
        make a complex one.
- [x] Delete docker registry service and use nexus-docker-registry
  - [X] In nexus_configurator.entrypoint.sh
    - [X] Create Docker hosted
    - [X] Create raw static file server and setup anonymous read and auth write
  - [X] Check pipelines
    - [X] Publish test results using nexus-raw-static-server
    - [X] Upload image to nexus-docker-registry
  - [X] In jenkins JCasC in users.yaml move from `allowAnonymousRead: true`
        to `false`, because I'm using nexus as static server, so I do not need
        this and it's a security hole
- [X] Backend-Deploy, add start database service in case it's down
- [X] `workspace/0_scripts/deploy.sh`  see if it's "--force-recreate" 
  flaw the one that makes download the dependencies again.
  **NOTE**: It was a silly mistake, I forget to add the line 
  `COPY --from=dep_downloader /home/user1/.m2/repository  /home/user1/.m2/repository`
  to copy the cached download to the repo
- [X] fix the sync time in jenkins pipelines
  - Note: it's fix though a Java variable `JAVA_OPTS=-Duser.timezone=America/Mexico_City`
- [X] Check if I can delete...
  - [X] setup/nexus/mvn-settings-template.xml
  - [X] setup/registry
  - [X] setup/reverse-proxy/conf.d/localhost_ip.conf
  - [X] setup/reverse-proxy/html/index.html
  - [X] app/back/test_reports
  - [X] app/back/t51back.tar.xz
  - [X] app/db/schema_installation.log
  - [X] docs/test/temporal.md
  - [X] docs/chat-gpt.md
  - [X] setup/jenkins/casc/credentials.yaml
  - [X] registry.password
  - [X] README_devops.md
  - [X] ***_devops.md
