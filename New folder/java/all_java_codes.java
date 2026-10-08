// Online Java Compiler
// Use this editor to write, compile and run your Java code online
import java.util.*;

class all_java_codes {
    public static void main(String[] args) {
        System.out.println("Try programiz.pro");
        String longets="abdcdaefgh";
        all_java_codes a1=new all_java_codes();
        // a1.longest_substring_length(longest);
        // a1.longest_palidrome_in_string("ivakatakavi");
        
        // a1.reverse_ecah_string("where is the empty");
        // a1.swap_only_even_index_of_string("yashwanth is auudyuw bad boy");
        
        // a1.insertion_sort();
         int arr[]={2,3,8,5,6,7,8};
         a1.quick_sort(arr, 0, arr.length-1);
         for(int num : arr)
            System.out.print(num + " ");
        
    }
        
        
        public void longest_substring_length(String longest){
        
        HashSet<Character> set=new HashSet<>();
        int left=0; int right=0;
        int max=0;
        int start=0;
        while(right<longest.length()){
            if(!set.contains(longest.charAt(right))){
                set.add(longest.charAt(right));
               
               if(right-left+1>max){
                   max=right-left+1;
                   start=left;
               }
                right++;
                
            }
            else{
                set.remove(longest.charAt(left));
                left++;
                
            }
        }
        System.out.println("the max length of substring is "+ max);
        System.out.println("the max length substring "+ longest.substring(start, start+max));
    }
    
    
    public void longest_palidrome_in_string(String str){
        int left=0;
        int right=0;
        List list=new LinkedList();
        int max=0;
        for(int i=0;i<str.length();i++){
            max=expand(str, i, i, list, max);
            max=expand(str, i, i+1, list, max);
            
            
        }
         System.out.println("the each list---> "+max);
        
        for(int i=0;i<list.size();i++){
            System.out.println("the each list---> "+list.get(i));
        }
    }
        
        public int expand(String start, int left, int right,List list, int max){
            String empty="";
            while(left>=0 && right<start.length() && start.charAt(left)==start.charAt(right)){
                max=Math.max(max, right-left+1);
                empty=start.substring(left, right+1);
                if(empty.length()>1)
                     list.add(empty);
                right++;
                left--;
                
            }
            return max;
        }
        
        
        
        
        public String swap_centervalue(String values){
            int center=values.length()/2;
            int left=(center-1)/2;
            int right=center;
            char[] arr = values.toCharArray();

            while(left>=0 && right<arr.length){
                char temp=arr[right];
                arr[right]=arr[left];
                arr[left]=temp;
                left--;
                right++;
            }
            // converting arry to string
            return   new String(arr);
            
        }
        
    public void reverse_ecah_string(String str){
        String [] str_list_values=str.split(" ");
        String ecah_string="";
        for(String str1: str_list_values){
            ecah_string=ecah_string+" "+swap_centervalue(str1);
        }
        System.out.println(ecah_string);
        
        
    }
    public String swap(String values){
           char[] arr = values.toCharArray();
           int left=0;int right=values.length()-1;
           while(left<right){
               char temp=arr[left];
               arr[left]=arr[right];
               arr[right]=temp;
               left++;
               right--;
           }
           return new String(arr);
        
    }
    
    
        public void swap_only_even_index_of_string(String str){
            // ex: [ strng is value ] . o/p[ gnrts is eulav ]
            String [] str_list_values=str.split(" ");
            String ecah_string="";
            String afer_swap [] =new String[str_list_values.length];
            for(int i = 0; i < str_list_values.length; i++){
                    String word = str_list_values[i];
                if(i%2==0){
                    word=swap(word);
                }
                afer_swap[i]=word;
                
                
        }
        System.out.println(String.join(" ",afer_swap) + " <----the swaped values is");
        }
        
        // public void replace_chacter_with_sepcial_chcater(String str){
        //      wheree is a ammma 
        //      // w##### is a## amma# 
        //     =str.split("")
            
