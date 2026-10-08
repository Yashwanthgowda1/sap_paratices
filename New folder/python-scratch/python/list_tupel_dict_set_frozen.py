# Online Python compiler (interpreter) to run Python online.
# Write Python 3 code in this online editor and run it.
python=[1,2,3,4,5,6, 2,7,8,["amma"],"docker"]
python1=[1,2,3,4,5,6, 2,7,8,["amma"],"docker"]
print(type(python))
python.append(10)
print(python)
print(python.index(["amma"]))
python.remove(8)
print(python)
copying=python.copy()
copying.append(30)
print(copying)
print(python)
print(python.count(2))
python.extend(python1)
print(python)
python.insert(3, "sadhu")
print(python)
python.reverse()
print(python)
python.sort(key=str)
print(python)



setting_values={1,2,3,4,5,6,7,8,("mamama"),("ppaaa") }
setting_values2={1,2,3,4,5,6,7,8}
print(type(setting_values))
setting_values.add("amma")
print(setting_values)
setting_values.update(["apppa"])   ## it will cosnider as the each values so that using the  list
# print(setting_values)
# new=setting_values.difference(setting_values2)
# print(new)
# setting_values.difference_update(setting_values2)
# common_values=setting_values.intersection(setting_values2)
# print(common_values)

diffrence_notpresentinbothset=setting_values2.symmetric_difference(setting_values)
print(diffrence_notpresentinbothset)



a1=frozenset(["ammma", "appa"])
print(a1)


# faltten values need
a1=[1,[2,3,4,5,[6,7,8,9],10],11,[12,23,[24,35,34]], 14]
a2=[]
def faltten_list(a1, final_answer):
    for eachvlaues in a1:
        if type(eachvlaues)==list:
            faltten_list(eachvlaues, final_answer)
        else:
            final_answer.append(eachvlaues)
    return final_answer

final1=faltten_list(a1, a2)
# need to sort

for i in range(len(final1)):
    for j in range(len(final1) - i - 1):
        if final1[j] > final1[j + 1]:
            final1[j], final1[j + 1] = final1[j + 1], final1[j]

print(final1)

data = {
    "key1": {"key11": {"key111": {"key1111": 1}}},
    "key2": {"key22": {"key222": 2}},
    "key3": {"key33": 3},
    "key4": 4
}
new_dict={}
# def recuression(data, new_dict):
#     for key, value in data.items():
#
#         if isinstance(value, dict):
#             recuression(value, new_dict)
#         else:
#             new_dict[key]=value
#
#     return  new_dict


def recuression(data, new_dict):
    for key, value in data.items():

        while type(value)==dict:
            value=list(value.values())[0]


        new_dict[key]=value





    return  new_dict

keypairs=recuression(data, new_dict)
print(keypairs)


class A:
    x=10

ob1=A()
ob2=A()
ob1.x="chabeds"
print(ob1.x)
print(ob2.x)



# aprroch 1 will be 3 for loops
#
letters = ['A', 'B']
numbers = ['1', '2']
special_chars = ['#', '@']
#
#
# Output: ['A1#', 'A1@', 'A2#', 'A2@', 'B1#', 'B1@', 'B2#', 'B2@']
output=[]
for i in range(len(letters)):
    for j in range(len(numbers)):
        for k in range(len(special_chars)):
            output.append((letters[i]+numbers[j]+special_chars[k]))
print(output)


# approch2
# using recuresion


# lis compresion
dict={
    "values":2,
    "values2": ["maaa",2,3,4,5,5],
    "vakues4": ("ajji", "values"),
    "vaues7":"daddy2"
}
valuefinal=[k if type(k)==int  else " " for i, k in dict.items()  ]
print(valuefinal)
# list nest compresion
combinationall=[
    each*2 if type(each)==int else each
    for v in dict.keys()
    for each in (dict[v] if isinstance(dict[v], (tuple, list)) else [])
    ]
print(combinationall)


import  copy

values_shallow=copy.deepcopy(dict)

for each in values_shallow.keys():
    if isinstance(values_shallow[each], list):
        values_shallow[each].append("newchnagingmainreflect")
print(values_shallow)
print(dict)



# high order function
nums = [1, 2, 3, 4]

result = list(map(lambda x: x * 10 if x > 2 else x, nums))
print(result)



def logger(func):
    def wrapper(*args, **kwargs):
        print("Logging started")
        result = func(*args, **kwargs)
        print("comming back from inise decorater")
        print("Logging ended")
        return result
    return wrapper


def timer(func):
    def wrapper(*args, **kwargs):
        import time
        start = time.time()
        print(f"the start timr ${start}" )
        result = func(*args, **kwargs)
        print("Time: ended", time.time() - start)
        print("ehat is th eresult it takes if preint given ", result)
        return result
    print("agin return to wrapper", result)
    return wrapper


@logger
@timer
def task():
    print("Running task")
    return  10

result=task()
print("the final ", result)


# file handeling readthe json and write the valies inside the file
import  json
with open("config.json", "w+") as f:
    json.dump("amma", f)

    f.seek(0)   # 🔥 IMPORTANT

    config = json.load(f)
    print(config)