package binary_tree;

import java.util.Deque;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Queue;

public class creation {
	 static class node{
		int data;
		node left, right;
		
		node(int data){
			this.data=data;
			this.left=null;
			this.right=null;
		
		}
	}
	static int index=-1;
	public static node insertion(int arr[]) {
		index++;
		if(index >= arr.length || arr[index]==-1) {
		return null;
		}
		 node newnode = new node(arr[index]);
		newnode.left=insertion(arr);
		newnode.right=insertion(arr);
		return newnode;
	}

	public static void preorder(node root){
		// root left right  assidending porder
		
		if(root==null){
			return;
		}
		System.out.print(root.data+" --> ");
		preorder(root.left);
		preorder(root.right);
	}
	public static void inorder(node root){
		if(root==null){
			return;
		}
		// left root right
		inorder(root.left);
		System.out.print(root.data+" --> ");
		inorder(root.right);


	}
	public static void postorder(node root){
		if(root==null){
			return ;
		}
		// left right root
		postorder(root.left);
		postorder(root.right);
		System.out.print(root.data+" --> ");
		
	}

	public static int hieght(node root){
		// l left right return root 
		if(root==null){
			return 0;
		}
		int left=hieght(root.left);
		int right=hieght(root.right);
		int max=Math.max(left, right) +1;
		return max;





		
	}
	static int diameter = 0;
   public static int diameter(node root) {
        if (root == null) return 0;

        int left = diameter(root.left);
        int right = diameter(root.right);

        // update diameter
        diameter = Math.max(diameter, left + right);

        return 1 + Math.max(left, right);
    }

   
   public static void binary_tree_path(node root, String path) {
	  
	   if(root.left==null  && root.right==null) {
		   System.out.println("the actual  path --> "+ path);
		   return;
		   
	   }
	   if(root.left!=null) {
		   binary_tree_path(root.left, path+"-->"+root.left.data);
	   }
	   if(root.right!=null) {
		   binary_tree_path(root.right, path+"-->"+root.right.data);
	   }
	   
	   
   }
   
   
	public static int level_order_traversal(node root){
		Deque<node> q=new LinkedList<>();
		// when there is addd and deleted 
if(root==null){
	return 0;
}
		q.add(root);
		q.add(null);
		int count=0;
		while (!q.isEmpty() ) {
			node curr=q.removeFirst();
	if(curr==null){
				count++;
				System.out.println(" ");
			
			if(!q.isEmpty()){
				q.addLast(null);
			}
			else{
				break;
			}
		}
else{
			if(curr.left!=null){
					q.addLast(curr.left);
			}
			if(curr.right!=null){
				q.addLast(curr.right);
			}
			System.out.print(curr.data + " ");

		}
		}
		return count;
			
		};
		
