from pydantic import BaseModel, Field
# import the base model i can see the name of class and crte thea model for dtaa valiadtion

class person(BaseModel):
    # the base model is like fix the schema for validation
    name:str
    plaec:str
    number: int

preson=person(name="yashwnath", plaec="holnersipur", number=8)
print(preson)

from typing import Optional
# optional if not there
class optional(BaseModel):
    id:int
    place:str
    salary:Optional[float]=None   #if value is not pass it will take the non
    is_active: Optional[float]=None

returning=optional(place="holenaripura",id=67 )
print(returning)
    
# model with nested models

# the field function 
# from pydentic import basedmodel, field
class Item(BaseModel):
    name: str = Field(min_length=3, max_length=8)
    phnumber: str = Field(min_length=3, max_length=10)  # phone number as string


return_value=Item(name="ammam", phnumber="56789")
print(return_value)



# to schem description
class Item1(BaseModel):
    name: str = Field(..., description="this is default username")
    phnumber: str = Field(default="holenarsipura", description="the default value is the holenarsipura")
      # phone number as string
    distic:str=Field(default_factory=lambda:"yashu@gmail.com", description="the default name it is")



return_value=Item1(name="ammam")
print(return_value)
print(return_value.schema())

# -----------------------------------------------------------
# langgraph for built the Ai agent   '''
'''
AIagents vs agentic ai


agentic ai is : is multipale agent with complex workflow

Ai agent : is the task focused while agentic ai ia goal driven and act with more autonomy

ai agent : is refer to sw program desing to perform the specific task without human intervationa nd degree of autonomy

agnetic  ai : framework where multipal ai agent can and make decission independtly achive larger gola

'''
