public class objectcallmethods {
   
    String name;
    int age;

    objectcallmethods(String n, int a) {
        name = n;
        age = a;
    }

    // Overriding Object's toString method
    @Override
    public String toString() {
        return "Person[name=" + name + ", age=" + age + "]";
    }
}

class main {
    public static void main(String[] args) {
        objectcallmethods p = new objectcallmethods("Yash", 25);
        System.out.println(p); // Output: Person[name=Yash, age=25]
        String values=p.toString();
        System.out.println("the "+ values);
    }
}

