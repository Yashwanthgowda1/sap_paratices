
let emp = {
  name: "amma type of object",
  gender: "female",
  age: 78,
  getMethod() {
    return "this is get method";
  }
};
console.log(emp.name);
console.log(emp.getMethod());



// inline object
let employee :{
  name:string;
  gender:string;
  age:number;
  getMethod(): string  ;
  
}={
    name: "amma",
  gender: "female",
  age: 78,
  getMethod() {
    return "this is get inline method";
  }
}
console.log(employee.getMethod())

// alias of object
type employee ={
  name:string;
  gender:string;
  age:number;
  getMethod(): string  ;
  
}
type employee1 ={
  name:string;
  gender:string;
  age:number;
  getMethod(): string  ;
  getMethod1(): string  ;
  
}
let combined:employee & employee1={
    name: "amma34567",
    gender: "female",
    age: 78,
    getMethod() {
        return "this is get inline method";
  },
  getMethod1(){
    return "this is get method one"
  }
}

console.log(combined.getMethod1())
console.log(combined.getMethod())
console.log(combined.name)

console.log("---------------------------------------------------------------------------")

// using the calsss
class myname{
    name:string;
    place:string;
    job:string;
    empid?:number;
constructor(name:string,
    place:string,
    job:string,
    empid?:number,)
    {
        this.name=name;
        this.place=place;
        this.job=job;
        this.empid=empid;
    }
    getemp_data(empid:number):string {
        if(empid==this.empid){
            return `${this.name} is the place from ${this.place} and job ${this.job}`
        }
        return "pass employee id properly"
    }
}
// here the parent and child have same variable name need to extend 
// it firsta and using super() in herite them after this. keyword used
//  to access the parent property in child and this. keyword also used
//  in child variable access


class myplace extends myname{
    empplace:string;
    constructor(name:string,
    place:string,
    job:string,
    empid:number, empplace:string){
        super(name,place,job, empid)
        this.empplace=empplace
    }
     getemp_data(empid:number):string {
        if(empid==this.empid){
            return `${this.name} is the place from ${this.place} and job ${this.job}`
        }
        return "pass employee id properly"
    }
    getemp_data_empplace(empplace: string): string {
      
  if (empplace === this.empplace) {

// it will take from the parent node values this.e,p


    return `${super.getemp_data(this.empid)} and emp place is ${this.empplace}`;
  }
  return "pass employee details properly";
}

}


let objectcretion=new myplace("yashwnath", "holenarsipura", "software enginerr", 456789, "bengaluru")
console.log(objectcretion.empplace)
console.log(objectcretion.getemp_data_empplace("bengaluru"))
// console.log(objectcretion.getemp_data(456789))



// -----------------------------------interface concept ---------------------
// multipal interfac handle
interface CanFly {
  fly(): void;
}

interface CanSwim {
  swim(): void;
}
class buck{
    bucking(){
        console.log("this is bucking")
    }
}

class Duck implements CanFly, CanSwim {
  fly() {
    console.log("Flying");
  }

  swim() {
    console.log("Swimming");
  }
}

// have the interfce and class implement in subclass
interface CanRun {
  run(): void;
}
class Animal {
  name: string;

  constructor(name: string) {
    this.name = name;
  }

  eat(): void {
    console.log(`${this.name} is eating`);
  }
}
class Dog extends Animal implements CanRun {
  constructor(name: string) {
    super(name);
  }

  run(): void {
    console.log(`${this.name} is running`);
  }
}



// ------------------abstract method-----------------
abstract class Vehicle {
  abstract start(): void;

  stop() {
    console.log("Stopped");
  }
}

class Car extends Vehicle {
  start() {
    console.log("Car started");
  }
}
