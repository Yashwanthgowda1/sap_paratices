class parent:
    username="amma"
    password="gandu"
    def __init__(self):
        print("the username and password is ", self.username)
        print("the username and password is ", self.password)

    def instence_methods(self, values):
        print("can i variable")
        print("inisd ethe instnnce methods" ,self.username)
        print("the values is passwed to the parent to access", values)

    @classmethod      # use case of the class method is very rarer
    def class_method(cls):
        print("enter inise the class methods")
        print("access from the username class ",cls.username)
        print("access from the passwrod class ", cls.password)

    @staticmethod
    def staticmethods(obj,value1, value2):
        print("enter to static methods")
        print("next in side the static methods access the isntnce methods")
        parent.instence_methods(obj,"amama")
        parent.class_method()

class child(parent):
    username = "daday"
    password = "mummy"
    def __init__(self):
        print("the the child class methods username and passwrod" , self.username, "and the pass ", self.password)
        super().__init__()
        print("the the parent class methods username and passwrod", super().username, "and the pass ", super().password)
    def instence_methods(self):
        super().instence_methods("child class")
        super().class_method()
        # obj is the current rference in the instence methods
        super().staticmethods(self,"amma", "amammama")
    @classmethod
    def class_method(cls):
#         only static methods is allow not instnce methods it is class object
        super().class_method()
        super().staticmethods(cls(),"ammamamam", "abssks")

    @staticmethod
    def staticmethods(obj , value1, value2):
        # there is: no slef and cls
# using super we cannot call

        parent.staticmethods(obj, value1, value2)
        parent.class_method()
        parent.instence_methods(obj, "calling parent instance method from child static")



# a1=child()
#
# a1.staticmethods(a1, "child", "amma")




# -------------absract methods

from abc import ABC, abstractmethod

class Payment(ABC):

    @abstractmethod
    def pay(slef, val, valu):
        pass


class PhonePe(Payment):

    def pay(slef, val, valu):
        print("pay using phonepe")


class GPay(Payment):

    def pay(obj, val, valu):
        print("pay using gpay")


p1 = PhonePe()
# p1.pay(a1,"amma", "ahkdsks") -->inetrnalu callss will pass the object for the object calling
# not for the calss


# duck type (in here tnec methods (object calling)
from abc import ABC, abstractmethod

class Engine(ABC):

    @abstractmethod
    def start(self):
        pass


class PetrolEngine(Engine):

    def start(self):
        print("petrol engine")


class ElectricEngine(Engine):

    def start(self):
        print("electric engine")


class Car:

    def __init__(self, engine):
        self.engine = engine

    def drive(self):
        self.engine.start()


c1 = Car(PetrolEngine())
c1.drive()

c2 = Car(ElectricEngine())
c2.drive()