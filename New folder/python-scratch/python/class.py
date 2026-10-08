# class Main:
#     def __init__(self, name, place):
#         self.name = name
#         self.place = place
#
#     # Instance method
#     def instance_method(self):
#         print("Instance values:", self.name, self.place)
#
#     # Class method
#     @classmethod
#     def class_method(cls, naming):
#         print("Class name:", cls.__name__)
#         print("Passed value:", naming)
#
#     # Static method
#     @staticmethod
#     def static_method(naming):
#         print("Static method received:", naming)
#         # Main.instance_method()   when access through the object creation only other not able to aess
#         # cannot access self or  cls here
#
#
#
# a1 = Main("amma", "holenarsipura")
#
# a1.instance_method()
# Main.class_method("test-class")
# Main.static_method("test-static")
#
#
#


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
    variable = "child variable"

    def __init__(self):
        self.username = "child username"

        # call parent instance method
        super().instance_method()

        print("In constructor:", self.username)

    def instance_method(self):
        print("Child instance method")
        print("Username:", self.username)

        # calling parent class variable using self
        print("Parent variable via self:", self.variable)

        # calling parent methods correctly
        Parent.static_method(self)
        Parent.class_method(self)

        print("End of child instance method")


# Test
child_obj = Child()
child_obj.instance_method()
