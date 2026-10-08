// let values:string[]=["ammma", "pppa", "daddy", "son", "daughter"]
// let anserarray:string[]=values.map(getvalues =>{
//     return getvalues.toUpperCase()

// });
// console.log(anserarray) 
// console.log(`the final value comes from `)
// anserarray.unshift("1","0","sharu")
// console.log(anserarray)



function sum(...numbers: number[]): number {
    return numbers.reduce((total, n) => total + n, 0);
}

console.log(sum(1,2,3,4,5))