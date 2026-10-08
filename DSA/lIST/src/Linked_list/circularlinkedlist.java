package Linked_list;

public class circularlinkedlist {
	
//		tail and head tail is insert to head 
		class node{
			
			node next;
			int data;
			
			node(int data){
				this.data=data;
				
				this.next=null;
			}
			
		}
		node head=null;
		node tail=null;
		
	public void addfisrt(int data) {
		node newnode=new node(data);
		if(head==null) {
//			means fisrt node 
			head=newnode;
			tail=newnode;
			 tail.next = head;  
//			newnode.next=head;
			
			
		}
//		need toadd the fisrt alredy exist
		
		else {
			newnode.next=head;
			head=newnode;
			tail.next=newnode;
		}
			
		
		
		
	}
	public void printall() {
		if(head==null) {
			System.out.println("trh eempty node");
			return;
		}
	
		   node temp = head;
		   System.out.print(temp.data+ " ---> ");
		   temp=temp.next;
		   while(temp!=head) {
			   System.out.print(temp.data+ " ---> ");
			   temp=temp.next;
		   }

		   
		
	}
	
	public void addlast(int data) {
		node newnode=new node(data);
		if(head==null) {
//			means fisrt node 
			head=newnode;
			tail=newnode;
			 tail.next = head;  
		}
		
		
tail.next=newnode;
newnode.next=head;
tail = newnode;
		
	}
	
	
	public int size() {
		int size=0;
		if(head==null && tail==null) {
			return 0;
		}
		node temp=head;
		do {
			size++;
			temp=temp.next;
		}
		while(temp!=head);
		return size;
		
	}
	
	
	public void remove(int index) {
		if(index==0){

		    if(head==tail){
		        head=null;
		        tail=null;
		        return;
		    }

		    head=head.next;
		    tail.next=head;
		    return;
		}
		
		node temp=head;
		int i=0;
		 while(i < index-1){
		        temp = temp.next;
		        i++;
		    }

		    if(temp.next == tail){
		        tail = temp;
		    }

		    temp.next = temp.next.next;
		
		
	}
	
	public static void main(String[] args) {
		circularlinkedlist a1=new circularlinkedlist();
		a1.addfisrt(10);
		a1.addfisrt(30);
		a1.addfisrt(45);
		a1.addlast(90);
		a1.printall();
		System.out.println();
		a1.remove(0);
		a1.printall();
		
	}

}
