import copy
list=["amma", "sharry", "ages", {"amma", "gass"}]
shallowcopy=copy.copy(list)
shallowcopy[3].add("my sexy")
print(shallowcopy)
print(list)
deepcopy=copy.deepcopy(list)
deepcopy[3].add("new deepcopy")
print(deepcopy)
print(list)

# Shallow copy shares references of inner objects
# it will copy like ["amma", "sharry", "ages", ref1]  and when you modify the things reflect to oringanl .



