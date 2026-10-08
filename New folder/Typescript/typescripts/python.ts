// let anser: any="amma"
// console.log(typeof(anser)==="string" ? "it will string" : "it will numer")

import { ar } from "@faker-js/faker";

// type thecalling={
//     yashu:number,
//     cpllege:string,
//     getfunc():string[]
// }
// function callingmain(){
//     const objectcreation:thecalling={
//         yashu: 10,
//         cpllege:"asshn gec",
    
//         getfunc(){
//             console.log("the function is created object to access insde the type")
//             return [String(this.yashu), this.cpllege]
//     }
// }
// const string_array:string[]=objectcreation.getfunc()
// console.log(string_array)

// }
// callingmain();


// let two_values: (string | number  )= 10
// two_values+=20
// console.log(two_values)



let arr = [10,20,30];

// let itr = arr[Symbol.iterator]();
// // default next return 10  nad false make this true
// let result=itr.next()
// if(!result.done){
//     console.log(result.value)
//     if (result.value as number){
//         console.log(result.value)
//     } 

// }

for( let ecahvlaues of arr){
    console.log(ecahvlaues)
}

for( let ecahindex in arr){
    console.log(ecahindex)
}

// while(!result.done){

//    console.log(result.value);

//    result = itr.next();
// }

// fyunctions

let array:(string | number) [] =["ammma", "appa", 1,2 ,3,4,10]
array.push("amma1")
console.log(array)
let anser=array.pop()
console.log("the pop ement "+ anser)
array.unshift("appa")
console.log(array)
array.shift()
console.log(array)

console.log(array.includes("appa"))
console.log(array.join("-"))
console.log("the slice")
console.log(array.slice(0, 2))
console.log(array.splice(2, 20))
// annomyis function

const values=function(string:number){
    console.log("the no name function")

}

values(10)


// call back function 

function maincallback(my_creted_callback:(storearry:number[],...arr:(string | number)[] )=> void , storearry: number[],...arraysing:(number | string)[]){
        const stringing:string []=[];
        arraysing.forEach(eachvalues=>{
    if(typeof(eachvalues)==="number"){
       
        my_creted_callback(storearry, eachvalues );
    }
    else{
         stringing.push(eachvalues);

    }
})
    my_creted_callback(storearry, ...stringing)

    console.log("all the values we getting is "+storearry)
}




function exicute_browser( storearry:number[],...arr:(string | number)[]){
    // each string make convert to asci values 
    arr.forEach(each => {

    if(typeof(each) === "string") {

        let arrays: string[] = each.split("");
        console.log("the after spliting " + arrays)
        for(let ch of arrays) {

            let ascii = ch.charCodeAt(0);

            storearry.push(ascii);
        }
        console.log("the next string taking")
    }

    else{
        storearry.push(each)
    }
})
  

}


maincallback(exicute_browser, [], "string", "queueMicrotask",3,5,5,666,6)

type Values = {
    name: string,
    valuesing: number,
    getmtehod(): void
}

let creation: Values = {

    name: "amma",
    valuesing: 10,

    getmtehod() {
        console.log("the values");
    }

};

creation.getmtehod();

