# Offline install

- [Offline install](#offline-install)
  - [Database pipelines](#database-pipelines)
    - [Deploy Database](#deploy-database)
    - [Rollback Database](#rollback-database)
  - [Backend pipelines](#backend-pipelines)
    - [Deploy Backend](#deploy-backend)
    - [Rollback Backend](#rollback-backend)
  - [Frontend pipelines](#frontend-pipelines)
    - [Deploy Frontend](#deploy-frontend)
    - [Rollback Frontend](#rollback-frontend)


## Database pipelines

### Deploy Database

In this case I have a change already prepared.

```sh
DEV_P_ROOT=/home/mario/mine/p/example1-test
MY_USER=myTestUser
MY_PASS=myTestUser1p
MY_DOMAIN=example1-test.com


cd $DEV_P_ROOT/app/db/source
psql postgresql://$MY_USER:$MY_PASS@$MY_DOMAIN:5001/${MY_USER}1db -c "\dt"
# EXPECTED OUTPUT (NOTICE THAT THERE IS NO TABLE CALLED "bad_design")
#                  List of tables
#  Schema |         Name          | Type  | Owner
# --------+-----------------------+-------+-------
#  public | databasechangelog     | table | myUser
#  public | databasechangeloglock | table | myUser
#  public | product_images        | table | myUser
#  public | products              | table | myUser
#  public | roles                 | table | myUser
#  public | users                 | table | myUser
#  public | users_picture         | table | myUser
#  public | users_roles           | table | myUser

test -f ./docs/03-testTable.changelog.xml && echo "OK" || echo "ERROR, file not found look for the alternative file."
mv ./docs/03-testTable.changelog.xml  ./changelogs

git add . && git status | grep renamed
# expected output
#	renamed:    docs/03-testTable.changelog.xml -> changelogs/03-testTable.changelog.xml

git commit -m "The first database change." && git log --oneline

# Get ready to notice the pipeline being triggered by the git push
firefox -new-tab "http://gitea.$MY_DOMAIN/$MY_USER/t51mig-db"
firefox -new-tab "http://jenkins.$MY_DOMAIN/job/Database-Deploy-v1"

git push origin main
#   Click on "Yes, proceed!" in the triggered pipeline.

psql postgresql://$MY_USER:$MY_PASS@$MY_DOMAIN:5001/${MY_USER}1db -c "\dt" | grep bad_design
# EXPECTED OUTPUT
# public | bad_design            | table | myUser
```

### Rollback Database

The rollback in database is a little more complex than back or front
applications, because we need to run a sql script to get back to the original
schema state without affected the data.

1. Go to ` firefox -new-tab "http://jenkins.$MY_DOMAIN/job/Database-Rollback-v1"  `
2. Push on "Build Now"
3. If we run `psql postgresql://$MY_USER:${MY_PASS}@$MY_DOMAIN:5001/${MY_USER}1db -c "\dt"`
   we should not be able to see the table bad_design
4. If we go to `firefox -new-tab http://gitea.$MY_DOMAIN/$MY_USER/t51mig-db` we should see
   as the last commit the message `Initial commit`.



<!--

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% divider

-->

----

<!--

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% divider

-->


## Backend pipelines

### Deploy Backend

We add a change in our frontend project

```shell
cd $DEV_P_ROOT/app/back/source

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
firefox -new-tab http://gitea.$MY_DOMAIN/$MY_USER/t51back
firefox -new-tab http://jenkins.$MY_DOMAIN/job/Backend-Deploy-v1/
git push origin main

# The deploy Jenkins pipeline should have been triggered and the change deployed.

curl http://api.$MY_DOMAIN/test | json_pp
# EXPECTED OUTPUT
# {
#    "message" : "One is the number of this change"
# }

#Check that the test are running in
firefox -new-tab http://jenkins.$MY_DOMAIN/job/Backend-Tests

# if the tests were successful, we can see the green badge in Gitea
firefox -new-tab http://gitea.$MY_DOMAIN/$MY_USER/t51back
# Option B: We can see it here
curl http://nexus.$MY_DOMAIN/repository/public-files/images/tests-result.svg | grep '>Tests: Passing<'
```

### Rollback Backend

1. Go to `firefox -new-tab http://gitea.$MY_DOMAIN/$MY_USER/t51back` and notice what is the last commit

2. Go to `firefox -new-tab http://jenkins.$MY_DOMAIN/job/Backend-Rollback/`

3. Click on "Build Now"

4. At the end of the pipeline execution we should see the last message that was before

```shell
curl http://api.$MY_DOMAIN/test | json_pp
# EXPECTED OUTPUT
# {
#    "message" : "33-3 Some random change 3-33"
# }
```

5. Return to Gitea and the last commit should have been deleted, keeping a
   commit with a message of `Initial commit`.





<!--

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% divider

-->

----

<!--

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% divider

-->




## Frontend pipelines

### Deploy Frontend

We add a change in our frontend project

```shell
cd $DEV_P_ROOT/app/front/source

cat > ./src/app/main/internals/view/pages/home/home.page.html <<EOF
<div>
  <ul>
    <li>This is the change 1</li>
  </ul>
</div>
EOF

git status | grep modified && git add . && git commit -m "My change number 1" && git log --oneline
>        modified:   src/app/main/internals/view/pages/home/home.page.html


# Notice the last look before the change  
firefox -new-tab http://$MY_DOMAIN

# Notice the last commit message: 
firefox -new-tab http://gitea.$MY_DOMAIN/$MY_USER/t51front

# Get ready to see how the pipeline is triggered
firefox -new-tab http://jenkins.$MY_DOMAIN/job/Frontend-Deploy-v1/
git push origin main

#   The deploy Jenkins pipeline should have been triggered and the change deployed.

#   Notice deployed change
firefox -new-tab http://$MY_DOMAIN/
```

### Rollback Frontend

1. Notice the last commit message
```sh
firefox -new-tab http://gitea.$MY_DOMAIN/$MY_USER/t51front
```

2. Notice the last look before the rollback
```sh
firefox -new-tab http://$MY_DOMAIN
```

1. Go to the pipeline and click on "Build Now" to start the rollback

```sh
firefox -new-tab http://jenkins.$MY_DOMAIN/job/Frontend-Rollback/
```

1. Notice how the the last commit message changed to the one was before

```sh
firefox -new-tab http://gitea.$MY_DOMAIN/$MY_USER/t51front
```

1. Notice that the look changed to the one was before on
```sh
firefox -new-tab http://$MY_DOMAIN
```sh




