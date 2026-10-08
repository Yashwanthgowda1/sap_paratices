package BST;

import BST.Creation_dealtion_serach.node;

public class largest_bst extends Creation_dealtion_serach {
	static  class info{
		int mincurr;
		int maxcurr;
		int maxsize;
		boolean isBst;
		info(int mincurr, int maxcurr, int maxsize, boolean flag){
			this.maxcurr=maxcurr;
			this.mincurr=mincurr;
			this.maxsize=maxsize;
			this.isBst=flag;
		}
	}
	static int maxbst=0;
	public static info largest_bst(node root) {
		if(root==null) {
			return new info(Integer.MAX_VALUE, Integer.MIN_VALUE, 0, true);
		}
//		get the some information from the right and left
		info left=largest_bst(root.left);
		info right=largest_bst(root.right);
		int size=left.maxsize+right.maxsize+1;
		int min=Math.min(root.data, Math.min(left.mincurr, right.mincurr));
		int max=Math.max(root.data, Math.max(left.maxcurr, right.maxcurr));
		
		
		if(left.isBst && right.isBst && root.data>left.maxcurr && root.data<right.mincurr) {
			maxbst= Math.max(maxbst, size);
			return new info(min, max, size, true);
		}
		
		  return new info(min, max, Math.max(left.maxsize, right.maxsize), false);
			
		}
		
		
	
		
	
	
	
	
	public static void main(String[] args) {
		int arr[]= {40,20,60,10,30,80,25};
		node root=null;
	for (int each : arr) {

		root=creation(each, root);
	}
	largest_bst(root);
	System.out.println("the max --->"+ maxbst);

}
	
	
	
//	    5ac0186564msh9af0c801ddeed4bp17b856jsndff342eb866a
	
	
//Grroq   gsk_REDACTED_ROTATE_THIS_KEY	
}
