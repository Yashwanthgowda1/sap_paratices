package My_sdet_practice;

import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import Linked_list.refrence;

public class duplicatewithoutsubstring {

	public static void main(String[] args) {
		String str = "abcd";
//        dupliactes_without(str);
//        	substrings(str, 0, "");
//		minium_length_substring();
		
		merge();
	}

	public static void dupliactes_without(String str) {
		HashMap<Character, Integer> map = new HashMap<>();
		int max = Integer.MIN_VALUE;
		int left = 0;
		int i;
		for (i = 0; i < str.length(); i++) {
			if (map.containsKey(str.charAt(i))) {
				left = Math.max(left, map.get(str.charAt(i)) + 1);
			}
			map.put(str.charAt(i), i);
			max = Math.max(max, i - left + 1);

		}
		System.out.println("the max is----> " + max);
		System.out.println("the max lvalues of the substring is----> " + str.substring(left, i));
	}

//	max substring can form
	public static void substrings(String str, int start, String combiation) {

		if (start == str.length()) {
			System.out.println("the posinle substring is ----> " + combiation);

			return;
		}
		substrings(str, start + 1, combiation + str.charAt(start));
//		not include start move next
		substrings(str, start + 1, combiation);

	}

//	minium length of the substring conatin all the chanracter
	public static void minium_length_substring() {
		String str = "abcdeabcdaba";
		String arr = "aabc";
		Map<Character, Integer> map_exist = new HashMap<>();
		Map<Character, Integer> map_created = new HashMap<>();

		for (char ch : arr.toCharArray()) {
			map_exist.put(ch, map_exist.getOrDefault(ch, 0) + 1);

		}
		int min_length = Integer.MAX_VALUE;
		int start = 0;
		int left = 0;
		for (int i = 0; i < str.length(); i++) {
			map_created.put(str.charAt(i), map_created.getOrDefault(str.charAt(i), 0) + 1);

			while (compare_eist_all_values(map_exist, map_created)) {
				if (i - left + 1 < min_length) {
					min_length = i - left + 1;
					start = left;
				}

				map_created.put(str.charAt(left), map_created.get(str.charAt(left)) - 1);

				left++;

			}
		}
		System.out.println(str.substring(start, min_length + start));

	}

	public static boolean compare_eist_all_values(Map<Character, Integer> map1, Map<Character, Integer> map2) {
		for (int i = 0; i < 26; i++) {
			char ch = (char) ('a' + i);

			if (map1.getOrDefault(ch, 0) > map2.getOrDefault(ch, 0)) {

				return false;
			}
		}

		return true;

	}
/**
 * 
 * all the posibleity two wyas questions
 */
//	all posible combination chracter
	public static void all_posible_combination() {

		String[] arr = { "abc", "123", "@#$" };
		List<String> list = new LinkedList();
		solve(arr, 0, "", list);
		System.out.println(list);
	}

	static void solve(String[] arr, int index, String current, List<String> list) {
		if (index == arr.length) {
			list.add(current);
			return;
		}
		for (int i = 0; i < arr[index].length(); i++) {
			solve(arr, index + 1, current + arr[index].charAt(i), list);
		}

	}

//	anaother wya question
	public static void anotherway_posible_string(String[] args) {
		String arr[] = { "a", "b", "c" };
		String arr2[] = { "1", "2", "3" };
		String arr3[] = { "@", "#", "$" };
		// output all the combination
		// a1@, aq#, a1$, a2@
		List<String> list = new LinkedList();
		recuersion_posbility(arr, arr2, arr3, 0, "", list);
		System.out.println(list);
	}

	public static void recuersion_posbility(String[] arr, String arr1[], String arr2[], int index, String current,
			List<String> list) {
		if (index == 3) {
			list.add(current);
			return;
		}

		if (index == 0) {
			for (int i = 0; i < arr.length; i++) {
				recuersion_posbility(arr, arr1, arr2, index + 1, current + arr[i], list);
			}
		} else if (index == 1) {
			for (int i = 0; i < arr1.length; i++) {
				recuersion_posbility(arr, arr1, arr2, index + 1, current + arr1[i], list);
			}
		} else {
			for (int i = 0; i < arr2.length; i++) {
				recuersion_posbility(arr, arr1, arr2, index + 1, current + arr2[i], list);
			}
		}

	}
	
	
	/***
	 * merge the intervals
	 */

	 public static void merge() {
	       int arr[][]={{1,3},{2,6},{8,10},{6,10},{15,18}};
	       Arrays.sort(arr, new Comparator<int []>(){
	           @Override
	           public int compare(int [] a, int b[]){
	            return a[0]-b[0];               
	           }
	       });
	    //   Array.tostring() convert object to string but deeptostring smae purpose for 2d arry
	       System.out.println("aftre the sorting value is "+ Arrays.deepToString(arr));
	       
	       List<int[]> list=new LinkedList();
	       for(int arr1[]: arr){
	           int first=arr1[0];
	           int sec=arr1[1];
	          if(!list.isEmpty() && list.get(list.size()-1)[1]>= first){
	                list.get(list.size()-1)[1]=Math.max( list.get(list.size()-1)[1], sec);
	           }
	           else{
	               list.add(arr1);
	           }
	       }
	       for (int arr2[]: list){
	           System.out.println(Arrays.toString(arr2));
	       }
	       
	       
	 }

}
