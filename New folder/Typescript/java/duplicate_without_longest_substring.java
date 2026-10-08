import java.util.HashMap;

class duplicates{
    public static void m1(){
        String str="abcdeab";
        HashMap<Character, Integer> map=new HashMap<>();
        int max=Integer.MIN_VALUE;
        int left=0;
        int i;
        for(i=0;i<str.length();i++){
            if(map.containsKey(str.charAt(i))){
                left=map.get(str.charAt(i))+1;
        }
        map.put(str.charAt(i), i);
        max=Math.max(max, i-left+1);



    }
    System.out.println("the max lvalues of the substring is----> "+ str.substring(left, i) );
}
}