        // }
        
        
// sorting algo

public void swap_number( int start, int end){
   int temp=start;
   start=end;
   end=temp;
   
    
}

public void selection_sort(){
    // highst will last
    int arr[]={2,4,5,6,1,4,3};
    for(int i=0;i<arr.length;i++){
        for(int j=i+1;j<arr.length;j++){
            if(arr[i]<arr[j]){
                 int temp=arr[j];
                   arr[j]=arr[i];
                   arr[i]=temp;
   
                
            }
        }
        
    }
    for(int i=0;i<arr.length;i++){
    System.out.println(arr[i]);
}
}


public void buble_sort(){
    // highst will last
    int arr[]={2,3,4,5,6,7,8};
    for(int i=0;i<arr.length;i++){
        boolean condition=false;
        for(int j=0;j<arr.length-i-1;j++){
            if(arr[j]>arr[j+1]){
                 int temp=arr[j];
                   arr[j]=arr[j+1];
                   arr[j+1]=temp;
                   condition=true;
            }
            
            }
            if(!condition){
                System.out.println("deafult orted");
                break;
        }
        
    }
    for(int i=0;i<arr.length;i++){
    System.out.println(arr[i]);
}

// 
        
    
    
}


public void insertion_sort(){
// any value found small make pervious smaller smaller
int arr[]={2,3,8,5,6,7,8};
    for(int i=1;i<=arr.length-1;i++){
        int curr=i;
        int prev=i-1;
        while(prev>=0 && arr[prev]>arr[curr]){
                int temp=arr[curr];
                   arr[curr]=arr[prev];
                   arr[prev]=temp;
                 prev--;
                 curr--;
        }

}
 for(int i=0;i<arr.length;i++){
    System.out.println(arr[i]);
 }
}


// ---------------------------------------------------------------------------------

public void merge_sort(int arr[], int left, int right){
    if(left<right){
        int mid = (left + right) / 2;
        merge_sort(arr, left, mid);
        merge_sort(arr, mid+1, right);
        merge(arr, left, mid, right);
        
    }

    
    
}

public void merge(int arr[], int low, int mid, int high){

    int right=mid+1;
    int n=high-low+1;
    int arr1[]=new int[n];
    int left=low;
    int i=0;
    while(left<=mid && right<=high){
        if(arr[left]>arr[right]){
                   arr1[i]=arr[right];
                   right++;
                   i++;
            
        }
        else{
            arr1[i]=arr[left];
            i++;
            left++;
        }
    }
    while(left<=mid){
        arr1[i++]=arr[left++];
    }
    while(right<=high){
        arr1[i++]=arr[right++];
    }
    
    // copy to oringnal
    for(int j=0;j<n;j++){
          arr[low+j] = arr1[j];
    }
    
}

// ------------------------------------------------------------------------------

public void quick_swap(int arr[], int left, int right){
    
                    int temp=arr[right];
                   arr[right]=arr[left];
                   arr[left]=temp;
    }
    

public int find_pivot_swap(int arr[], int low, int high){
    int i=low;
    int j=high;
       int pivot=arr[i];
    while(i<j){
     
        // right higher
        while(i<=high&& pivot>=arr[i] ){
            i++;
            
        }
         while(j>=0 && pivot<arr[j]){
            j--;
            
        }
        if(i<j){
            quick_swap(arr, i,j);
        }
        
        
        
    }
    // once the i and j get over lap means get the crt position
    quick_swap(arr, low, j);
    return j;
}
public void quick_sort(int arr[], int low, int high){
    // this qalgo find pivot check right more value left less value than pivot and swap and place crt position of po=ivote
    if(low<high){
       int pivot= find_pivot_swap(arr, low,high);
       quick_sort(arr, low, pivot-1);
       quick_sort(arr, pivot+1, high);
    }

    // ------------------------------------------------
    // swap the number with give d times
    
    
}





}


// subbarry sum and subarry max length etc all logic is same and max value is repeting 
import java.util.*;

