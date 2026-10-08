// number time array get roated
class values {
    
int arr [] = {4,5,6,7,0,1,2};
int start=0;
int end=arr.length-1;
while(start<end){
    int mid=start+(end-start)/2;
    if(arr[mid]>arr[end]){
        left=mid+1;
    }
    else{
        right=mid;
    }
}
System.out.println(arr.length-left);




}