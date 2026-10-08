import java.util.Scanner;
import java.util.Random;

public class encapsulation {
    private int banalce;
    private int pin;
    Scanner sc;
    Random ra;
    public encapsulation(int balance, int pin){
         sc=new Scanner(System.in);
        this.banalce= balance;
        this.pin=pin;
    }
    public int getbalance(){
        return this.banalce;
    }
    public int getpin(){
        return  this.pin;
    }
    public void setbalance(int amount){
        int balance=getbalance();
        if(balance<=500){
        System.out.println("actul balance id "+ balance);
        System.out.println("---------------------------------");
        System.out.println("mantain the minium balance "+ 500);

        }
        else{
          this.banalce+=amount;
        }
    }
    public void setpin(int pin_value){
        this.pin=pin_value;
        

    }

    public void withdrawel(int amount){
        if(this.banalce>amount  && this.banalce>=500){
            System.out.println("enter the pin to with draw");
            int pin=sc.nextInt();
            if(pin==this.pin){
                System.out.println("waiting for transcesstion");
                this.banalce-=amount;
                System.out.println("the amount "+ amount+ " withdraw is sucefully");

            }
            else{
                System.out.println("enter the pin is wrong");
            }
            
        }
        else{
            System.out.println("maintain the sufficent balance");
        }




    }
public void deposit(int amount){
this.banalce+=amount;

}
public void updatepin(){
    System.out.println("enter the main pin");
    int main=sc.nextInt();
    if(this.pin==main){

        System.out.println("welcome to genrate the pin, please enter the OTP");
       ra=new Random();
       int rand_pin=ra.nextInt(1000, 2000);
       System.out.println("the Otp is :"+ rand_pin);
        int otp=sc.nextInt();
        if(rand_pin==otp){
            System.out.println("enter the new pin");
            setpin(sc.nextInt());
            System.out.println("pin set sucefull");
        }
    }

}

}


class  encap {


    public static void main(String[] args) {

            Scanner sc=new Scanner(System.in);
        encapsulation a1=new encapsulation(1000, 12345);
        
          System.out.println("welcome to the yash bank");
              boolean falg=true;
      while(falg){
        System.out.println("enter the option /n 1. balance check  /n 2.set balance  /n 3.withdraw,  /n  4. deposite  /n 5. updatepin ");
        int value=sc.nextInt();
  
  
        switch (value) {
            case 1: int balance=a1.getbalance();
            System.out.println("the balace is "+ balance); 
                break;
            case 2: System.out.println("enter the balance amout need to set");
                    a1.setbalance(sc.nextInt());
                        break;
            case 3: System.out.println("enter the withdrawlamount");
                 a1.withdrawel(sc.nextInt());
                 break;

            case 4:System.out.println("enter the balance amout need to deposit");
                    a1.deposit(sc.nextInt());
                break;
            case 5:  System.out.println("set pin");
                    a1.updatepin();
                    break;

            default:  System.out.println("enter the crt option");
falg=false;
                break;
        }
    }
     
        
        
    }

    
}