	public static int max_path_sum(node root, int path, int max) {
		if(root==null) {
			return -1;
		}
		 
		   if(root.left==null  && root.right==null) {
			 max=Math.max(path, max);
			 return max;
			   
		   }
		   if(root.left!=null) {
			   max=max_path_sum(root.left, path+ root.left.data, max);
		   }
		   if(root.right!=null) {
			   max=max_path_sum(root.right, path+root.right.data, max);
		   }
		   return max;
	}

public boolean both_same_tree(node root1, node root2) {
	
	if(root1==null && root2==null) {
		return true;
	}
	
	
	
	 
	 if(root1==null || root2==null) {
			return false;
		}
	 if (root1.data != root2.data) {
	        return false;
	    }
	 
	boolean left=both_same_tree(root1.left, root2.left);
	boolean right=both_same_tree(root1.right, root2.right);
	if(left==false || right==false) {
		return false;
	}
	return true;
	
}


//top view of the binary tree
static class info{
	node node;
	int top_hr;
	public info(node node, int hd) {
		// TODO Auto-generated constructor stub
		this.node=node;
		this.top_hr=hd;
	}
}

public static void top_view(node root) {
	Queue<info> q=new LinkedList<>();
	Map<Integer, node> map=new HashMap<>();
	
	q.add(new info(root, 0));
int min=0;
int max=0;
	while(!q.isEmpty()) {
		info curr=q.remove();
		if(!map.containsKey(curr.top_hr)) {
			map.put(curr.top_hr, curr.node);
		
			
		}
		if(curr.node.left!=null) {
			q.add(new info(curr.node.left,curr.top_hr-1 ));
			min =Math.min(min, curr.top_hr-1);
			
		}
		if(curr.node.right!=null) {
			q.add(new info(curr.node.right,curr.top_hr+1 ));
			max =Math.max(max, curr.top_hr+1);
		}
		
	}
	for(int start=min; start<=max; start++) {
		System.out.print(map.get(start).data + "  ------ ");
		
	}
	
	
}

public static  void bootomview(node root) {
	Queue<info> q=new LinkedList<>();
	Map<Integer, node> map=new HashMap<>();
	
	q.add(new info(root, 0));
	int min=0;
	int max=0;
	while(!q.isEmpty()) {
		info curr=q.remove();
		
			map.put(curr.top_hr, curr.node);
		
			
		if(curr.node.left!=null) {
			q.add(new info(curr.node.left,curr.top_hr-1 ));
			min =Math.min(min, curr.top_hr-1);
			
		}
		if(curr.node.right!=null) {
			q.add(new info(curr.node.right,curr.top_hr+1 ));
			max =Math.max(max, curr.top_hr+1);
		}
		
	}
	for(int start=min; start<=max; start++) {
		System.out.print(map.get(start).data + "  ------ ");
		
	}
	
}

public static void left_view(node root) {
	if (root == null) return;

    Queue<node> q = new LinkedList<>();
    q.add(root);
    q.add(null);

    boolean first = true;

    while (!q.isEmpty()) {

        node curr = q.remove();

        if (curr == null) {
            if (!q.isEmpty()) {
                q.add(null);
                first = true; // next level starts
            }
        } else {

            if (first) {
                System.out.print(curr.data + " ");
                first = false;
            }

            if (curr.left != null) q.add(curr.left);
            if (curr.right != null) q.add(curr.right);
        }
    }
		
	}
	


public static void right_view(node root) {
	if (root == null) return;

    Queue<node> q = new LinkedList<>();
    q.add(root);
    q.add(null);

    boolean first = true;

    while (!q.isEmpty()) {

        node curr = q.remove();

        if (curr == null) {
            if (!q.isEmpty()) {
                q.add(null);
                first = true; // next level starts
            }
        } else {

            if (first) {
                System.out.print(curr.data + " ");
                first = false;
            }

           
            if (curr.right != null) q.add(curr.right);
            if (curr.left != null) q.add(curr.left);
        }
    }
		
	}
	
/***
 * root_of_the_leaf_path
 * @param args
 */

public static void root_leaf_path(node root, String path) {
	if(root==null) {
		return;
	}
	if(root.left==null && root.right==null) {
		System.out.println("the end of the leaf path -->"+ path);
		return;
	}
	if(root.left!=null) {
	root_leaf_path(root.left, path+ root.data + "--->");
	}
	
	if(root.right!=null) {
		root_leaf_path(root.right, path+ root.data + "--->");
		}
		
	
	}
	/***
	 * here itbwill make the rree as balanced 
	 * @param args
	 */


    public static  void isSumProperty(node root) {
        //  code here
        if(root==null){
            return ;
        }
        int child=0;
       if(root.left!=null){
           child+=root.left.data;
       }
       if(root.right!=null){
           child+=root.right.data;
       }
       if(child<root.data){
           if(root.left!=null){
               root.left.data=root.data;
           }
           if(root.right!=null){
               root.right.data=root.data;
           }
       }
       isSumProperty(root.left);
       isSumProperty(root.right);
       int parent_is_less=0;
      
           if(root.left!=null){
           parent_is_less+=root.left.data;
       }
       
        if (root.right != null) {
            parent_is_less += root.right.data;
        }
        
      if(root.left != null || root.right != null){
            root.data=parent_is_less;
      }
       
       
      
    }

        
        
	
	public static void main(String[] args) {
		int [] arr= {1,2,-1,3,4,5,-1,-1, 6,10,-1,-1,12,-1, 7,-1,-1,12,3,4};
		
		node root=insertion(arr);
		
		top_view(root);
		System.out.println();
		bootomview(root);
		System.out.println();
		left_view(root);
		System.out.println();
		right_view(root);
//		System.out.println(root.data);
//		preorder(root);
//		System.out.println();
//		inorder(root);
//		System.out.println();
//		postorder(root);
//		System.out.println("the max hieght of the teree");
//		int actul_hight=hieght(root);
//		System.out.println(actul_hight);
//	int max_hight=diameter(root);
//	System.out.println("the max dia is "+ diameter + " and the hight is "+ max_hight);
//	int number_of_level=level_order_traversal(root);
//	System.out.println("the number of level of the nodes are  ---> "+ number_of_level);
//	binary_tree_path(root, "");
//	int max=max_path_sum(root, 0, 0);
//	System.out.println("the maximum path sum each node is ----->"+ max);
		root_leaf_path(root, "");
	}
	
	

}
