from functools import wraps
import subprocess
'''
# 1️⃣ Decorator to start logcat
def startlogcat(func):
    @wraps(func)
    def wrapper_logcat(device_1, jsonname, *args, **kwargs):
        print(f"Collecting log details for device: {device_1}")
        # Run adb logcat command and save to logcat.txt
        result=subprocess.run(["adb", "-s", device_1, "logcat", "-d"], stdout=open("logcat.txt", "w"))
        result.stderr
        print(f"Logs saved to logcat.txt (simulated)")
        # Call the main function
        return func(device_1, jsonname, *args, **kwargs)
    return wrapper_logcat

# 2️⃣ Decorator to clear cache
def clearcache(func):
    @wraps(func)
    def wrapper_cache(device_1, jsonname, *args, **kwargs):
        print(f"Clearing cache on device: {device_1}")
        # Clear cache logic here (simulated)
        # Example: subprocess.run(["adb", "-s", device_1, "shell", "pm", "clear", "your.app.package"])
        return func(device_1, jsonname, *args, **kwargs)
    return wrapper_cache

# 3️⃣ Main function with multiple decorators
@startlogcat
@clearcache
def wait_element(device_1, jsonname):
    print(f"Device in state: {device_1}")
    print(f"Using xpath json: {jsonname}")
    # Simulate some calculation
    return 10 + 20

# 4️⃣ Calling the function
result = wait_element("device123", "xpath.json")
print("Result:", result)

'''
# ===========================================================================================

# def functionfilepass(filepath):
#     with open(filepath, "r+", encoding="utf-8") as f:
#
#         for lines in f.readlines():
#             yield lines.strip()
#
# values =functionfilepass(filepath="newpdftotxt.txt")
# print(next(values))
# # for v in values:
#     print(v)

# memeory=iter(values)
# print(next(memeory))
# with open("newpdftotxt.txt", "r+", encoding="utf-8") as f:
#          values = (line.strip() for line in f) 
       
#          print(next(values))
#          print(next(values))
#          print(next(values))


class Parent:
    class_var = "PARENT class variable"

    def __init__(self):
        self.instance_var = "PARENT instance variable"

    def instance_method(self):
        print("Parent instance_method")

    @classmethod
    def class_method(cls):
        print("Parent class_method")
        print("cls is:", cls.__name__)

    @staticmethod
    def static_method():
        print("Parent static_method")


class Child(Parent):
    class_var = "CHILD class variable"

    def __init__(self):
        super().__init__()   # calls Parent __init__
        print("After super:", self.instance_var)

        self.instance_var = "CHILD instance variable"
        print("After child override:", self.instance_var)

    def instance_method(self):
        print("\n--- Child instance_method ---")

        # 1. Same variable name
        print("self.class_var:", self.class_var)          # Child variable
        print("Parent.class_var:", Parent.class_var)      # Parent variable
        print("super().class_var:", super().class_var)    # Parent variable

        print("self.instance_var:", self.instance_var)    # Child instance variable

        # 2. Calling parent methods from child instance method
        super().instance_method()
        super().class_method()
        super().static_method()

        Parent.instance_method(self)
        Parent.class_method()
        Parent.static_method()

    @classmethod
    def class_method(cls, obj=None):
        print("\n--- Child class_method ---")

        # cls means Child
        print("cls.class_var:", cls.class_var)            # Child variable
        print("Parent.class_var:", Parent.class_var)      # Parent variable
        print("super().class_var:", super().class_var)    # Parent variable

        # class method can call class/static directly
        super().class_method()
        super().static_method()

        # instance method needs object
        if obj:
            Parent.instance_method(obj)

    @staticmethod
    def static_method(obj=None):
        print("\n--- Child static_method ---")

        # no self, no cls
        print("Child.class_var:", Child.class_var)
        print("Parent.class_var:", Parent.class_var)

        # static can call class/static using class name
        Parent.class_method()
        Parent.static_method()

        # instance method needs object
        if obj:
            Parent.instance_method(obj)


# ---------------- TEST ----------------

child = Child()

child.instance_method()

Child.class_method(child)

Child.static_method(child)