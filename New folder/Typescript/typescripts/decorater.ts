
function clerchaedevice(originalMethod: Function,
    context: ClassMethodDecoratorContext

){
    
    return function (this:any, ...browser:string[]){
        console.log("the calling andothe cutome functions")
        return originalMethod.apply(this, browser)
    
    
    };

}
class lanuchbrowser{
    @clerchaedevice
    slection_browser(string_type:string){
        if(string_type.includes("chrome")){
            console.log("alnuching the chrome")
        }
        else if(string_type.includes("firefox")){
            console.log("alnuching the firefox")
        }
    }
}
const tw=new lanuchbrowser()
tw.slection_browser("firefox")