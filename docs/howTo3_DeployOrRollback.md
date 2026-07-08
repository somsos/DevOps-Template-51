# Offline install

- [Offline install](#offline-install)
  - [Database pipelines](#database-pipelines)
    - [Deploy Database](#deploy-database)
    - [Rollback Database](#rollback-database)
  - [Backend pipelines](#backend-pipelines)
    - [Deploy Backend](#deploy-backend)
    - [Rollback Backed](#rollback-backed)
  - [Frontend pipelines](#frontend-pipelines)
    - [Deploy Frontend](#deploy-frontend)
    - [Rollback Frontend](#rollback-frontend)
  - [Useful Commands](#useful-commands)
    - [After restart servers](#after-restart-servers)


## Database pipelines

### Deploy Database

In this case I have a change already prepared.

```sh
cd /home/mario/mine/yopi1/app/db/source

psql postgresql://yopi1:yopi123p@yopi-test.com:5001/yopi1db -c "\dt"
# EXPECTED OUTPUT (NOTICE THAT THERE IS NO TABLE CALLED "bad_design")
#                  List of tables
#  Schema |         Name          | Type  | Owner
# --------+-----------------------+-------+-------
#  public | databasechangelog     | table | yopi1
#  public | databasechangeloglock | table | yopi1
#  public | product_images        | table | yopi1
#  public | products              | table | yopi1
#  public | roles                 | table | yopi1
#  public | users                 | table | yopi1
#  public | users_picture         | table | yopi1
#  public | users_roles           | table | yopi1

mv ./docs/03-testTable.changelog.xml  ./changelogs

git add . && git status | grep renamed
# expected output
#	renamed:    docs/03-testTable.changelog.xml -> changelogs/03-testTable.changelog.xml

git commit -m "The first database change." && git log --oneline

# Get ready to notice the pipeline being triggered by the git push
#   http://gitea.yopi-test.com/yopi1/t51mig-db
#   http://jenkins.yopi-test.com/job/Database-Deploy-v1
git push origin main
#   Click on "Yes, proceed!" in the triggered pipeline.

psql postgresql://yopi1:yopi123p@yopi-test.com:5001/yopi1db -c "\dt" | grep bad_design
# EXPECTED OUTPUT
# public | bad_design            | table | yopi1
```

### Rollback Database

The rollback in database is a little more complex than back or front
applications, because we need to run a sql script to get back to the original
schema state without affected the data.

1. Go to `http://jenkins.yopi-test.com/job/Database-Rollback-v1/`
2. Push on "Build Now"
3. If we run `psql postgresql://yopi1:yopi123p@yopi-test.com:5001/yopi1db -c "\dt"`
   we should not be able to see the table bad_design
4. If we go to `http://gitea.yopi-test.com/yopi1/t51mig-db` we should see
   as the last commit the message `Initial commit`.





## Backend pipelines

### Deploy Backend

We add a change in our frontend project

```shell
cd /home/mario/mine/yopi1/app/back/source

nano ./adapter/src/main/java/daj/adapter/AdapterApplication.java 
# Edit this Line:
# return Map.of("message", "One is the number of this change.");

git status | grep modified
#>        modified:   ./adapter/src/main/java/daj/adapter/AdapterApplication.java

git add . && git commit -m "Change One" && git log --oneline
# EXPECTED OUTPUT
# [main 103cdc3] Change One
#  1 file changed, 1 insertion(+), 1 deletion(-)
# 103cdc3 (HEAD -> main) Change One
# 0d88925 (origin/main, origin/HEAD) Initial commit

# Get ready to notice the pipeline being triggered by the git push
#   http://gitea.yopi-test.com/yopi1/t51back
#   http://jenkins.yopi-test.com/job/Backend-Deploy-v1/
git push origin main

# The deploy Jenkins pipeline should have been triggered and the change deployed.

curl http://api.yopi-test.com/test | json_pp
# EXPECTED OUTPUT
# {
#    "message" : "One is the number of this change"
# }
```

### Rollback Backed

1. Go to http://gitea.yopi-test.com/yopi1/t51back and notice what is the last commit

2. Go to http://jenkins.yopi-test.com/job/Backend-Rollback/

3. Click on "Build Now"

4. At the end of the pipeline execution we should see the last message that was before

```shell
# 
curl http://api.yopi-test.com/test | json_pp
# EXPECTED OUTPUT
# {
#    "message" : "33-3 Some random change 3-33"
# }
```

5. Return to http://gitea.yopi-test.com/yopi1/t51back and the last commit
   should have been deleted, keeping a commit with a message of `Initial commit`.










## Frontend pipelines

### Deploy Frontend

We add a change in our frontend project

```shell
cd /home/mario/mine/yopi1/app/front/source

cat > ./src/app/main/internals/view/pages/home/home.page.html <<EOF
<div>
  <ul>
    <li>This is the change 1</li>
  </ul>
</div>
EOF

git status | grep modified && git add . && git commit -m "My change number 1" && git log --oneline
>        modified:   src/app/main/internals/view/pages/home/home.page.html



# Open Gitea and Jenkins in the browser, and prepare to notice the pipeline 
# to be triggered on push
#   Notice the last look before the change  http://yopi-test.com/
#   Notice the last commit message:         http://gitea.yopi-test.com/yopi1/t51front
#   http://jenkins.yopi-test.com/job/Frontend-Deploy-v1/
git push origin main
#   The deploy Jenkins pipeline should have been triggered and the change deployed.
#   Notice deployed change                  http://yopi-test.com/
```

### Rollback Frontend

1. Notice the last commit message http://gitea.yopi-test.com/yopi1/t51front

2. Notice the last look before the rollback  http://yopi-test.com/

3. Go to http://jenkins.yopi-test.com/job/Frontend-Rollback/

4. Click on "Build Now"

5. Notice how the the last commit message changed to the one was before http://gitea.yopi-test.com/yopi1/t51front

6. Notice that the look changed to the one was before on http://yopi-test.com/




<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->


## Useful Commands

### After restart servers

In my case I like to have docker disabled on the start, so I need to start the
docker services and app services manually, in case I restart the server.


```shell
sudo systemctl start containerd.service docker.socket docker.service docker

cd /p1
docker compose --profile all up -d
```

