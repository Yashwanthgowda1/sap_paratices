import random
import string
from datetime import datetime, timedelta
import requests

def crete_a_booking_random():
    firstname = ''.join(random.choices(string.ascii_lowercase, k=8))
    lastname = ''.join(random.choices(string.ascii_letters, k=6))
    totalprice=random.randint(100,500)
    print("the random price genrate is ", totalprice, lastname, firstname)
    depositpaid=random.choice([True, False])
    # genrate the data random
    checkin_time=(datetime.today()+ timedelta(days=1)).strftime("%Y-%m-%d")
    checkout_time=(datetime.today()+timedelta(days=3)).strftime('%Y-%m-%d')
    user_data = {
        "firstname": firstname,
        "lastname": lastname,
        "totalprice": totalprice,
        "depositpaid": depositpaid,
        "bookingdates": {
            "checkin": checkin_time,
            "checkout": checkout_time
        },
        "additionalneeds": "Breakfast"
    }
    print(user_data)
    return user_data


# session={}
# def create_a_new_session(alias, base_url):
#     # storing teh multipal create session in dict
#     session[alias]=requests.session()
#     # add the end point to it
#     session[alias]=base_url
#     return session[alias]
    
    
# def close_current_session(alias):
#     if alias in session:
#         session[alias].close()
#         del session[alias]

from dotenv import load_dotenv
import os
load_dotenv()
def generate_token() -> tuple[str, str]:
    user_name = os.getenv("username")
    password = os.getenv("password")
    return user_name, password

return_tupel=generate_token()
print(return_tupel)