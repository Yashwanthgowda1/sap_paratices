import { it } from "node:test"
import { RetryAgent } from "undici-types"

// normal function
function  normalfunction(data:number): string{
    return  `normalfunction  ---> ${data}`
    }
let collect=normalfunction(10) 
console.log(collect)




// annomyis or arrow function


   // it is arraw function need to write inisde the {}  but no arrow function dirctly canw write

/***
 * single expression
 * console.log("The string value is " + stringvalues);

  let arr = numberpassing.map(item =>
    typeof item === "number" ? item * 2 : item
  
 */
let answerthearrow=(numberpassing: (number | string ) [] , stringvalues:string) : (number | string )[] | boolean =>{
    console.log ("the string values is "+ stringvalues)
 
switch(stringvalues){
        case "filter" : return numberpassing.filter(filtering=> 
                    typeof filtering === "number" && filtering % 2 === 0

                )
                

     
case "map":
// if nothing found menma final retur we cannot do so retir  in here itself
   return numberpassing.map((iteam)=>{
    if(typeof iteam==="number"){
        return iteam*2
    }
    else{
        return iteam
    }
    }
  
)
case "some" : const values=numberpassing.some((item, index)=>{
     if (typeof item === "number" && item % 3 === 0) {
        console.log("console log passed for", item);
        return true; // ✅ must return true if condition passed
    } else {
        return false; // return false otherwise
    }

})
return  values


case "some" : const values1=numberpassing.every((item, index, numberpassing)=>{
     if (typeof item === "number" && item % 3 === 0) {
        console.log("console log passed for", item);
        return true; // ✅ must return true if condition passed
    } else {
        return false; // return false otherwise
    }

})
return  values1

 default:
      console.log("Unknown operation");
      return numberpassing; 
}
}


 let returnNumber1: (number | string )[] | boolean = answerthearrow(
  [1, 2, 3, 4, 5, "string"],
  "some"
)
console.log(returnNumber1)


// every when all condition satified then return 


// overloding function declare the function not have body
function getInfo(num: number): number;               // Call with 1 number
function getInfo(str: string, num: number): number;

function getInfo(numOrStr: number | string, num?: number): number {
    let sum = 0;

    if (typeof numOrStr === "number") {
        sum += numOrStr;  // single number
    } else {
        // if it's string, sum ASCII codes of characters
        for (let char of numOrStr) {
            sum += char.charCodeAt(0);
        }
    }

    if (num !== undefined) {
        sum += num; // add second number if provided
    }

    return sum;
}


// make multipal of 2 using call bakc

let arrowfuncyion =(numbers:(number | string)[], callback: (takevalues: number | string) => number | string ):(number | string)[]=>{
 let result: (number| string)[] = [];
    for (let n of numbers) {
        result.push(callback(n)); // call callback on each number
    }
    return result;
}

let doubleOrKeepString = (takevalues: number | string): number | string => {
  if (typeof takevalues === "number") {
    return takevalues * 2;
  } else {
    return takevalues; // keep string as is
  }
};

let number:(number | string)[]=[1,2,3,4,5,6 , "java"]
let result =arrowfuncyion(number, doubleOrKeepString)
console.log(result);




