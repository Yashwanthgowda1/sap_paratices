
/***
 * 
 * 
 * 
 * artamatic operater 
 * logica operater    && || !
 * bitwise operter & ~ ^  !=> also sone time decalre so that not return the  null error during the runtime
 * shift opeter
 * asignment opetert += -=  = *=
 * specialtype 
 * 1. nullish opeter
 * spread opeter and rest opeter
 * unioon and interectyion 
 * type operter in genrally we use for the api respovce we get in dict need to valiedate or pass the values aiuth content type
 */

import console from "node:console";
import { join } from "node:path";

// let arr: (number | null)[] = [1, 2, null];
// console.log(arr!.length)

let arr: (number | string)[] | null = null;
console.log(arr)

let a:number=10;
let b=3;
console.log(-(a+1))

// nullish opetere which value not declred return the undifined
let x1;
let value=x1 ?? undefined;
console.log(value)

// 

let arr1: Array<string | number> =["AMMA", "appa", 1, 4 , "yasru"]
arr1[6]="yashu"
arr1.push(10)
arr1.pop()
console.log(arr1.slice(1, 5))     // just like  python sclicing
console.log(arr1.reverse())   // revers the array
console.log(arr1.concat([1,2,3]))
console.log(arr1.length)  // concat just concat give new variable to store the vlaues
console.log(arr1.join(" -"))      // it will add the all the arry by values required
console.log(arr1.splice(1, 4))    // modify the arry by index values replace 
arr1.unshift("starting")
console.log(arr1)
arr1.shift()
console.log(arr1)

// spread opeter
let newarray:(string | number)[]=[...arr1, 1,2 ,"new array"]
console.log(newarray)

// rest opeter
let [a2, b3 , ...unknownbalues] = [10, 20, ...arr1]
console.log(a2)
console.log(...unknownbalues)




type splinder={
    name:string;
    number:number
}
type autotication={
    stringvalue: string
    boolenas: boolean
}
type newcombin = splinder & autotication;

let obj: newcombin = {
    name: "Yash",
    number: 123,
    stringvalue: "hello",
    boolenas: true
};
console.log(obj.boolenas)





