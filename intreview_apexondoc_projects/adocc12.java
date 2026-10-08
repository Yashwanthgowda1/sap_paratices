import java.util.*;
class adocc12
{
	public static void main(String[] args) 
	{
		String str="aabbaaccddeeff";
		Map<Character, Integer> map=new HashMap();
		for (int i=0;i<str.length(); i++ ){
			map.put(str.charAt(i), map.put(str.charAt(i),0)+1);
				
		
		}
		
		for(Map.Entry<Character, Integer>entry: map.entrySet()){
			System.out.println(entry.getKey() +" and the entry the value "+ entry.getValue());
			
	}
	}
}