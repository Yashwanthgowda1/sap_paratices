package BST;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;

import Linked_list.refrence;

public class Creation_dealtion_serach {

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
	static class custom_two_value_return{
		boolean flag;
		int level;
		public custom_two_value_return(boolean flag, int level) {
			// TODO Auto-generated constructor stub
			this.flag=flag;
			this.level=level;
		}
	}
	
	public static custom_two_value_return serach_tree(node root,int target, int level) {
//		as per my condition sercah the tree and return the level so i can use the q also or level order
		Queue<node> q=new LinkedList();
		q.add(root);
		if(root==null) {
			return new custom_two_value_return(false, -1);
		}
		while(!q.isEmpty()) {
			int size=q.size();
			for(int i=0;i<size;i++) {
				node curr=q.remove();

				if(curr.data==target) {
					return new custom_two_value_return(true, level);
				}
				if(curr.data>=target && curr.left!=null) {
					q.add(curr.left);
				}
				else if(target > curr.data && curr.right != null) {
					q.add(curr.right);
				}
				
				
			}
			level++;
			
			
			
			
		}
	
		
		return new custom_two_value_return(false, -1);
		
		
		
		
	}
	
	
	public static boolean serach(node root, int target) {
	
		if(root==null) {
			System.out.println("not enter root null cond");
			return false;
		}
		 System.out.println("Currently at: " + root.data);
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
	
	
	public static node insert_node(node root, int key) {
//		approch one 
		if(root==null) {
			return new node(key);
		}
		if(root.data>=key) {
			root.left=insert_node(root.left, key);
		}
		else if(root.data<key) {
			root.right=insert_node(root.right, key);
		}
		
		
		return root;
		
	}
	
	
//	range of sum value othe 3 appoch refer the leetcode
	public  static int rangeSumBST(node root, int low, int high) {
        if(root==null){
            return 0;
        }
     
       return ranage(root, low, high);
        
    }
    public static int ranage(node root, int low, int high) {
        if(root==null){
            return 0;
        }
               int sum=0;
     sum+=ranage(root.left, low, high);

        if(root.data>=low  && root.data<=high){
            sum+=root.data;
        }
         sum+=ranage(root.right, low, high);

         return sum;
}
   
    
   
  

	
	public static void main(String[] args) {
		int arr[]= {40,20,60,10,30,80,25};
		node root=null;
	for (int each : arr) {
		root=creation(each, root);
	}
//		perorder(root);
//	inorder_to_check_arrgengedor_not(root);
//	boolean cond=serach(root, 12);
//	System.out.println("the value which we are found is -->"+ cond);
	
	
//	custom_two_value_return values_two=serach_tree(root, 55, 0);
//	System.out.println("the sercah value "+ values_two.flag + " was presnet at the level "+ values_two.level);
	
	node root_after_insertion=insert_node(root, 5);
	System.out.println("after the insertion");
	inorder_to_check_arrgengedor_not(root_after_insertion);
	
	}
}
