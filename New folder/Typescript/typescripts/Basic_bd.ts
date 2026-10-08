import { start } from "node:repl"
import { before } from "node:test"
import { string } from "zod"

let num:Array<number | string> =["amma", 1, 2,3_4,5,5]
num.push("appa")
console.log(num.pop())
console.log(num.slice(2,4))
console.log(num.splice(2,3))
num.unshift("fisrtvaluegetadd")
console.log(`the psoition of the amma is ${num.indexOf("amma")}`)
console.log(num.includes("amma"))
console.log("we are access the data like this " + num[0])
console.log(num)

if (typeof num[0] === "string") {
    console.log(num[0].toUpperCase())   // "amma"
}


// there is function where need to find uniqlargest string

let values:string="ivikatakavi"
// posibality of the all palidromes

function callbackedpalidome(start:number, end:number, values:string, arraylist:Array<String>):void { 
    while(start>=0 && values.length>end && values[start] === values[end]){
        let actual=values.slice(start, end+1);
        // if there is two separte string means notplidrom ex string1 string2
        if(!actual.includes(" ")){
            let aftre=actual.split("").reverse().join("");
            console.log(`ecah comaprison things is --> ${actual} and after compare ${aftre}`)
            if (actual===aftre && actual.length > 1){

             arraylist.push(actual);
        }
    }
    start--;
    end++;
   

}
}

function mainfunction(values:string, callbackedpalidome:(start:number , end:number, stringanser:string, arraylist:Array<string>)=>void): string []{
    let arraylist:Array<string>=[];
    for(let i=0;i<values.length-1;i++){
        callbackedpalidome(i, i, values, arraylist);
        callbackedpalidome(i, i+1, values, arraylist);
    }
    return arraylist;

}
// let final_arrays:string[]=mainfunction(values, callbackedpalidome);
// console.log(final_arrays)


// longest string withoutretingdupliactes

let anser=(restoprater:string)=>{
    let maps=new Map<string, number>();
    let maxLength=Number.MIN_SAFE_INTEGER   
    let left=0;
    let start=0;
  
    for(let ecah in restoprater){
        if (maps.has(restoprater[ecah])) {
            left = Math.max(left, maps.get(restoprater[ecah])! + 1);
        }

        maps.set(restoprater[ecah], +ecah);

        if (maxLength < +ecah - left + 1) {
            maxLength = +ecah - left + 1;
            start = left;
        }



        }
        console.log("the longest string is "+ restoprater.substring(start, start+maxLength));

    }



anser(values)