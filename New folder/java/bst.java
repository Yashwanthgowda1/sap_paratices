

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;



public class bst {

	static class node{
		int data;
		node left;
		node right;
		node(int data){
			this.data=data;
			this.left=null;
			this.right=null;
		}
	}
	static int i=-1;
	public static node creation(int arr, node root) {
	
		if(root==null) {
			root=new node(arr);
			return root;
		}
		if(arr>root.data) {
			root.right=creation(arr, root.right);
			
		}
		else {
			root.left=creation(arr, root.left);
			
		}
		return root;
	}
	public static void perorder(node root) {
		if(root==null) {
			return;
		}
		System.out.println(root.data+ "--->");
		perorder(root.left);
		perorder(root.right);
		
	}
	public static void inorder_to_check_arrgengedor_not(node root) {
		if(root==null) {
			return;
		}
		
		inorder_to_check_arrgengedor_not(root.left);
		System.out.println(root.data+ "--->");
		inorder_to_check_arrgengedor_not(root.right);
		
	}
	
	public static void serach_tree() {
//		as per my condition sercah the tree and return the level so i can use the q also or level order
	
		
		
		
		
	}
	
	
	public static boolean serach(node root, int target) {
		if(root==null) {
			System.out.println("not enter root null cond");
			return false;
		}
		if(root.data==target) {
			return true;
			
		}
		boolean ans=false;
		if(root.data>=target) {
			System.out.println("the catch the value start" + ans);
		ans=serach(root.left, target);
		System.out.println("the catch the value start after serach" + ans);
		}
		else {
			System.out.println("the catch the value start  serach right rossing" + ans);
			ans=serach(root.right, target);
			System.out.println("the catch the value start  serach afetr right rossing" + ans);
		}
		
		
		return ans;
		
	}
	
	
	public static void main(String[] args) {
		int arr[]= {40,20,60,10,30,80,25};
		node root=null;
	for (int each : arr) {
		root=creation(each, root);
	}
//		perorder(root);
	// inorder_to_check_arrgengedor_not(root);
	boolean cond=serach(root, 12);
	System.out.println("the value which we are found is -->"+ cond);
	}
}
