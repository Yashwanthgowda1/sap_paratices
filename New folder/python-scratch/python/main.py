string="i love y chaya not really"


# print(''.join(string[:10].split()))
#
# print(' '.join(x[::-1]   for x in string.split(' ')))
listvalue=string.split(' ')
empty=[]
for x in range(len(listvalue)):
    expected_len = x + 1
    if len(listvalue[x])==expected_len:
        empty.append(listvalue[x])

    elif len(listvalue[x])<expected_len:
            actuall_diffrence = expected_len-len(listvalue[x])
            main_value=listvalue[x]+(actuall_diffrence * '#')
            empty.append(main_value)
    else:
            actuall_diffrence =len(listvalue[x])-expected_len
            main_value = listvalue[x][:expected_len]+(actuall_diffrence* '#')
            empty.append(main_value)
print("the remaing the string " , empty)





#####   revrese the each string and in comp methods
print(' '.join(x[::-1]  for x in string.split(' ')))

### asic vALES INTO
result=0
for eachstring  in string.split():
    for ch in eachstring:
        result+=ord(ch)
print(result)

# remove the dupliactes repaing character
string = "abbsssddd"
from  collections import  Counter

print(Counter(string))


# or  other function
dictinory={}

'''
for ch in string:
    if ch in dictinory:
        dictinory[ch]+=1
    else:
        dictinory[ch]=1
'''
for ch in string:
    dictinory[ch]=dictinory.get(ch, 0)+1

print( [(k, v)  for k , v in dictinory.items() if v>1])


# convert to set  and string we have inbuit called count methods
for ch in set(string):
    count=string.count(ch)
    if count>1:
        print(count, ch)


print(complex(1, 7))


def extract(palidrome, end):
    for i in end:

palidrome="ivakataki"
# use the concept call odd and even
for i in range(1, len(palidrome)):
    extract(palidrome, i)
    extract(palidrome, i-1)












