// Parent class
class Inheritance {
    static String staticBlock;

    static {
        staticBlock = "The static block in Parent";
        System.out.println("Static block: " + staticBlock);
    }

    int variables = 10;

    public void nonStatic() {
        System.out.println("Parent non-static method, variables = " + variables);
    }
}

// Child class
class Method2 extends Inheritance {
    int variables = 20;

    @Override
    public void nonStatic() {
        System.out.println("Child non-static method");
        System.out.println("Parent variable using super: " + super.variables);
        System.out.println("Child variable using this: " + this.variables);
    }
}

// Grandchild class
public class InnerInheritance extends Method2 {
    int variables = 30;

    @Override
    public void nonStatic() {
        System.out.println("Grandchild non-static method");
        System.out.println("Parent variable using super.super (not allowed directly in Java)");
        System.out.println("Child variable using super: " + super.variables);
        System.out.println("Grandchild variable using this: " + this.variables);
    }

    public static void main(String[] args) {
        InnerInheritance obj = new InnerInheritance();
        obj.nonStatic(); // calls grandchild method

        // Access parent class variable/method
        Inheritance parentObj = new Inheritance();
        System.out.println("Parent variable: " + parentObj.variables);
        parentObj.nonStatic();

        // Access child class variable/method
        Method2 childObj = new Method2();
        childObj.nonStatic();
    }
}
