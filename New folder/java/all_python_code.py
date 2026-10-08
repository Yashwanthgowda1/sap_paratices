
# longest substring which doesnot have repitaive chacter
longest="abdefagdht"
left=right=0
set_value=set()
max_value=0
start=0
while left<len(longest):
    if  longest[left] not  in set_value:
        # in list we use appedn and set we use the add (mutable and mutable set )
        set_value.add(longest[left])
        max_value=max(left-right+1, max_value)
        start=right
        left+=1
    else:
        set_value.remove(longest[right])
        right+=1
        
    

print("the max_length of the values is ", max_value-start)
print("the longest chacter is ", longest[start:start+max_value])

    
def special_hash_replacmentwithchar(string="am ambabd a bad b"):
    string_array=string.split(" ")
    string=[]
    for  indexs, word in enumerate(string_array, start=1):
    
        if len(word)==indexs:
            string.append(word)
        elif  len(word)>indexs :
            # replace morelengchacter witrhe #
             string.append(word[:indexs]+ '#'*(len(word)-indexs))
        else:
             string.append(word+(indexs-len(word))*'#')   
            
    return ' '.join(string)    
        
strings=special_hash_replacmentwithchar()   
print(strings)

 












