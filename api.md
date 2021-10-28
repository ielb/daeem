# REFUND ORDER 

LINK      : {{URL}}/order/refund
METHODE   : POST
DATA      : order_id (int) , client_id (int) , reason (varchar).
Accept    : application/json
Authorization : Bearer Cf1YJ53jv7aZjMVV78B8giP7S1fP2oBtGkLGsmGy

# GET ALL STORES TYPES  

LINK      : {{URL}}/stores_types
METHODE   : GET
Accept    : application/json
Authorization : Bearer Cf1YJ53jv7aZjMVV78B8giP7S1fP2oBtGkLGsmGy


# GET PRODUCT VARIANTS  

LINK      : {{URL}}/product/{productID}
METHODE   : GET
Accept    : application/json
Authorization : Bearer Cf1YJ53jv7aZjMVV78B8giP7S1fP2oBtGkLGsmGy


# GET CLIENT ORDERS 

LINK      : {{URL}}/client/{clientID}/orders
METHODE   : GET
Accept    : application/json
Authorization : Bearer Cf1YJ53jv7aZjMVV78B8giP7S1fP2oBtGkLGsmGy

# GET ORDER STATUS (HISTORY)

LINK      : {{URL}}/order/{orderID}
METHODE   : GET
Accept    : application/json
Authorization : Bearer Cf1YJ53jv7aZjMVV78B8giP7S1fP2oBtGkLGsmGy

# GET ORDER HISTORY 

LINK      : {{URL}}/order/{ID}/statuses
METHODE   : GET
Accept    : application/json
Authorization : Bearer Cf1YJ53jv7aZjMVV78B8giP7S1fP2oBtGkLGsmGy

# GET NEARBY STORES BY STYPE
LINK      : {{URL}}/stores_by_type
METHODE   : POST
DATA	  : lng , lat , store_type
Accept    : application/json
Authorization : Bearer Cf1YJ53jv7aZjMVV78B8giP7S1fP2oBtGkLGsmGy