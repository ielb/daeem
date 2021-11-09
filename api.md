# REFUND ORDER 

LINK      : {{URL}}/order/refund
METHODE   : POST
DATA      : order_id (int) , client_id (int) , reason (varchar).
Accept    : application/json


# GET ALL STORES TYPES  

LINK      : {{URL}}/stores_types
METHODE   : GET
Accept    : application/json



# GET PRODUCT VARIANTS  

LINK      : {{URL}}/product/{productID}
METHODE   : GET
Accept    : application/json



# GET CLIENT ORDERS 

LINK      : {{URL}}/client/{clientID}/orders
METHODE   : GET
Accept    : application/json


# GET ORDER STATUS (HISTORY)

LINK      : {{URL}}/order/{orderID}
METHODE   : GET
Accept    : application/json


# GET ORDER HISTORY 

LINK      : {{URL}}/order/{ID}/statuses
METHODE   : GET
Accept    : application/json


# GET NEARBY STORES BY STYPE
LINK      : {{URL}}/stores_by_type
METHODE   : POST
DATA	  : lng , lat , store_type
Accept    : application/json

# CHECK CLIENT EMAIL 
LINK      : {{URL}}/client/check_email 
METHODE   : POST 
DATA   : email varchar 
Accept    : application/json 
Authorization : Bearer Cf1YJ53jv7aZjMVV78B8giP7S1fP2oBtGkLGsmGy
