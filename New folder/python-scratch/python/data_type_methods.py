# Online Python compiler (interpreter) to run Python online.
# Write Python 3 code in this online editor and run it.
print(oct(10))
print(bin(23))
print(hex(10))

# complex:
#     realpat + imaginary part
#     a+ bk
a = (10 + 20.6j)
print(a.real + a.imag)
string = "ammma ilove you"
print('/n'.join(string[1:10]))

print(complex(3, 89))

if True == 1:
    print("it will be 1 value")

values = [1, 2, 3, 3, 4, 5, "yahsu", "sharu", "raju"]
tuple_values = (1, 2, 3, 4, 5, "yahsu", "sharu", "raju")
print(values)
values.append("yasheswini")
print(values)
# values.extend(values1)
# print(values)
print(values.count(3))
values.insert(2, "amma")
print(values)
print(values.pop())
values.remove("sharu")
print(values)
# values1.clear()
# print(values1)
values.reverse()
print(values)
valuesnew = values.copy()
print(valuesnew.insert(1, "ajji"))

print(tuple_values.count(3))
print(tuple_values.index("yahsu"))

# =============================================================
set_values = {"fast", "values", "the", 78, 789, "hghsagdh"}
set_values2 = {"dd", 789789, "hghsagddddh"}
print("the set value difrenece")
new_set=set_values.difference(set_values2)
print("the bewset values is ", new_set)
# set_values.difference_update(set_values2)
print("symentic difrrnece")
set_values.symmetric_difference_update(set_values2)
print(set_values)
set_values.update(set_values2)
print(set_values)
print(set_values.issubset(set_values2))
print(set_values.issuperset(set_values2))
# print(set_values.isdisjoint(set_values2))

dict_val = {
    "amma": 1, "appa": 2, "ajji": 4
}
# y=0
# print(dict_val.fromkeys(dict_val, y))
# # print(dict_val.get("amma"))
# print(dict_val.popitem())
# dict_val["sharu"]=dict_val.get("sharu", 0)+1
# print(dict_val)
# print(type(dict_val.keys()))
# print(dict_val.values())
# dict_val.pop("appa")
# print(dict_val)
x = dict_val.setdefault("appa", 3)
print(x)






value = "sgdjksud dka doiwad"
print("The value  %amam" % value)

value = "sgdjksud dka doiwad"
print("The value {} ".format(value))

listvalue=[1,2,3,4,5,6,76,"ajhsjkhskja"]
if 2 in listvalue:
    actu=frozenset(listvalue)
    print(type(actu))













import  pickle
with open("thepickel.pkl", "wb") as f:
    value=("how rae you")
    pickle.dump(values, f)

with open("thepickel.pkl", "rb") as f:
    valalalal = pickle.load(f)

    print(valalalal)


