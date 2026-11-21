# General Descriptions

## Characteristics list

This project is have the following strategies, tools and dependencies.

- Web API Restful Json
- Multi Modules-Jars
- Hexagonal architecture (or onion architecture)
- Postgres
- Spring boot
- Spring jpa
- Spring security
- JWT (Stateless)
- Saving boilerplate code with (lombok, mapstruct, hibernate-validator)
- Two ways mapping
- TDD (Mockito, WebMvcTest, DataJpaTest, ArchUnit)
- E2E test with SpringBootTest and TestContainers

## About the project

The project is the starting point for backend of a online store, where we have
users, roles, products, with images, the project just intent to be a guide of

- strategies
- architecture
- folder/file organization
- documentation

The project on purpose do not going very far with the features because is a
stating point.

## Features

It's a very CRUDy application, but is has the basics to start a new project
with good practices.

- Login creating JWT token
- Register a new user (open to any)
- Admin can add roles to users
  - relation many to many between users and roles.
- The endpoints are protected using different levels of roles
- CRUD products with images
  - Relation one to many between users and products
  - Relation one to many between products and images
  - Upload image
  - See image
- Soft deleting
