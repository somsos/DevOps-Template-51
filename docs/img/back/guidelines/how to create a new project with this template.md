# How to create a new project with this template

## How to use this spring, multi-module, hexagonal project template

The intention of this file is to explain how to use the file *hexagonal_project.zip*
to create a new project

To know about the general features and decisions of the project check
*01_documentation/guidelines/general-descriptions.md*

### Steps

1, Download and decompress the file *hexagonal_project.zip* in an working directory

1, If is not required the features of product, delete:
----module product
----packages
------package adapter.product
------dependencies in adapter->pom.xml
------package test.adapter.product
------fix compilation error in adapter.common.authConfig.AuthConfig (they must be
--------only because IProductConstants is missing)
------In AdapterApplication remove the lines to scan in module and adapter.product

1, change the groupID in (use a IDE with automatic refactor renaming) search for
the last groupId and remplace for the new one, using the IDE multi file searcher,
and ensure that the change is in.

--common->packages
--common->pom.xml
--test.common

--user->packages
--user->pom.xml
--test.user

--adapter->packages
--adapter->pom.xml
--test.adapter

2, inside each submodule run the below command in the below order
--2,2, Order: common, user, adapter
--2,1, Command: mvn dependency:resolve clean install
--Note: it should run the tests and it should pass all of them.

3, Open the project with the IDE and instantiate an postgres, in the file
*01_documentation/user-guides/requirements.md* explain how. (docker container)

4, To get familiarized with the code and architecture read the documentation,
below is explained how to use it.

____

<!--

########################################################################
########################################################################
########################################################################

-->

____

<!--

########################################################################
########################################################################
########################################################################

-->

## How to use the documentation

To know a general description of the project please see *01_documentation/guidelines/general-descriptions.md*

To know about how to run and/or use the application, see *01_documentation/user-guides*.

To understand how the application works so you can make some modifications, see *01_documentation/guidelines*.

____

## Quick Note

In AuthConfig separate the conf by domain, so when the product folder is deleted,
don't be dificult or sensible to delete the product auth config.

