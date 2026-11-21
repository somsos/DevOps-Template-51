# System tests

These tests are implemented in test/java/daj/e2e, and imitate an normal use
session of a user.

## Check authentication functionality

We use these 3 endpoints

- /auth/check-user-role
- /auth/check-product-role
- /auth/is-logged

1, Login wih admin user (mario1)
  
- The 3 endpoints should get a 200

2, Login with product_admin (mario2)

- Only `check-user-role` should get an an 403 role

3, Register a new user with `/auth/register` and hit the 3 endpoints

- Only `/auth/is-logged` should get a 200 response the others an 403

<!-- 

######################################################################
######################################################################

-->

## Check products with images functionality

1, Log with a user with products role
