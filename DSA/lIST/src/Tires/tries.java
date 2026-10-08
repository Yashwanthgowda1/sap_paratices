package Tires;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

public class tries {
	  static node root = new node();
	static class node{
		node [] childern;
		boolean end;
		node(){
			this.childern=new node[26];
			Arrays.fill(childern, null);
			this.end=false;
		}
	}
	

//	tries is used for word serach in give list or what are the poosbile value can be ade in the given string and
//	length of the all value presnet string prefix
	
	


	public static void main(String[] args) {
		
		
		 String[] words = {
				 "a", "ap", "app", "appl","applt", "appls"
				 
		 };
		 for(String ecah_string: words) {
			 insert(ecah_string);
		 }
		 boolean cond=search("mouse");
		 System.out.println(cond);
//		 
	 boolean val=serach_all_posible_value_break("monitormoneypot");
		 System.out.println("the give things is presnmet in the array "+ val);
		 
		 
		find_unique_substrings_count("abab");
		 
		 node root1=root;
		 StringBuilder str=new StringBuilder();
		 giev_string_max_length_prifex(root1,  str);
		 System.out.println("the max length of string --> "+ update);
		 
		
		
	}
	public static void find_unique_substrings_count(String str) {
		node root1=root;
	    for (int i = 0; i < str.length(); i++) {
	        insert(str.substring(i));
	    }
		List<String> list=new LinkedList<>();
	int count=check_all_posible(root1,list, "" );
	
		System.out.println("the list values is "+ list);
		System.out.println("the number of the elemnts is "+ count);
		
	}
//	public static int count_numbers(node root1) {
//		if(root1==null) {
//			return 0;
//		}
//		int count=0;
//		for(int i=0;i<26;i++) {
//			if(root1.childern[i]!=null) {
//				char ch=(char)(i+'a');
//				count+=count_numbers(root1.childern[i]);
//			}
//		
//		
//	}
//	}
	public static int check_all_posible(node root1,List<String> list , String empty) {
		if(root1==null) {
			return 0;
		}
		int count=0;
		if(empty.length()>0) {
			list.add(empty);
			count=1;
		}
	
		for(int i=0;i<26;i++) {
			if(root1.childern[i]!=null) {
				char ch=(char)(i+'a');
				
				
			count+= check_all_posible(root1.childern[i], list, empty+ch);
				
			}
	
			
		}
		return count;
		
		
	}
	private static boolean serach_all_posible_value_break(String string) {
		if(string.length()==0) {
			return true;
		}
		
		for(int j=1;j<=string.length();j++) {
			String first_part=string.substring(0, j);
			String second_part=string.substring(j);
			
			if(search(first_part) && serach_all_posible_value_break(second_part)) {
				return true;
			}
		}
		return false;
		
		
	}
	
	public static void insert(String words) {
		node root1=root;
		for( int k=0;k<words.length();k++) {
			int index=words.charAt(k)-'a';
				if(root1.childern[index]==null) {
					root1.childern[index]=new node();
					
				}
				if(k==words.length()-1) {
				root1.childern[index].end=true;	
				}
			
			
				root1=root1.childern[index];
				
			}
		}
	
	
	
	
	
	
	public static  boolean search(String words) {
		node root1=root;
		if(words.length()==0) {
			return false;
		}
		
		for( int k=0;k<words.length();k++) {
			int index=words.charAt(k)-'a';
			
				if(root1.childern[index]==null) {
					return false;
					
				}
				if(k==words.length()-1 && root1.childern[index].end==false) {
					return false;
				}
			
				root1=root1.childern[index];
			}
			
		
		return true;
		
	}
	static String update="";
	public static void giev_string_max_length_prifex(node root, StringBuilder temp) {
		 if (root == null) {
		        return;
		 }
		 for (int i = 0; i < 26; i++) {

		        if (root.childern[i] != null && root.childern[i].end == true) {

		            char ch = (char) (i + 'a');

		            temp.append(ch);

		            if (update.length() < temp.length()) {
		                update = temp.toString();
		            }

		            giev_string_max_length_prifex(root.childern[i], temp);

		            // backtrack only after append
		            temp.deleteCharAt(temp.length() - 1);
		        }
		}
		
		
		
	}
}
	
	

	
	

