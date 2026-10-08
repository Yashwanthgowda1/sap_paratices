# class Atm:
#     # class variable
#     __pin=123456
#     bank_name="Yash Bank"
#     __amount=0
#
#
#
#     def __init__(self, username, balance):
#         print("welcome to bankk enter the username and password to login")
#         self.username=username
#         self.balance=balance
#         print(f"welcome to {self.bank_name} --> {self.__pin}")
#         self.user_login()
#
#
#         # self.withdraw=withdraw
#         # self.username=username
#         # self.password=password
#
#     def user_login(self):
#
#         if self.username == input("enter the username"):
#             # call_function_callpassword
#             if self.__pin==input("enter the password"):
#                 print(" ############# welcome to Yash Bank Login sucefull   #################")
#         else:
#             raise AssertionError (f"chekc the username and password")
#
#     def withdrawel(self, amount_values):
#         self.__check_balance_amount(amount_values)
#         self.__amount= self.__amount-amount_values
#
#
#     def __check_balance_amount(self ,amount):
#         if self.__amount < amount:
#             raise AssertionError(f"metain the sufficent balance")
#
#
#
#     def deposite(self , amount):
#
#         self.__amount=self.__amount+amount
#         print("deposite sucefull the balnce is ", self.__amount
#               )
#
#     @classmethod
#     def show_total_accounts(cls):
#         print(f"Total accounts in {cls.bank_name}: {cls.__amount}")
#
#
# a1=Atm("yashwanth", 1000)
#
# a1.deposite(20)
# a1.withdrawel(10)



# class Parent:
#     variable="parentvariable"
#     def __init__(self):
#         self.username="parent username"
#
#     def instance_method(self):
#         self.username="parent username"
#         print("Parent instance method")
#
#     @classmethod
#     def class_method(cls, obj):
#         print("Parent class method")
#         obj.instance_method()  # Can call child instance method if obj is child
#
#     @staticmethod
#     def static_method(obj):
#         print("Parent static method")
#         obj.instance_method()  # Can call child instance method if obj is child
#
#
# class Child(Parent):
#     variable="child class"
#     def __init__(self):
#         self.username="childusername"
#
#         super().instance_method()
#         print("in the constrcture ", self.username)
#
#
#     def instance_method(self):
#         print("the parent class conmtemt ", self.username)
#         super().static_method()
#         print("Child instance method")
#
#
# # Create child object
# child_obj = Child()
# child_obj.instance_method()



class Parent:
    variable = "parentvariable"

    def instance_method(self):
        self.username = "parent username"
        print("Parent instance method")

    @classmethod
    def class_method(cls, obj):
        print("Parent class method")
        obj.instance_method()

    @staticmethod
    def static_method(obj):
        print("Parent static method")
        obj.instance_method()


class Child(Parent):
    variable = "child class"

    def __init__(self):
        self.username = "childusername"
        super().instance_method()  # sets self.username = "parent username"
        print("in the constructor", self.username)

    def instance_method(self):
        print("the parent class content", self.username)
        super().static_method(self)  # ✅ pass self
        super().class_method(self)   # ✅ pass self
        print("Child instance method")


# Test
child_obj = Child()
child_obj.instance_method()


''''
class Child(Parent):
    @staticmethod
    def child_static(obj):
        # super(Child, Child).static_method(obj)   ---> this medantory slef and cls cannot pass and say to child in the parent  object child acce the parent data 
        '''