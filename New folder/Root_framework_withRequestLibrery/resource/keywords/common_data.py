import  random
import  string
from  datetime import  datetime, timedelta

def create_a_random_payload() :
    firstname=''.join(random.choices(string.ascii_lowercase.casefold(), k=8))
    lastnames = ''.join(random.choices(string.ascii_lowercase, k=9))
    digits=''.join(random.choices(string.digits, k=5))
    totalprice = random.randint(100, 500)
    print("the random price genrate is ", totalprice, lastnames, firstname)
    depositpaid = random.choice([True, False])
    # genrate the data random
    checkin_time = (datetime.now() + timedelta(days=1)).strftime("%Y-%m-%d")
    checkout_time = (datetime.now() + timedelta(days=3)).strftime('%Y-%m-%d')
    user_data = {
        "firstname": firstname,
        "lastname": lastnames,
        "totalprice": totalprice,
        "depositpaid": depositpaid,
        "bookingdates": {
            "checkin": checkin_time,
            "checkout": checkout_time
        },
        "additionalneeds": "Breakfast"
    }
    return user_data






