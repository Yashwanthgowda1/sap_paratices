// import { keyof } from "zod";

// let values:number =56789;
// console.log(typeof(values))


// let v1:unknown="10"
// let v11:any="10"
// // it will pass any values , if any other wise we need to do the unkwon means need to valedate type (typscript force to defin )
// console.log(`the unkown values is ${v1}` , typeof(v1)=="string" ? v1.includes("10") : "null")


// Type inference:
//  means TypeScript automatically determines the data
//  type of a variable based on the value you assign to it.


//  typeof and instnceof --> 
// typeof use to premarive value check and instnce of used to typeof object from the particular class

// // arrays and tupel


// let  arrays: Array<string | number | (string | number )[]> =[1,2,3,4,5,6,7, 7,"ammma"]

// // arrays.push("ammma")
// // // arrays.push(["525526272","256728902", 10])
// // console.log(arrays.includes(10000))
// // arrays.unshift(10)
// // arrays.shift()
// // let newArr = arrays.join("-")
// // console.log(typeof(newArr))
// // console.log(newArr)
// // console.log(arrays.lastIndexOf(7))
// // console.log(arrays.indexOf(7))
// // console.log(arrays.splice(4,8))

// // arrays.pop()
// // console.log(arrays)


// // filetr 
// let sum=arrays.filter((values)=>{
//     if(typeof(values)=="string"){
//         console.log("the string values ", values)
//     }
//     return values
// }).reduce((strating, values)=> strating +values, "")
// console.log(sum)
// let sum1=0;
// let emptythings=arrays.reduce((stat, val, indexsss)=>{
//     if(indexsss!=3 ){
//         console.log("i dont need the third index values -->" + val )
//         return stat+val;
//     }
//     else if(typeof(val)!="string"){
//         return stat
//     }
//     return stat
    
    
// }, 0)



// let arrays_everytime=arrays.map((values)=> {
//     if(typeof values=="number"){
//         return values* 3
//     }
// });
// console.log(arrays_everytime)



// let string_value:number=123
// let numbers =String(string_value)
// console.log(numbers)

// using arrow convert each string values into ascii and give the final inetereg
let store= ( stringvalues:string[],...arr:(number | string)[]): number=>{
    let all_count=0;
    arr.forEach((value)=>{
        if ( typeof value ==="string"){
            all_count+= Anonymous(value)
        }
        if(typeof value==="number"){
            all_count+=value
        }
    })

    return all_count
}



let Anonymous=function(value_from:string): number{
    let summer=0;
    let chat_array:string[]=value_from.split("") 
    /// or we use seprate [...valueof]  --> ["u", "y"]  like this
    for( let ecah in chat_array){
        summer+=chat_array[ecah].charCodeAt(0)
    }
    return summer;

   
}
let rteurnvalues = store(
    ["ammma", "apppa", "specialhacters"],
    1, 2, 3, 4, 5, 6, 7, 8, "gagagagga", "inetegrs"
);

console.log("the erturn value sis the "+ rteurnvalues)


// find the string dupliacte and longest length of the substring
//note
// in return type if have return mutipal values ata time we pass liek object

let longest=(...arr:(string )[]):{
      map: Map<string, number >,
        max_number: number,
        max_char: string
} => {
    let map=new Map<string, number>();
      arr.forEach(each_values => {
        map.set(each_values, (map.get(each_values) || 0) + 1);
    });
    let alreday=0;
    let cahacterrep="";
// in java scrio and typescript the pair tuple is madatory and normla tuple also indicat value first string and second number

   for( let [key, values] of map){
        if(alreday<values){
            alreday=values;
            cahacterrep=key;

        }
   }
    return {
        map: map,
        max_number: alreday,
        max_char: cahacterrep
    };

}


function number_charcter_max_repteds(
    ...values: (string | number)[]
): {
    map1: Map<string, { ascii: number, count: number }>,
    numbermax_values: number
} {

    let max_value = Number.MIN_SAFE_INTEGER;

    let map = new Map<string, { ascii: number, count: number }>();

    values.forEach(v => {

        if (typeof v === "string") {

            for (let ch of v) {

                let ascii = ch.charCodeAt(0);

                let existing = map.get(ch);

                let count = existing ? existing.count + 1 : 1;

                map.set(ch, {
                    ascii: ascii,
                    count: count
                });

                let weightedValue = ascii * count;

                if (weightedValue > max_value) {
                    max_value = weightedValue;
                }
            }
        }
    });

    console.log(map);

    return {
        map1: map,
        numbermax_values: max_value
    };
}





let callbacking = (
    longestCallback: (...val: string[]) => {
        map: Map<string, number>,
        max_number: number,
        max_char: string
    },

    numberCallback: (...values: (string | number)[]) => {
        map1: Map<string, { ascii: number, count: number }>,
        numbermax_values: number
    },

    ...arr: (string | number)[]
) => {

    let onlyStrings = arr.filter(  (v): v is string => typeof v === "string");

    let result1 = longestCallback(...onlyStrings);

    let result2 = numberCallback(...arr);

    return {
        longest_result: result1,
        number_result: result2
    };
};
let finalResult = callbacking(
    longest,
    number_charcter_max_repteds,
    "a", "d", "v", "f", "g", "h", "j", "f", "f", 10, 20
);
console.log(finalResult.longest_result)
console.log(finalResult.number_result)


