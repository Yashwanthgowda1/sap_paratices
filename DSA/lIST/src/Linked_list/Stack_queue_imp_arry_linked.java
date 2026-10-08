package Linked_list;

public class Stack_queue_imp_arry_linked {

//	stack implemnetaion array
	static  class node{
	
	
		int lifo;
		int [] size;
		node(int size){
		
			this.size=new int[size];
			this.lifo=-1;
		}
		
		public void push(int data) {
			if(lifo==size.length-1) {
				System.out.println("the stack is full");
				return;
			}

			lifo++;
			size[lifo]=data;
			
		}
		public boolean isEmpty() {
			return lifo==-1;
			
		}
		public int pop() {
//			retyrn te last elemnt
			if(isEmpty()) {
				System.out.println("the stack is empty");
				return 0;
			}
			int top=size[lifo];
			
			lifo--;
			return top;
		}
		public int peek() {
			if(isEmpty()) {
				System.out.println("the stack is empty");
				return 0;
			}
			
			return size[lifo];
		}
	
	public void printall() {
		for(int i=0;i<=lifo;i++) {
			System.out.println(size[i]);
			
		}
	}
	}
	
	class node{
//		implemnt using teh the linked list
		int data;
		node next;
		node(int data){
			this.data=data;
			this.next=null;
		}		
		
	}
	
	node head=null;
		public  void push(int data) {
			node newnode=new node(data);
			if(head==null) {
				head=newnode;
				return;
			}
			newnode.next=head;
			head=newnode;
			
		}
		public boolean isempty() {
			if(head==null  ) {
			return true;
			}
			return false;
		}
		public int pop() {
			if(isempty()) {
				System.out.println("the stack is empty");
				return -1;
			}
			node top=head;
			head=head.next;
			
			
			return top.data;
			
			
		
	}
		public int peek() {
			if(isempty()) {
				return -1;
			}
			return  head.data;
		}
		
		public void printall() {
			node curr=head;
			while(curr!=null) {
				System.out.println(curr.data);
				curr=curr.next;
			}
		}
	
		
	public static void main(String[] args) {
		Stack_queue_imp_arry_linked  a1=new Stack_queue_imp_arry_linked();
		a1.push(10);
		a1.push(34);
		a1.push(89);
		a1.push(90);
		a1.push(999);
		a1.printall();
		System.out.println("the removed lement is " + a1.pop());
		
		a1.printall();
		
		
		
	}
		
		
		
	}
	
	

