package Linked_list;



	
//	implent same as circukare ques if want
//	
//	static class arry{
//		int size[];
//		int front;
//		int rear;
//		int capacity;
//		public arry(int size) {
//			// TODO Auto-generated constructor stub
//			this.size=new int[size];
//			this.front=0;
//			this.rear=-1;
//			this.capacity=size;
//		}
//	
//	
//	public boolean isempty() {
//		return rear==-1;
//	}
//	public boolean isfull() {
//		return rear==size.length-1;
//	}
//	public void add(int data) {
//		
//		if(isfull()) {
//			System.out.println(" the stack over flow");
//			return;
//		}
//		else {
//	
////			implement in circulaer manner
//			rear=(rear+1)%capacity;
//			size[rear]=data;
//			
//		}
//	}
//	
//	
//	public int pop() {
//		if(isempty()) {
//			System.out.println("the lemnt not found");
//			return -1;
//		}
//		return size[front++];
//	}
//	public int peek() {
//		if(isempty()) {
//			System.out.println("the lemnt not found");
//			return -1;
//		}
//		return size[front];
//	}
//	
//	public void printall() {
//		for(int i=0;i<=rear;i++) {
//			System.out.println(size[i]);
//			
//		}
//	}
//	}

public class queu_deque_arry_list {
	
	static class node{
		int data;
		node next;
		
		node(int dtaa){
			this.data=dtaa;
			this.next=null;
			
		}
	}
		node front=null,rear=null;
		public boolean isempty() {
			return front==null;
			
		}
		public void add_front(int data) {
			node newnode=new node(data);
			if(isempty()) {
				front=rear=newnode;
				
				return;
			}
			else {
				rear.next=newnode;
				rear=newnode;
			}
		}
		
		
		public int remove() {
			if(isempty()) {
				System.out.println("the queue is the empty");
				return -1;
			}
			int top=front.data;
			front=front.next;
			return top;
		}
		
	
	public int peek() {
		if(isempty()) {
			System.out.println("the queue is the empty");
			return -1;
		}
		int top=front.data;
		
		return top;
	}
	

	
	public static void main(String[] args) {
		queu_deque_arry_list a1=new queu_deque_arry_list();
		 a1.add_front(2);
		 a1.add_front(5);
		 a1.add_front(6);
		 a1.add_front(27);
		 a1.add_front(20);
//		a1.printall();
		System.out.println("the pop is "+ a1.remove() + " the peek is the "+ a1.peek());
		
		
		
	}

}
