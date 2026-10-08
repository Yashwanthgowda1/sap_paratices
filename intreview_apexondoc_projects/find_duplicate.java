import java.util.*;
class  find_duplicate
{
	public static void main(String[] args) 
	{
		int arr[]={1,2,3,4,52,3,4,7, 23,43,55,8,755};
		
		int sceond_value=0;
		int first_largest=arr[0];
		for(int i=1;i<arr.length;i++){
			if(arr[i]>first_largest){
				sceond_value=first_largest;
				first_largest=arr[i];
				
				
			}
			
			
		}
		System.out.println(sceond_value);
		
		
	}
}

