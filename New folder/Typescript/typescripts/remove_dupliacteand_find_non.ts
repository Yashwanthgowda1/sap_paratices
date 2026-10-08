let array:(string |number)[]=[1,2,3,4,5,1,2,3,6,7,8,9,4,4,5,6,5,6,56]
// find the number without duplactes
let empty_arry:number[]=[]
array.forEach((el, index)=>{
    let dupliacte=false
    array.forEach((element , indexs)=> {
        if(index > indexs  && el === element){
            dupliacte=true
           
        }
        
    });
if (!dupliacte && typeof(el)==='number'){
empty_arry.push(el)
}
})
console.log(empty_arry)


// map function
const maps:Map<string, {string_values:Map<string ,string[]> , value:number}>=new Map()
console.log(typeof maps)
let list_value=["gandu","pandu","madhu","shandu","amma", "apppa", "ddaya", "ammu", "anna"]
list_value.forEach(el=>{
    if (typeof(el) === "string"){
        if(maps.has(el.charAt(0))){
            const existing = maps.get(el.charAt(0));
                if(existing){
                     if (existing.string_values.has(el.charAt(1))) {

                                    const secondValues =
                                        existing.string_values.get(el.charAt(1));
                                    if (secondValues){
                                        secondValues.push(el);

                                    existing.value=secondValues.length
                                    }
                                    }
                    else{
                       
                        existing.string_values.set(el.charAt(1), [el] )
                        existing.value++
                    }
        }
    }
        else{
        maps.set(el.charAt(0), {string_values: new Map([[el.charAt(1), [el]]]), value: 1})
        // indicate the first arry list is empty or need to declarte that empty list then we can push but in this problem there is not 
        // existing list nnneed to create new list adding the value
    }
}
})
console.dir(maps,{ depth: null })