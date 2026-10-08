class A:
    def method(self):
        print("Method in A")

class B(A):
    def method_b(self):
        print("Method in B")

class C(A):
    def method_c(self):
        print("Method in C")

class D(B, C):
    pass  # No method

class E(C):
    def method_e(self):
        print("Method in E")

class F(D, E):
    pass  # No method

class G(F, B):
    pass  # No method

obj = G()
obj.method()  
obj.method()  




# -----------INTERFACE

class VehicleInterface(ABC):
    @abstractmethod
    def start(self):
        pass

    @abstractmethod
    def stop(self):
        pass

class Car(VehicleInterface):
    def start(self):
        print("Car engine started")
    def stop(self):
        print("Car stopped")

class Bike(VehicleInterface):
    def start(self):
        print("Bike started")
    def stop(self):
        print("Bike stopped")

vehicles = [Car(), Bike()]
for v in vehicles:
    v.start()
    v.stop()


'''
Car engine started
Car stopped
Bike started
Bike stopped


'''