# API

- [API](#api)
  - [Auth](#auth)
    - [Login](#login)
    - [Register](#register)
    - [is-logged](#is-logged)
    - [check-user-role](#check-user-role)
    - [check-product-role](#check-product-role)
  - [Products](#products)
    - [Save](#save)
    - [Find by id](#find-by-id)
    - [Delete by id](#delete-by-id)
    - [Update by id](#update-by-id)
    - [Find by page](#find-by-page)
    - [Product image](#product-image)
    - [Upload image](#upload-image)
    - [See image](#see-image)
    - [delete image](#delete-image)
  - [Users Crud](#users-crud)
    - [get by page](#get-by-page)
    - [Find user by id](#find-user-by-id)
    - [See user picture](#see-user-picture)
    - [Update user](#update-user)
  - [Quick notes](#quick-notes)

## Auth

### Login

```bash
curl -X POST -i \
  --header "Content-Type: application/json" \
  --data '{"username":"mario1","password":"mario1p"}' \
  http://localhost:8080/auth/create-token
```

### Register

```bash
curl -X POST -i \
  --header "Content-Type: application/json" \
  --data '{"username":"mario3","password":"mario3p", "email":"mario3@email.com"}' \
  http://localhost:8080/auth/register
```

### is-logged

With this route we can check if the user is logged, any registered and with
valid token user should get an 200 response, and with no token or invalid
token should get a 403

```bash
curl -X GET -i \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiItOTkiLCJpYXQiOjE3MzA4NTM2NTEsImV4cCI6MTczMDg1NDg1MX0.WB-C4OCFNAKKzT8MO6Yi1glm2iBR_vZ_p_aQoP57o-k" \
  http://localhost:8080/auth/is-logged
```

### check-user-role

```bash
curl -X GET -i \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiItOTkiLCJpYXQiOjE3MzA4NTM2NTEsImV4cCI6MTczMDg1NDg1MX0.WB-C4OCFNAKKzT8MO6Yi1glm2iBR_vZ_p_aQoP57o-k" \
  http://localhost:8080/auth/check-user-role
```

### check-product-role

```bash
curl -X GET -i \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiItOTkiLCJpYXQiOjE3MzA4NTM2NTEsImV4cCI6MTczMDg1NDg1MX0.WB-C4OCFNAKKzT8MO6Yi1glm2iBR_vZ_p_aQoP57o-k" \
  http://localhost:8080/auth/check-product-role
```

____

## Products

### Save

```bash
curl -X POST -i \
  --header "Content-Type: application/json" \
  --data '{"name":"trompo1","price":10.10, "amount": 10, "description": "Trompo numero 1", "idOwner": -99}' \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiItOTkiLCJpYXQiOjE3MzA4NTM2NTEsImV4cCI6MTczMDg1NDg1MX0.WB-C4OCFNAKKzT8MO6Yi1glm2iBR_vZ_p_aQoP57o-k" \
  http://localhost:8080/products
```

### Find by id

```bash
curl -i -X GET \
  --header "Content-Type: application/json" \
  http://localhost:8080/products/1
```

### Delete by id

```bash
curl -X DELETE -i \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiItOTkiLCJpYXQiOjE3MzA4NTM2NTEsImV4cCI6MTczMDg1NDg1MX0.WB-C4OCFNAKKzT8MO6Yi1glm2iBR_vZ_p_aQoP57o-k" \
  http://localhost:8080/products/1


curl 'http://localhost:8080/products/1' -i \
  -X 'DELETE' \
  -H 'Accept: application/json, text/plain, */*' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiItMTAwIiwiaWF0IjoxNzM0MTM0MTg0LCJleHAiOjE3MzQxMzUzODR9.vKHxcd3Qoffm7uw0ba0MUHG303gcCQdsps0BZMjwAf0'
```

### Update by id

```bash
curl -X PUT -i \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiItOTkiLCJpYXQiOjE3MzA4NTM2NTEsImV4cCI6MTczMDg1NDg1MX0.WB-C4OCFNAKKzT8MO6Yi1glm2iBR_vZ_p_aQoP57o-k" \
  --data '{ "description": "Trompo numero 1111" }' \
  http://localhost:8080/products/1
```

### Find by page

Request

```shell
curl -X GET -i \
  --header "Content-Type: application/json" \
  "http://localhost:8080/products/page?page=0&size=5"
```

Response

```json
{
   "content" : [
      {
         "amount" : 25,
         "id" : 6,
         "images" : [],
         "name" : "Wireless Earbuds",
         "price" : 49.99
      },
      {
         "amount" : 100,
         "id" : 7,
         "images" : [],
         "name" : "Backpack",
         "price" : 39.99
      },
      {
         "amount" : 35,
         "id" : 8,
         "images" : [],
         "name" : "LED Desk Lamp",
         "price" : 34.99
      },
      {
         "amount" : 60,
         "id" : 9,
         "images" : [],
         "name" : "Notebooks Set",
         "price" : 12.5
      },
      {
         "amount" : 15,
         "id" : 10,
         "images" : [],
         "name" : "Cooking Utensils Set",
         "price" : 19.99
      }
   ],
   "empty" : false,
   "first" : false,
   "last" : true,
   "number" : 1,
   "numberOfElements" : 5,
   "pageable" : {
      "offset" : 5,
      "pageNumber" : 1,
      "pageSize" : 5,
      "paged" : true,
      "sort" : {
         "empty" : true,
         "sorted" : false,
         "unsorted" : true
      },
      "unpaged" : false
   },
   "size" : 5,
   "sort" : {
      "empty" : true,
      "sorted" : false,
      "unsorted" : true
   },
   "totalElements" : 10,
   "totalPages" : 2
}
```

### Product image

### Upload image

```shell
curl -v \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiItOTkiLCJpYXQiOjE3MzA4NTM2NTEsImV4cCI6MTczMDg1NDg1MX0.WB-C4OCFNAKKzT8MO6Yi1glm2iBR_vZ_p_aQoP57o-k" \
  -F image=@./temporal/small_blue.png  \
  http://localhost:8080/products/1/image
```

### See image

```shell
curl -i -X GET http://localhost:8080/products/image/1
```

### delete image

```shell
curl -i -X DELETE \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiItOTkiLCJpYXQiOjE3MzA4NTM2NTEsImV4cCI6MTczMDg1NDg1MX0.WB-C4OCFNAKKzT8MO6Yi1glm2iBR_vZ_p_aQoP57o-k" \
  http://localhost:8080/products/image/1
```

____

<!--

######################################################
######################################################
######################################################

-->

## Users Crud

### get by page

Request

```r
curl -i -X GET \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiItMTAwIiwiaWF0IjoxNzQyNTI0MzY4LCJleHAiOjE3NDI1MzE1Njh9.Uoy0__U8SLNIjdX3Up8mSFCJfi45CTl8oIr_6dVrlJA" \
  'http://localhost:8080/users/page'

#Complex request
# Note: data-urlencode is the same that a query params, I use these for readability
curl -i -X GET \
   -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiItMTAwIiwiaWF0IjoxNzQyNTI0MzY4LCJleHAiOjE3NDI1MzE1Njh9.Uoy0__U8SLNIjdX3Up8mSFCJfi45CTl8oIr_6dVrlJA' \
  'http://localhost:8080/users/page?page=0&itemsPerPage=5&sortBy=username&sortDirection=asc&query=an'
  
```

Response

```json
{
   "content" : [
      {
         "username" : "mario1",
         "email" : "mario1@email.com",
         "id" : -100,
         "roles" : [
            { "authority" : "ROLE_admin_users", "id" : -55 },
            { "authority" : "ROLE_admin_products", "id" : -56 }
         ]
      },
      {
         "username" : "mario2",
         "email" : "mario2@email.com",
         "id" : -99,
         "roles" : [
            {
               "authority" : "ROLE_admin_products",
               "id" : -56
            }
         ]
      },
      {
         "username" : "mario3",
         "email" : "mario3@email.com",
         "id" : -98,
         "roles" : [
            { "authority" : "ROLE_admin_sells", "id" : -57 }
         ]
      }
   ],
   "currentSize" : 3,
   "itemsPerPage" : 10,
   "pageNumber" : 0,
   "totalElements" : 3,
   "totalPages" : 1
}
```

### Find user by id

```shell
curl -i -X GET \
   -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiItMTAwIiwiaWF0IjoxNzQ0NDExNzQzLCJleHAiOjE3NDQ0MTg5NDN9.mOUx5mdEXRj-LtCo2NJj_umupAnsJOA4ptNmAzyrO1g' \
  'http://localhost:8080/users/1'

```

### See user picture

```shell
curl -i -X GET "http://localhost:8080/users/1/pictures"
```

### Update user

```shell
curl 'http://localhost:8080/users/1' -X 'PUT' \
-H 'Content-Type: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiItMTAwIiwiaWF0IjoxNzQ0NDE5MzU1LCJleHAiOjE3NDQ0MjY1NTV9.6zmnCOGxOlXm8p-BrWCcBevRAkk8pCWxl5M0jBoF3p0' \
  --data-raw '{"username":"john","email":"john_doe@email.com","changePassEnabled":false,"id":1,"roles":[{"id":-56,"authority":"Products"}],"pictureFile":null}'
```





<!--

######################################################
######################################################
######################################################

-->

## Quick notes

Change from Model to DTO, because since the point of view of Domain the object that
comes and goes to the adapter is just to transport the info, what it goes more
with the definition od DTO, and it keeps things more simple to understand
(check the `Figure 9.3` of `Get Your Hands Dirty on Clean Architecture`)

- Add definitions of Service, Helper, Util, Adapter, API, Dto, etc.
