# Architecture Guidelines

## Resources

For this code I'm using as base the following resources:

1, The book **Get Your Hands Dirty on Clean Architecture**, here I took mainly
the hexagonal architecture, divide project in sub-modules, archunit and mapping strategies.

2, The book **Spring in Action, 6Ed**, here I took the bases of spring
like the management of beans, profiles, lombok, mapstruct and the TDD practices.

3, The book **Clean code of Robert C. Marting**, here I took general ideas
of what is and how to apply clean code.

## Rules

1, The adapter must only access to the domainX.visible.port interfaces.

2, Driven and driving adapters don't have to depended each other, for example,
X.inWeb must not call to classes in X.outDB, with the exception of Entities and
their respective mappers.

3, The domain libraries must be divided in two packages, one called visible and other
call internal, to identify visually what can be acceded outside the module.

4, The inter module dependencies, should keep the less posible and/or avoided,
but if is required so make it through the package commons, for example, dependencies
between users and products must happen through the module commons and only throw
interfaces and MDTO (Module Data Transfer Object).

## Definitions

Reading the different books they really don't explain the role of each type of
class, so I will define here some of them, to be clear what it does each module,
package and type of class do.

Modules (project-jar)

- **Adapter**: The responsibility of this module is to deal with the outside world,
  that includes everything that comes form the user as requests, responses, json
  error handling, etc.. Also persistence including database, cache, etc. Also
  for convenience I deal with authentication and define the scope of a transaction
  in this module.

- **DomainX**: For example, user, product, shopping, etc, these are a representation
  of a business domain, and we can access to this logic through interfaces and dtos
  in the visible package, and and also they can have an api package that implements
  the interfaces in common, so modules can depend between them without a direct coupling.

- **common**: for inter-module-dependency, all modules depend on this module,
  so for the sake of the simplicity, this module should have only simple; dtos,
  IMD interfaces and utils.

Adapter packages

- **common**: Implementations that are includes or use all domain,
  for example, authentication is used by all domain like users or products, the
  same for error handling.

- **domainX**: Implementations of domainX.visible.port.in and out, so the business
  logic can deal with the external world without to have to implement itself.

- **domainX.inWeb**: The "inWeb" is a combination of; "in" that refers to the
  driving adapters, and "web" that refers that the communication is via web,
  for example, for a CLI adapter could be "inCLI".

- **domainX.outDB**: The "outDB" is a combination of; "out" that refers to the
  driven adapters, and "db" that refers that the communication is via a traditional
  database, in my case a relational sql database using jpa and Postgres.

- **domainX.utils**: are common tasks between both adapters, in my case mappers.
  Note: as I'm using two ways mapping is almost required the library *mapstruct*,
  that sometimes can be a little confusing but saves more time dealing with complex
  mapping via this library that doing it manually.

DomainX Packages

- **Internal and Visible**: These packages are inside of the domain modules,
  they only are a visual mark of which part is accessible by other modules,
  for example, adapter module and other domain modules.

- **internal.helper**: Here I have the helpers, that helps with the business logic.

- **internal.service**: It's where I execute my logic business logic, which can
  be helped by helpers, but id is simple also the service could implement it too.

- **visible.api**: Here there is the implementations of common.depends.domainX,
  where are expressed the inter module dependencies.

- **visible.port**: These packages define the Dtos and interfaces so the domain can
  speak with the outside world, and it will be the responsibility of the module
  adapter to implement and use them.

- **visible.port.dto** Here I define the dtos which domainX and adapter will
  communicate with.

- **visible.port.in**: It's all the input that other system triggers, for example, a web
  request and response, in my case is just an api web restful json, but it could
  be an CLI, UI, etc.

- **visible.port.out**: It's all the output that our system triggers, for example, is my
  case is the SQL sended to postgres, but it could be an Email service, message
  broker, etc.

Clases

- **Controller**: These classes implements the interfaces in domainX.port.in.

- **DbAdapter**: These classes implements the interfaces in domainX.port.out.

- **Service**: This type of classes execute business logic, and depending if the
  business is not complex also it implements it, but if the business turns complex
  with the evolutions so this can make use of Helpers.

- **Helper**: These classes implement business logic, To reduce responsibility to
  services.

- **Util**: Utils are classes without a state, all their methods are static.

- **Dto**: (Data Transfer Object) these classes hold just information to be passed
  from one module-jar to another, and they should be a few ones to keep simple
  the communication between modules, so when we try to understand the whole less
  elements are involved.

- **Depends**: They are interfaces that domain modules use to depend of each other,
  and as input and output use MDto.

- **MDto**: They are objects to communicate between modules.
