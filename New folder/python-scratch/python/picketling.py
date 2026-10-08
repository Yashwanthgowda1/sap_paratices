# import  pickle
# with open("thepickel1.pkl", "wb") as f:
#     value=("how rae you")
#     pickle.dump(value, f)
#
# with open("thepickel1.pkl", "rb") as f:
#     valalalal = pickle.load(f)
#
#     print(valalalal)


import json
ind=[1,2,3,4,5,6]
values=json.dumps(ind)
print(type(values))
v1=json.loads(values)
print(type(v1))