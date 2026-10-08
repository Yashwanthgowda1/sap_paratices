console.log("Program Started");

class overidemethods {
    ther_m1(address: string) {
        console.log("parent method");
    }
}

class secondoverode extends overidemethods {
   
    override  ther_m1(message: string) {
        console.log("the override happened");
        console.log(message);
    }
}

let sec = new secondoverode();
sec.ther_m1("how are you");
