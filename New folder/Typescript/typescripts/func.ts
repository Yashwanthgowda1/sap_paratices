// normal function

function name_of_thefunction(arr:(number | string)): number | string 
{
    if(typeof arr =="number"){
        return "passed the number"
    }
    else{
        return "passed the string"
    }
}
let carry=name_of_thefunction(19)
console.log(carry)


// ARROW FUNCTION
let consider=(num:number , str:string): string | number =>{
    return `${num} and the value is ${str}`
}
console.log(consider(19,"gdewka"))

// optional parameter  and Default Parameters Function
function optionla(arr:(number | string), str?:string, def:number=5): number | string 
{
    if(typeof arr =="number" && typeof str=="undefined"){
        return `${def} the default and the number ${Number}`
    }
    else{
        return `${arr }   passed the string   ${str}`
    }
    
}
let opt=optionla(19, undefined, 10)
console.log(opt)


// rest Parameters Function
let string_values = (...array: (string | number)[]): number => {
  let sum1: number = 0;

  array.forEach((value) => {
    if (typeof value === "number") {
      sum1 += value;
    } else {
      const num = Number(value);
      sum1 += isNaN(num) ? asciiValue1(value) : num;
    }
  });

  return sum1;
};

// Calculate sum of ASCII values of a string
function asciiValue1(value: string): number {
  let total = 0;
  for (let char of value) {
    total += char.charCodeAt(0);
  }
  return total;
}

// Example
console.log(string_values(67, 789, "safdhsag", "gfdhs", 56));



// overloading function
// 1 . signature
// 2. implement
// 3. pass the value
// Overload signatures
function getinfo(num: number): number;
function getinfo(num: string, numb: number): number;

// Implementation
function getinfo(num: number | string, numb?: number): number {
  let sum4 = 0;

  if (typeof num === "number") {
    sum4 += num;
  } else {
    sum4 += asciiValue3(num);
  }

  if (typeof numb === "number") {
    sum4 += numb;
  }

  return sum4;
}

// Helper function
function asciiValue3(value: string): number {
  let total = 0;
  for (let char of value) {
    total += char.charCodeAt(0);
  }
  return total;
}

// Test
console.log(getinfo("values", 10));
console.log(getinfo(20));
        


// callback function: input -> output
function getAll(callback: (...values: number[]) => number, ...numbers: number[]): void {
  console.log("Input values:", numbers);
  numbers.pop()
  numbers.unshift(20)
  const result = callback(...numbers);

  console.log("Output:", result);
}

function namedCallback(...values: number[]): number {
  let sum = 0;
  values.forEach((values)=>{
        sum+=values
  });
  return sum;
}

getAll(namedCallback, 10, 20, 30);



// call back function


function greet(anyname: (name: string) => void) {
  anyname("Yash");
}
function sayHello(name: string) {
  console.log("Hello " + name);
}

greet(sayHello);


// =================================================
let arr = [10,20,30];

arr.map((value,index)=>{
   console.log(value,index);
});

// map creation liek java how e create 

let freq: { [key: string]: number } = {};

// only reduce has the filetr the 
let numbers = [10, 20, 30];

let sum = numbers.reduce((total, value) => total + value, 0);

// 
// 📊 Most Important Array Methods
// Method	  Purpose
// push	    add last
// pop	      remove last
// shift	    remove first
// unshift	    add first
// map	      transform array
// filter	    filter values
// reduce	    combine values
// forEach	    loop
// splice	    add/remove

// ------------------------------------------------