class Main {
    public static void main(String[] args) {

        int arr[] = {-1,2,3,4,-5,6,7,8,-9,-5,-7};
// if the values k is given then  add -k find in the map
        int start = 0;
        int end = 0;
        int sum = 0;
        int tempStart = 0;   // IMPORTANT
        int max = Integer.MIN_VALUE;

        for (int i = 0; i < arr.length; i++) {

            sum += arr[i];

            if (sum > max) {
                max = sum;
                start = tempStart;
                end = i;
            }

            if (sum < 0) {
                sum = 0;
                tempStart = i + 1;  // RESET START HERE ✅
            }
        }

        System.out.println("Max sum = " + max);
        System.out.println("Start = " + start + " End = " + end);
    }
}



// Online Java Compiler
// Use this editor to write, compile and run your Java code online

class Main2 {
    public static void main(String[] args) {
        Main2 a1=new Main2();
        a1.longest_subseqitive_length_approch_optimal();
    }
    
    public void subsequence_ofhree(){
        int arr[]= {2, 1 , 7, 8, 6};
       
        String str="";
        int n=arr.length;
        for(int i=0;i<n-2;i++){
            for(int j=i+1;j<n-1;j++){
                if(arr[i]<arr[j]){
                         for(int k=j+1;k<n;k++){
                             if(arr[j]<arr[k]){
                                 str=arr[i] +" "+arr[j]+ " "+arr[k];
                             }
                         }
            }
            
        }
         System.out.println(str);
       
        
    }
    }
    
    
    public void longest_subseqitive_length(){
        int arr[]={101,5,103, 100,7,4,6,3,102};
        int n=arr.length;
       
        int max=0;
         for (int i = 0; i < n; i++) {
            int count = 1; // each element is a subsequence of length 1
            int last = arr[i]; // track the last element in the subsequence

            for (int j = i + 1; j < n; j++) { // only look right
                if (arr[j] > last) {
                    count++;
                    last = arr[j]; // update last element
                }
            }

            max = Math.max(max, count);
        }

        
        System.out.println("the max values is "+ max);
    }
    public void longest_subseqitive_length_approch_two_sort(){
            int arr[]={101,5,103, 100,7,4,6,3,102};
        int n=arr.length;
       int low=Integer.MIN_VALUE;
        int max=0;
        int count=0;
        Arrays.sort(arr);
         for (int i = 0; i < n; i++) {
             if(arr[i]-1==low){
                 count++;
                 low=arr[i];
                 
                
             }
             else{
                 count=1;
                 low=arr[i];
             }
            max=Math.max(max, count);
    }
    System.out.println(max);
    

}
 public void longest_subseqitive_length_approch_optimal(){
      int arr[]={101,5,103, 100,7,4,6,3,102};
        int max=0;
       
        Set<Integer> set=new HashSet<>();
        for(int i=0;i<arr.length;i++){
            set.add(arr[i]);
        }
        for(int i=0;i<arr.length;i++){
             int count=0;
             
            if(set.contains(arr[i])){
                int values=arr[i];
               while(set.contains(values)){
                   values++;
                   count++;
               }
            }
            max=Math.max(count, max);
        }
            System.out.println(max);
 
 }
}




//  find the longest substring without repeating character and also print the substring approch 1 approch 2 use the set approch 3 map
import java.util.*;

class Main {
    public static void main(String[] args) {
     String arr="abcabcbb";
     int max=0;
     List<String> list=new ArrayList();
     for(int i=0;i<arr.length();i++){
         int hash[]=new int[256];
         Arrays.fill(hash, 0);
         int j;
         for(j=i;j<arr.length();j++){
             if(hash[arr.charAt(j)-0]==1){
                break;
             }
             hash[arr.charAt(j)-0]=1;
         }
         list.add(arr.substring(i, j));
         max=Math.max(max, j-i);
     }
     System.out.println("the max length is --->"+ max);
     System.out.println("the max length is --->"+ list);
    }
}
// apprioch 3 number longest substring which has 1s

class Solution {
    public int lengthOfLongestSubstring(String s) {
        int left=0;
        Map<Character, Integer> map=new HashMap();
        int max=0;
        for(int right=0;right<s.length();right++){
            if(map.containsKey(s.charAt(right))){
                left=Math.max(left,map.get(s.charAt(right))+1);

            }
            map.put(s.charAt(right), right);
            max=Math.max(max, right-left+1);
        }
        return max;
    }

}
