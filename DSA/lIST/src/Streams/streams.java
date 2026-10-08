package Streams;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

public class streams {

    static class Employee {
        int id;
        String name;
        String department;
        double salary;

        public Employee(int id, String name,
                        String department, double salary) {
            this.id = id;
            this.name = name;
            this.department = department;
            this.salary = salary;
        }
        
        @Override
        public String toString() {
            return id + " " + name + " " + department + " " + salary;
        }
    }

	public static void main(String[] args) {
	
	List<Employee> employees = Arrays.asList(
		    new Employee(1, "John", "IT", 50000),
		    new Employee(2, "Alice", "HR", 60000),
		    new Employee(3, "Bob", "IT", 70000),
		    new Employee(4, "David", "Finance", 80000),
		    new Employee(10, "Davi2d", "Finance", 80000),
		    new Employee(5, "John", "IT", 50000)
		);
	
	
	
/***
 * Get all employees from IT department.
Get employee names only.
Convert all names to uppercase.
Sort employees by salary.
Sort employees by salary descending.
Remove duplicate names.
Count employees in IT department.
Find highest salary.
Find total salary of all employees.
Find first employee with salary > 60000.
Check if any employee belongs to HR.
Check if all employees have salary > 30000.
Group employees by department.
Create a Map of Employee ID → Name.
Get top 3 highest-paid employees.
 * 	
 */
		List<Employee> all_values=employees.stream().filter(dept -> dept.department.startsWith("IT"))
		.collect(Collectors.toList());
		
		List<String> uppernames=employees.stream().map(namew -> namew.name.toUpperCase())
		.collect(Collectors.toList());
		System.out.println(uppernames);
		
		
		List<Double> list_salry=employees.stream().sorted((curr, prev) -> Double.compare(prev.salary,  curr.salary)).map(sal-> sal.salary).collect(Collectors.toList());
		
		System.out.println("the double salry "+ list_salry);
		
		
//		count number empy in it
		long numbers =employees.stream().filter(dpet -> dpet.department.equals("IT")).count();
		System.out.println("the number of emplyedd "+ numbers);
		
//		remove duplicate dept
		
		List<String> set_values=employees.stream().map(name-> name.name).distinct().toList();
		System.out.println("unique values of emplyess "+ set_values);
		
		
//		collect name and dept only one emplyee
		
		
		Map<String, Employee> emplee=employees.stream()
        .collect(Collectors.toMap(
            emp -> emp.department,
            emp -> emp,
            (first, second) -> first
        ));
		
		System.out.println("all the emplyee from dept --> "+ emplee);
		
		
//		Find highest salary. 2nd
		
		List<Double> all_details=employees.stream().distinct().map(ma-> ma.salary).sorted((curr, prev)-> Double.compare(prev, curr)).toList();
		
		System.out.println(all_details.get(0));
		
		
//		total saley of all the emplyee
	
		double sla=employees.stream().mapToDouble(sal-> sal.salary).sum();
		System.out.println("the totla salery "+ sla );
		
		
//		find the slary of  the employee more than 6000 
		Map<Double, Employee> data=employees.stream().
				filter(sall-> sall.salary>60000.0)
				.collect(Collectors.toMap(
						emp -> emp.salary,
						emp-> emp,
						(e1, e2)->e1
						
						));
				
				
		
		System.out.println("the salary of all the employee is more than 6 k is " + data);
		
		System.out.println(all_values);
		
		
		

}
}
