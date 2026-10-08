function number_find_max_repted(...number:(String| number )[]): {
    map: Map<number, number> , numbermax:number
}
{
        let max_value=Number.MIN_SAFE_INTEGER;
    let map=new Map<number, number>();
    number.forEach((ecah_values, index)=>{
if(typeof ecah_values==="number"){
    map.set(ecah_values, (map.get(ecah_values) || 0)+1);
    if(max_value< ecah_values){
            max_value=ecah_values;
    }
}
    })

return {
    map: map, 
    numbermax: max_value



    }


}

function number_charcter_max_repted(...values: (string | number)[]) {

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


let callbackarrow=(number_find_max_repted:(...number:(string| number)[])=> {map: Map<number, number>, numbermax: number }
, number_charcter_max_repted:(...stringvalues:(string| number)[])=> {map1: Map<string, number> , numbermax_values:number}, ...numberseacharry:(number | string )[])=>{
let returnnumber=number_find_max_repted(...numberseacharry)
let returnstring=number_charcter_max_repted(...numberseacharry)
console.log(`the maxnumber is the ${returnnumber.numbermax}`)
console.log(`the maxnumber is the ${returnstring.numbermax_values}`)

}

const arr1 = [10,23456,3,4,45,555,"yash","java"];

callbackarrow(
  number_find_max_repted,
  number_charcter_max_repted,
  ...arr1
);