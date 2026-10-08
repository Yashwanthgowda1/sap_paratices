package Linked_list;

import java.util.LinkedList;
import java.util.List;

public class creation_list_methods {
	public class node{
		int data;
		node next=null;
		node(int data){
			this.data=data;
			this.next=null;
		}
	}
	
	node head=null;	node curr=head;
public void add(int data) {
	node newnodw=new node(data);
	if(head==null) {
		head=newnodw;
		return;
	
	}
	node temp=head;
	while(temp.next!=null) {
		temp=temp.next;
	}
	temp.next=newnodw;
	newnodw=temp;

}
	public void printall() {
		node current=head;
		if(current==null) {
			System.out.println("the list is empty");
		}
		while(current!=null) {
			System.err.print(current.data + " -->");
			current=current.next;
			
		}
		
	}
	public void addfirst(int data) {
		node newnode=new node(data);
		if(head==null) {
			head=newnode;
			return;
		}
		newnode.next=head;
		head=newnode;
		
		
	}
	public void addlast(int data) {
		node newnode=new node(data);
		if(head==null) {
			head=newnode;
			return;
		}
		node temp=head;
		while(temp.next!=null) {
			temp=temp.next;
		}
		temp.next=newnode;
		temp=newnode;
		
	}
	public boolean isempty() {
		if(head==null) {
			return true;
		}
		return false;
		
	}
	public void clear() {
		
			head=null;

	}
	public void removefirst() {
		if(head==null) {
			System.out.println("the values are empty to remove");
			return;
		}
		node newnode =head.next;
		head=newnode;
	}
	
public void removelast() {
	if(head==null) {
		System.out.println("the values are empty to remove");
		return;
	}
	node temp=head;
	node pre=head;
	while(temp.next!=null) {
		pre=temp;
		temp=temp.next;
		
		
	}
pre.next=null;
}
	public static void main(String[] args) {
		creation_list_methods a1=new creation_list_methods();
		a1.add(10);
		a1.add(30);
		a1.add(0);
		a1.add(67);
		a1.add(89);
		
		a1.addfirst(20);
		a1.addlast(9330);
		System.out.println(a1.isempty());
		
		a1.printall();
	
		System.out.println(a1.isempty());
		System.out.println();
	
		a1.removefirst();
		a1.removelast();
		a1.printall();
		
		
	
	

}
}
