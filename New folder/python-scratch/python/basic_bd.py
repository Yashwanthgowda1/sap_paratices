# class accessparentvalues:

#     variable = "parent calss"
#     variable_integer = 0

#     # Instance variables
#     def __init__(self, variable, val):
#         self.variable = variable
#         self.variable_integer = val

#     # Instance method
#     def instnace_methods(self, values):
#         print("this instance method:", values)
#         print(self.variable_integer)
#         print(self.variable)

#     # Class method
#     @classmethod
#     def calss_methods(cls, calsmethodragu):
#         print("the class method argument:", calsmethodragu)

#         # Access class variables
#         print(cls.variable)
#         print(cls.variable_integer)

#         # Create an instance
#         obj = accessparentvalues("Yash", 10)

#         # Call instance method using object
#         print("accessing the instance method:")
#         obj.instnace_methods(calsmethodragu)

#     # Static method
#     @staticmethod
#     def staticmethods(ans):
#         print("Inside static method:", ans)

#         # Call class method explicitly using class name
#         accessparentvalues.calss_methods(ans)

# class child(accessparentvalues):
#     variable="child values"
#     def __init__(self, variable, val):
#         super().__init__(variable, val)   
#         print("the varible from child calss is ", self.variable)    
#         # can we acces sin varible instmce methods
#         super().instnace_methods(variable) 

#     def child_instance_method(self):

#         print("\n=== Child Instance Method ===")

#         # Instance variables
#         print("self.variable:", self.variable)
#         print("self.variable_integer:", self.variable_integer)

#         # Parent instance method
#         super().instnace_methods("Hello Parent")

#         # Parent class method
#         super().calss_methods("Hello Class Method")

#         # Parent static method
#         super().staticmethods("Hello Static Method")

# obj=child("amma", 10)
# obj.child_instance_method()


# selenium
