package Linked_list;

import java.time.Period;

public class Double_linked_list {
	class node{
		
		node next;
		node prev;
		int data;
	
	node(int data){
		this.data=data;
		
		this.next=null;
		this.prev=null;
	}
	}
//	adding based on the head
	node head=null;
	public void add(int data) {
		node newnode=new node(data);
		if(head==null) {
			head=newnode;
			head.next=null;
			head.prev=null;
			return;
			
		}
		node temp=head;
		while(temp.next!=null) {
			temp=temp.next;
			
		}
		temp.next=newnode;
		newnode.prev=temp;
			
	}
	
	public void printall() {
		if(head==null) {
			System.out.println("the ddl is empty");
			return;
		}
		node curr= head;
		while(curr!=null) {
			System.out.print(curr.data+ " -->");
			curr=curr.next;
		}
		
	}
	
	public void addfisrt(int data) {
	node	newnode =new node(data);
		if(head==null) {
			head=newnode;
			head.next=null;
			head.prev=null;
			return;
		
	}
		newnode.next=head;
		head.prev=newnode;
		head=newnode;
		
	}
	public void addlast(int data) {
		node newnode=new node(data);
		if(head==null) {
			head=newnode;
			head.next=null;
			head.prev=null;
			return;
		
	}
		node temp=head;
		while(temp.next!=null) {
			temp=temp.next;
		}
		temp.next=newnode;
		newnode.prev=temp;
		temp=newnode;
	}
	
	public void removefirst() {
		if(head==null) {
			return;
		}
		
		  if(head.next == null){
		        head = null;
		        return;
		    }

		node newnode=head.next;
		newnode.prev=null;
		head=newnode;
		
	}
	
	public void removelast() {
		if(head==null) {
			return;
		}
		node curr=head;
		node prevs=head;
		while(curr.next!=null) {
			prevs=curr;
			curr=curr.next;
		}
		prevs.next=null;
		curr.prev=null;
	}
	
	public boolean isempty() {
		if(head==null) {
			return true;
		}
		return false;
	}
	
	
	public int size() {

	    node temp = head;
	    int size = 0;

	    while(temp != null){
	        size++;
	        temp = temp.next;
	    }

	    return size;
	}

	public void insert(int index, int val) {
		 node newnode = new node(val);

		if(index == 0){
			
		   
		    if(head == null){
		        head = newnode;
		        return;
		    }

		    newnode.next = head;
		    head.prev = newnode;
		    head = newnode;
		    return;
		}
	
//		go that index position fisrt
		   node curr = head;
		    int i = 0;

		    while(curr != null && i < index - 1){
		        curr = curr.next;
		        i++;
		    }
		    
		   if(curr==null) {
			   System.out.println("this last node and next node empty");
			   return;
		   }
		   
		   node newnode_toinsert = curr.next;   // store next node

		    curr.next = newnode;                 // connect prev -> newnode
		    newnode.prev = curr;

		    newnode.next = newnode_toinsert;     // connect newnode -> next node

		    if(newnode_toinsert != null){
		        newnode_toinsert.prev = newnode; // connect next node -> newnode
		    }
		}
	
	public node delete_value(int target) {
		
		if(head==null) {
			return null;
		}
		node curr=head;
		while(curr!=null  && curr.data==target) {
			head=curr.next;
			if(curr.next!=null) {
				curr.next.prev=null;
				
			}
			curr=curr.next;
			
		}
//		remaing portion to remove
		node dummy=new node(0);
		
		node prev=null;
		while(curr!=null) {
			if(curr.data==target) {
			prev.next=curr.next;
			if(curr.next!=null) {
			curr.next.prev=prev;
			}
			
			}
			else {
//				data not equlal
				prev=curr;
			}
			
			
			curr=curr.next;
		}
		return head;
	}
		    
		    
		    
		    
		    
		    
		    
	
	
	
	
	public static void main(String[] args) {
		Double_linked_list a1=new Double_linked_list();
		a1.add(1);
		a1.add(72);
		a1.add(78);
		a1.add(1);
		a1.add(90);
		a1.add(1);
		a1.add(90);
		
		a1.add(1);
		a1.add(1);
		a1.add(1);
	
;
		a1.delete_value(1);
		a1.printall();
		
//		System.out.println(a1.size());
		
	}
	
	

}
