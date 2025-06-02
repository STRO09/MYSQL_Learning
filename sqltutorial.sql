create database tutorial;
use tutorial;

create table demo(empid int primary key, empname varchar(50) NOT NULL, salary double , dept varchar(20) default 'INFT');

-- constraints: primary key, foreign key, not null, check, default, unique, auto_increment
drop table demo;
INSERT INTO demo values(54, 'Sagar', 30000, default);
INSERT INTO demo values(39, 'Rajan', 40000, 'CMPN');
INSERT INTO demo values(38, 'Raja', 4000, default);
INSERT INTO demo values(37, 'Raj', 400, 'EXTC');
INSERT INTO demo values(23, 'Yuvi', NULL, 'EXTC');	

desc  demo;
select * from demo;

UPDATE demo SET empname = 'Hari' where empid = 38;
DELETE FROM demo where empid = 37;


-- SQL CLAUSES 
select dept, count(*) as deptmembers from demo group by dept; -- group by only works with aggregate functions
select empname, count(salary) as salary_applicable from demo group by empname;





-- JOINS 
create table employees(id int auto_increment primary key, name varchar(50) NOT NULL, dept int , foreign key(dept) references departments(id));
create table departments(id int auto_increment primary key, dept_name varchar(50) NOT NULL unique);

INSERT INTO departments(dept_name) values("CMPN");
INSERT INTO departments(dept_name) values("INFT");
INSERT INTO departments(dept_name) values("EXTC");
INSERT INTO departments(dept_name) values("MECH");

INSERT INTO employees(name,dept) values("Sagar", "2");
INSERT INTO employees(name,dept) values("Hari", "2");
INSERT INTO employees(name,dept) values("Rajan", "2");
INSERT INTO employees(name,dept) values("Karan", "2");
INSERT INTO employees(name,dept) values("Shrajan", "1");
INSERT INTO employees(name,dept) values("Soumyadeep", "1");
INSERT INTO employees(name,dept) values("Glenn", "1");
INSERT INTO employees(name,dept) values("Neel", "4");
INSERT INTO employees(name,dept) values("Harshil", "4");
INSERT INTO employees(name,dept) values("Devendra", "4");
INSERT INTO employees(name,dept) values("Riya", "3");

SELECT * from employees; 
SELECT * from departments;

SELECT name,dept_name FROM employees e INNER JOIN departments d ON e.dept=d.id;
SELECT COUNT(name),dept_name FROM employees e INNER JOIN departments d ON e.dept=d.id group by dept_name;

UPDATE employees e INNER JOIN departments d ON e.dept=d.id SET e.name="MECH VAALE" where d.dept_name="MECH";

SELECT name,dept_name FROM employees e INNER JOIN departments d ON e.dept=d.id;

DELETE e FROM employees e INNER JOIN departments d ON e.dept=d.id where d.dept_name="EXTC";


SELECT name,dept_name FROM employees e INNER JOIN departments d ON e.dept=d.id;
SELECT COUNT(name),dept_name FROM employees e RIGHT JOIN departments d ON e.dept=d.id group by dept_name;

-- new tables incoming 
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dept_id INT, -- allow NULLs
    FOREIGN KEY (dept_id) REFERENCES departments(id)
        ON DELETE SET NULL
);

INSERT INTO departments (dept_name)
VALUES ('Engineering'), ('Marketing'), ('HR');


INSERT INTO employees (name, dept_id)
VALUES 
('Alice', 1),
('Bob', 2),
('Carol', NULL), -- no department
('David', 3),
('Eve', NULL); -- no department

-- write a query to find employees who are not assigned to any dept
SELECT name FROM employees e LEFT JOIN departments d on e.dept_id=d.id where e.dept_id=NULL;
-- this wont work since null is not a value. use IS NULL
 SELECT name FROM employees e LEFT JOIN departments d on e.dept_id=d.id where e.dept_id IS NULL;
 
-- List all department names along with the number of employees in each department.
SELECT dept_name, COUNT(name) FROM employees e RIGHT JOIN departments d on e.dept_id=d.id group by d.dept_name;

-- Show only those departments that have no employees.
INSERT INTO departments(dept_name) values('IT'), ('Testing');
SELECT dept_name FROM employees e RIGHT JOIN departments d on e.dept_id=d.id where e.name IS NULL;

-- Show a list of all employees and their department names, but instead of NULL, display "Unassigned" for unassigned employees.
SELECT name, coalesce(dept_name, 'Unassigned') FROM employees e LEFT JOIN departments d on e.dept_id=d.id;

--  List each department name along with the number of employees. But instead of showing 0, display 'No employees yet'.
SELECT dept_name,
CASE 
WHEN COUNT(name)=0 THEN 'No employees yet'
ELSE CAST(COUNT(name) as CHAR)
END as 'no. of employees' 
 FROM  employees e RIGHT JOIN departments d ON e.dept_id=d.id group by dept_name;

-- List all employees along with their department name.If they don’t have a department, display Unassigned using COALESCE.
SELECT name,coalesce(dept_name,'Unassigned') as 'dept_name' FROM employees e LEFT JOIN departments d ON e.dept_id=d.id;

-- ROUND ABOUT WAY OF IMPLEMENTING FULL OUTER JOIN. SINCE ITS NOT NATIVE TO MYSQL	
SELECT * FROM employees e LEFT JOIN departments d ON e.dept_id=d.id UNION SELECT * FROM employees e RIGHT JOIN departments d ON e.dept_id=d.id;

-- List all departments and the number of employees in each. Also include departments with no employees, and display "No employees yet" in such cases. do using full OUTER JOIN
SELECT 
CASE 
WHEN dept_name IS NULL THEN 'Unassigned'
ELSE dept_name
END as dept_name -- here dept_name now becomes alias so dont use it to group by
,COUNT(name) as 'no. of employees' FROM 
employees e LEFT JOIN departments d ON e.dept_id=d.id 
group by d.dept_name 
UNION
SELECT dept_name,
CASE 
WHEN COUNT(name)=0 THEN 'No employees'
ELSE CAST(COUNT(name) as CHAR)
END as 'no. of employees'
FROM 
employees e RIGHT JOIN departments d ON e.dept_id=d.id 
group by dept_name;




-- SUBQUERIESSSS

-- Get employees who work in the department with the highest number of employees	
SELECT * from employees;
INSERT INTO employees(name,dept_id) values('Pradnya',1), ('Yuvi',1);
SELECT name, dept_id FROM employees where dept_id=(SELECT dept_id FROM employees group by dept_id ORDER BY COUNT(*) DESC LIMIT 1);

-- List all employees who earn more than the average salary of all employees.
CREATE TABLE employees_with_salary (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  salary INT,
  dept_id INT,
  FOREIGN KEY (dept_id) REFERENCES departments(id)
);

INSERT INTO employees_with_salary (name, salary, dept_id) VALUES
('Alice', 60000, 1),
('Bob', 75000, 1),
('Charlie', 50000, 2),
('Diana', 80000, 3),
('Eve', 55000, NULL),  -- No department
('Frank', 70000, 1),
('Grace', 30000, 2);

SELECT * FROM employees_with_salary;

-- main mentioned query 
SELECT name, salary from employees_with_salary where salary> (SELECT AVG(salary) from employees_with_salary ) ;
SELECT AVG(SALARY) from employees_with_salary;

-- List departments and the average salary of employees in each department. But only show departments where the average salary is higher than the overall average salary.
SELECT dept_name, AVG(salary) as 'avg_salary' FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id GROUP BY d.dept_name HAVING AVG(salary)> (SELECT AVG(salary) FROM employees_with_salary);


-- 	CLAUSE QUESTIONs
-- List department names where the number of employees is at least 2.
SELECT * FROM employees_with_salary;
SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id GROUP BY dept_name HAVING COUNT(name)>2;

-- List all departments with more than 2 employees.
SELECT dept_name from employees e INNER JOIN departments d on e.dept_id = d.id GROUP BY e.dept_id HAVING COUNT(name)>2;

-- List departments whose average salary is more than ₹60,000.
SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id = d.id GROUP BY e.dept_id HAVING AVG(salary)>60000;

-- List departments where the max salary is less than ₹80,000.
SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id = d.id GROUP BY e.dept_id HAVING MAX(salary)<80000;

-- List departments that have both high-paid (₹70k+) and low-paid (<₹50k) employees.

-- this one is for departments with max salary either more than 70000 and or less than 50000
(SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id = d.id GROUP BY e.dept_id HAVING MAX(salary)>70000) UNION (SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id = d.id GROUP BY e.dept_id HAVING MAX(salary)<50000);

-- this one is for departments that are paying employees more than 70k but also less thN 50K
SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id = d.id GROUP BY e.dept_id HAVING MAX(salary)>70000 AND MIN(salary)<50000;

-- List departments where total salary payout exceeds ₹150,000.
SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id = d.id GROUP BY e.dept_id HAVING SUM(salary)>150000;

-- List department names where the number of employees is at least 2. sorting the average salary per department in descending order
SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id GROUP BY e.dept_id HAVING COUNT(name)>2 ORDER BY AVG(salary) DESC; 


-- CORRELATED QUERY

-- List all employees who earn more than the average salary of their own department.
SELECT name FROM employees_with_salary e1 where salary> (SELECT AVG(salary) from employees_with_salary e2 where e1.dept_id=e2.dept_id); 

-- List all employees whose salary is higher than the salary of the employee with the lowest salary in their department.
SELECT name from employees_with_salary e1 where salary> (SELECT MIN(salary) from employees_with_salary e2 where e2.dept_id=e1.dept_id);

-- Find all departments where the highest-paid employee earns more than ₹100,000.
SELECT dept_name from employees_with_salary e INNER JOIN departments d on e.dept_id=d.id GROUP BY dept_name HAVING MAX(salary) > 100000;

-- For each employee, show their name and how many employees in the same department earn less than they do.
SELECT name, (SELECT COUNT(*) from employees_with_salary e2 where e2.dept_id=e1.dept_id AND e2.salary<e1.salary) as no_of_employees_earning_less from employees_with_salary e1;

-- List all employees who earn more than the average salary of all employees in the company (not per department) 
SELECT name FROM employees_with_salary where salary>(SELECT AVG(salary) as avg_salary FROM employees_with_salary);

--  For each department, show the department name and the number of employees, only if the department's average salary is greater than ₹50,000. 
SELECT dept_name, COUNT(name) as 'no_of_employees' from employees_with_salary e INNER JOIN departments d on e.dept_id=d.id group by dept_name having AVG(salary)>50000;

-- Show the names of employees whose salary is greater than all employees in the "HR" department.	
SELECT name FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id where e.salary>(SELECT MAX(salary) from employees_with_salary e2 where e2.dept_id= 2);

-- List all departments that have at least one employee earning more than ₹70,000.
SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id group by dept_name HAVING MAX(salary)>70000;
SELECT dept_name FROM  departments d where EXISTS (SELECT 1 from employees_with_salary e where salary>70000); -- this will check for each department if the exists value is true or not. first select enginrng, conditionn is true return the dept, check for hr condtn true then retrun dept. will return all queries
SELECT dept_name FROM  departments d where EXISTS (SELECT 1 from employees_with_salary e where e.dept_id=d.id AND salary>70000);

-- List employee names who belong to departments where the maximum salary is above ₹80,000.
SELECT name FROM employees_with_salary group by dept_id HAVING MAX(salary)>80000; -- ❌❌❌ this is wrong since the aggregated column dept_id would have multplie names
SELECT dept_id FROM employees_with_salary group by dept_id HAVING MAX(salary)>80000; -- ❌❌❌ this works since dept_id would be the same for the group

SELECT name FROM employees_with_salary e where dept_id = (SELECT dept_id FROM employees_with_salary e1 where e.dept_id=e1.dept_id group by e1.dept_id HAVING MAX(salary)>80000); -- ✔✔✔
SELECT name FROM employees_with_salary where dept_id IN (SELECT dept_id FROM employees_with_salary group by dept_id HAVING MAX(salary)>80000);

-- List the names of employees who earn more than every employee in the "Marketing" department.
SELECT name FROM employees_with_salary where salary > (SELECT MAX(salary) from employees_with_salary e INNER JOIN departments d on e.dept_id=d.id where dept_name='Marketing');

-- For each department, show the department name and the average salary of its employees, only if the department has at least 3 employees.
SELECT CASE 
WHEN COUNT(*)>=3 THEN dept_name
END
as 'dept_name', AVG(salary) as 'average salary' FROM employees_with_salary e INNER JOIN departments d on e.dept_id = d.id group by dept_name;
SELECT  dept_name, AVG(salary) as 'average salary' FROM employees_with_salary e INNER JOIN departments d on e.dept_id = d.id group by dept_name HAVING COUNT(*)>=3;


-- List all departments that have employees with both salaries over ₹68,000 and under ₹61,000.
SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id group by dept_name HAVING MIN(salary)<61000 AND MAX(salary)>68000; 

-- List the names of employees who earn more than the average salary of all employees.
SELECT name from employees_with_salary where salary> (SELECT AVG(salary) from employees_with_salary );

-- List the names of employees who are the highest paid in their own department.
SELECT name FROM employees_with_salary e1 where salary= (SELECT MAX(salary) from employees_with_salary e2 where e1.dept_id=e2.dept_id group by e2.dept_id );

-- Show department names that have no employees at all.
SELECT dept_name,d.id FROM employees_with_salary e RIGHT JOIN departments d on e.dept_id=d.id group by d.id HAVING COUNT(name)=0 ;

-- For each employee, show their name and how many employees in the same department earn less than they do.
SELECT name, (SELECT COUNT(*) FROM employees_with_salary e2 where e1.dept_id=e2.dept_id AND e2.salary<e1.salary) as 'employees_earning_less' FROM employees_with_salary e1;

-- List all departments where the total salary payout exceeds ₹200,000.
SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id group by dept_id HAVING SUM(salary)>200000;

-- Show the names of employees who belong to departments where the average salary is below ₹50,000.
SELECT name from employees_with_salary e where e.dept_id IN (SELECT dept_id from employees_with_salary e1 group by e1.dept_id HAVING AVG(e1.salary)<50000);
SELECT dept_id from employees_with_salary e1 group by e1.dept_id HAVING AVG(e1.salary)<50000;

-- List the department(s) with the second-highest average salary.
SELECT dept_name FROM (SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id GROUP BY dept_name ORDER BY AVG(salary) DESC) as derived_table LIMIT 1 OFFSET 1;
SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id GROUP BY dept_name ORDER BY AVG(salary) DESC;

--  Show departments where the average salary is above ₹60,000, along with the average.
SELECT dept_name, AVG(salary) as 'avg_salary' FROM employees_with_salary e1 INNER JOIN departments d on e1.dept_id=d.id group by dept_name HAVING AVG(salary)>60000;

-- Find departments where the number of employees is greater than 1.
-- SELECT dept_id FROM (SELECT dept_id FROM employees_with_salary group by dept_id HAVING COUNT(*)>1) as employees; 
SELECT dept_name FROM (SELECT dept_name, COUNT(*) as emp_count FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id group by dept_name) as count_table where emp_count>1;


-- Show employee names along with how much their salary is above the average salary of their department (if it is).
SELECT e.name,(salary-avg_salary) as salary_difference from employees_with_salary e INNER JOIN (SELECT dept_id,AVG(salary) as 'avg_salary' FROM employees_with_salary e2 group by dept_id) as avg_salary_table on e.dept_id=avg_salary_table.dept_id where salary>avg_salary;


-- List departments and their total salary payout, only if it's above ₹200,000.
SELECT dept_name,SUM(salary) as total_salary_payout FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id group by dept_name HAVING SUM(salary)>200000;

-- Find departments whose highest salary is less than ₹70,000.
SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id group by dept_name HAVING MAX(salary)<60000;

-- Show the department name and the number of employees only if all employees in that department earn more than ₹60,000.
SELECT dept_name,COUNT(*) as no_of_employees FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id group by dept_name HAVING MIN(salary)>60000;

-- List employees who do not belong to any department (i.e., orphan records).
SELECT name FROM employees where dept_id IS NULL;

-- List departments that have no employees whose salary is below ₹45,000.
SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id group by dept_name HAVING MIN(salary)>45000;

-- List employee names along with the department name, but only for employees who earn more than any employee in the "Marketing" department.
SELECT name, dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id where salary>(SELECT MAX(salary) FROM employees_with_salary e1 INNER JOIN departments d1 on e1.dept_id=d1.id where dept_name="Marketing");

-- List employees whose salary is less than at least one employee in their own department.
SELECT name FROM employees_with_salary e1 where salary<(SELECT MAX(salary) FROM  employees_with_salary e2 where e1.dept_id=e2.dept_id);

-- Show employees who are the only person in their department.
SELECT name FROM employees_with_salary e1 where (SELECT COUNT(*) FROM employees_with_salary e2 where e1.dept_id=e2.dept_id)=1;

-- Find 2nd highest salary in each department
SELECT salary,dept_id FROM employees_with_salary e1 where salary<(SELECT MAX(salary) FROM employees_with_salary e2 where e2.dept_id=e1.dept_id group by e2.dept_id) ;

-- ************                        WINDOW FUNCTIONS FOR MYSQL 8                     *************************  
-- ************                        WINDOW FUNCTIONS FOR MYSQL 8                     *************************  
-- ************                        WINDOW FUNCTIONS FOR MYSQL 8                     *************************  



-- create
-- CREATE TABLE EMPLOYE (
--   name varchar(15) NOT NULL,
--  dept varchar(10),
--  salary int NOT NULL
-- );

-- INSERT INTO EMPLOYE values ('Alice',1, 60000), ('Bob',1,70000), ('Carol',	2	,50000), ('David',1,	80000), ('Eva',2,60000);

-- SELECT * FROM EMPLOYE;

-- SELECT name, dept,salary, ROW_NUMBER() OVER (partition by dept ORDER BY salary) as per_dept_rank FROM EMPLOYE;

-- SELECT name, dept,salary, ROW_NUMBER() OVER (ORDER BY salary) as rank FROM EMPLOYE;

-- SELECT name, dept, salary, rank() OVER (ORDER BY salary) as 'rank(function)' FROM EMPLOYE;

-- SELECT name, dept, salary, dense_rank() OVER (ORDER BY salary) as 'dense_rank(function)' FROM EMPLOYE;

-- SELECT distinct dept, SUM(salary) OVER (partition by dept) as total_salary FROM EMPLOYE;

-- SELECT dept, AVG(salary) OVER (partition by dept) as 'avg_salary' FROM EMPLOYE;

-- SELECT name,dept, salary, NTILE(3) OVER (ORDER BY salary desc) as bucket_no FROM EMPLOYE;

-- SELECT name,dept, salary, NTILE(3) OVER (ORDER BY name ) as bucket_no FROM EMPLOYE;

-- SELECT name, dept, salary, LEAD(salary) OVER (ORDER BY salary)  as 'next_salary' FROM EMPLOYE; 
-- SELECT name, dept, salary, LAG(salary) OVER (ORDER BY salary)  as 'previous_salary' FROM EMPLOYE; 

-- SELECT name, dept, salary, LEAD(name) OVER (ORDER BY name)  as 'next_emp' FROM EMPLOYE;

-- Find the top 2 highest-paid employees in each department.
-- SELECT name,salary, dept FROM (SELECT *, dense_rank() OVER (partition by dept ORDER BY salary) as rank FROM EMPLOYE) as highest_paid_table where rank<=2;



-- ************                        WINDOW FUNCTIONS FOR MYSQL 8                     ************************* 
-- ************                        WINDOW FUNCTIONS FOR MYSQL 8                     *************************  
-- ************                        WINDOW FUNCTIONS FOR MYSQL 8                     *************************  
-- ************                        WINDOW FUNCTIONS FOR MYSQL 8                     *************************  
-- ************                        WINDOW FUNCTIONS FOR MYSQL 8                     *************************  
-- ************                        WINDOW FUNCTIONS FOR MYSQL 8                     *************************   


-- Find the second highest salary. (Classic, every company asks this one!)
SELECT salary,name FROM employees_with_salary where salary<(SELECT MAX(salary) FROM employees_with_salary) ORDER BY salary DESC LIMIT 1;

-- List employees who earn more than the average salary.
SELECT salary, name FROM employees_with_salary where salary> (SELECT AVG(salary) FROM employees_with_salary);

-- Find duplicate rows in a table.
SELECT name,salary,dept_id, COUNT(*) as duplicate_rows_count FROM employees_with_salary group by name,salary,dept_id HAVING COUNT(*)>1;

-- Count the number of employees in each department.
SELECT dept_name, COUNT(name) as no_of_employees FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id group by dept_name;

-- Show all employees who do not have a dept.
SELECT name FROM employees_with_salary where dept_id IS NULL;

-- List employees and their department names.
SELECT name, dept_name FROM  employees_with_salary e INNER JOIN departments d on e.dept_id=d.id ;

-- Find employees who work in departments that have more than 2 employees.
SELECT name, dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id where dept_id IN (SELECT dept_id FROM employees_with_salary group by dept_id HAVING COUNT(*)>2);

-- Find departments that have no employees. 
SELECT dept_name FROM  employees_with_salary e RIGHT JOIN departments d on e.dept_id=d.id group by dept_name HAVING COUNT(*)=0;

-- List employees who earn more than anyone in the ‘Engineering’ department.
SELECT name,salary FROM employees_with_salary where salary> (SELECT MAX(salary) FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id where d.dept_name="Engineering");

-- Find employees who don’t belong to any department.
SELECT name FROM employees where dept_id IS NULL ;

-- Find departments with the highest total salary payout.
SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id=d.id group by dept_name ORDER BY SUM(salary) LIMIT 1;

-- Find the employee(s) with the highest salary in each department.
SELECT name FROM employees_with_salary e INNER JOIN departments d on e.dept_id = d.id where salary = (SELECT MAX(salary) FROM employees_with_salary e1 where e.dept_id=e1.dept_id);

-- List departments where all employees earn more than ₹60,000.
SELECT dept_name FROM employees_with_salary e INNER JOIN departments d on e.dept_id = d.id group by dept_name HAVING MIN(salary)>60000;

-- Find employees who earn less than the average salary of their department.
SELECT name FROM employees_with_salary e1 where salary < (SELECT AVG(salary) FROM  employees_with_salary e2 where e2.dept_id = e1.dept_id group by dept_id);

-- Find employees whose salary is more than the highest salary in other departments.
SELECT name FROM employees_with_salary e1 where salary> (SELECT MAX(salary) FROM  employees_with_salary e2 where e2.dept_id != e1.dept_id );




--------    SET OPERATIONSSSSSS

-- UNION 
(SELECT name, dept_id FROM employees) UNION (SELECT dept_name, id FROM departments) ;
(SELECT dept_id FROM employees) UNION (SELECT id FROM departments) ;

-- UNION ALL 
(SELECT dept_id FROM employees) UNION ALL (SELECT id FROM departments) ;

-- INTERSECT
SELECT id FROM departments where id IN (SELECT dept_id FROM employees);

-- EXCEPT
SELECT id FROM departments where id NOT IN (SELECT dept_id FROM employees);


-- STOREDDD PROCEDURESSSSS
-- STOREDDD PROCEDURESSSSS
-- STOREDDD PROCEDURESSSSS

DELIMITER //    
CREATE procedure TOTALMAXSALARIES(OUT maxsalariesdept INT) 
BEGIN 
	SELECT SUM(max_salary)
	INTO maxsalariesdept
	FROM (
	SELECT MAX(salary) as max_salary
	from employees_with_salary
    where dept_id IS NOT NULL
	group by dept_id
	) as maxsalariesofdepts;
END //
DELIMITER ;

DROP procedure TOTALMAXSALARIES;
SELECT * FROM employees_with_salary;

CALL TOTALMAXSALARIES(@maxsalariesofalldepts);
SELECT @maxsalariesofalldepts;
SHOW PROCEDURE STATUS LIKE 'TOTALMAXSALARIES';

DELIMITER //
CREATE PROCEDURE GreetUser(IN uname varchar(50))
BEGIN 
SELECT CONCAT('Hello,', uname) AS greeting;
END //
DELIMITER ;

CALL GreetUser("Sagar");

DELIMITER //
CREATE PROCEDURE CalculateBonus(INOUT package INT) 
BEGIN 
SET package = package - 0.2*package;
END //
DELIMITER ;

SET @salary =50000;
SELECT salary INTO @salary FROM employees_with_salary ORDER BY salary LIMIT 1;
SELECT salary FROM employees_with_salary ORDER BY salary LIMIT 1;

CALL CalculateBonus(@salary);
SELECT @salary;


DELIMITER //
CREATE PROCEDURE CalculateInHandSalary(IN package INT, out monthlysalary INT) 
BEGIN 
SET monthlysalary = (package - 0.2*package)/ 12 ; 
END //
DELIMITER ;

CALL CalculateInHandSalary(500000,@monthlysalary);

SELECT @monthlysalary;


CREATE TABLE employees_new (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    dept_id INT,
    salary DECIMAL(10,2),
    hire_date DATE
);


CREATE TABLE salary_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    action_type VARCHAR(100), -- INSERT, UPDATE, DELETE
    emp_id INT,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO employees_new (id, name, dept_id, salary, hire_date) VALUES
(1, 'Alice', 1, 70000, '2020-01-10'),
(2, 'Bob', 2, 50000, '2021-03-15'),
(3, 'Charlie', 1, 80000, '2019-07-22'),
(4, 'David', 3, 45000, '2022-05-30'),
(5, 'Eva', 2, 55000, '2023-01-01'),
(6, 'Frank', 3, 40000, '2021-11-11'),
(7, 'Grace', 1, 60000, '2020-12-25');



-- Write a procedure that takes Emp ID as input and returns the employee's name as output.
DELIMITER //
CREATE procedure ReturnEmpName(IN empid INT, OUT empname varchar(50))
BEGIN 
SELECT name INTO empname FROM employees_new where id=empid;
END //
DELIMITER ;

CALL ReturnEmpName(4,@name1);
SELECT @name1;

-- Create a procedure that calculates and returns the total salary of a given department.
DELIMITER //
CREATE procedure DeptTotalSalary(IN id INT, OUT total_salary INT)
BEGIN 
SELECT SUM(salary) INTO total_salary FROM employees_new where dept_id=id;
END //
DELIMITER ;

CALL DeptTotalSalary(1, @depttotalsal);
SELECT 	@depttotalsal;

-- Create a procedure that increases an employee's salary by a given percentage. 
DELIMITER //
CREATE procedure SalHike(IN empid INT, IN percentage INT) 
BEGIN 
UPDATE employees_new SET salary = salary+ (salary*percentage)/100 where id=empid;
END //
DELIMITER ;

CALL SalHike(6,20);

SELECT * FROM employees_new;
SELECT * FROM departments;


-- Write a procedure that accepts a department name and returns: The number of employees (OUT) The average salary (OUT) IN: dept_name OUT: emp_count, avg_salary
DELIMITER //
CREATE procedure AvgSalPerTotalEmp(IN deptname varchar(50), OUT emp_count INT, OUT avg_sal INT) 
BEGIN
SELECT COUNT(*) INTO emp_count FROM employees_new e INNER JOIN departments d on e.dept_id=d.id where d.dept_name=deptname group by d.dept_name ;
SELECT AVG(salary) INTO avg_sal FROM employees_new e INNER JOIN departments d on e.dept_id=d.id where d.dept_name=deptname group by d.dept_name ;
END //
DELIMITER ;
-- or we can do  SELECT COUNT(*), AVG(e.salary) INTO emp_count, avg_sal FROM employees_new e INNER JOIN departments d ON e.dept_id = d.id WHERE d.dept_name = deptname;
DROP procedure AvgSalPerTotalEmp;
CALL AvgSalPerTotalEmp('Engineering',@totalemps, @avgsaldept);
SELECT @totalemps, @avgsaldept;


-- Write a procedure that accepts an INOUT salary value and increases it by 20% only if it is below 50,000.
DELIMITER //
CREATE procedure SalHikeIfLess(INOUT salary INT) 
BEGIN
IF salary< 50000 THEN
SET salary = salary+salary*0.2;
END IF;
END //
DELIMITER ;

SET @sal1=40000, @sal2=60000, @sal3=50000;
CALL SalHikeIfLess(@sal1);
CALL SalHikeIfLess(@sal2);
CALL SalHikeIfLess(@sal3);

SELECT @sal1, @sal2, @sal3;

-- Create a procedure that accepts two employee IDs and swaps their salaries using INOUT parameters. INOUT: emp1_salary, emp2_salary
DELIMITER //
CREATE procedure SwapSalaries(IN empid1 INT, IN empid2 INT, OUT emp1sal INT, OUT emp2sal INT) 
BEGIN 
SELECT salary INTO emp1sal FROM employees_new where id=empid1;
SELECT salary INTO emp2sal FROM employees_new where id=empid2;
UPDATE employees_new SET salary=emp1sal where id=empid2;
UPDATE employees_new SET salary=emp2sal where id=empid1;
END //
DELIMITER ;

-- or CREATE procedure SwapSalaries(IN empid1 INT, IN empid2 INT) BEGIN  declare tempemp1sal INT; declare tempemp2sal INT; SELECT salary INTO tempemp1sal FROM employees_new where id=empid1; SELECT salary INTO tempemp2sal FROM employees_new where id=empid2; UPDATE employees_new SET salary=tempemp1sal where id=empid2; UPDATE employees_new SET salary=tempemp2sal where id=empid1; END // DELIMITER ;
CALL SwapSalaries(6,2,@emp1salnew,@emp2salnew);


-- TRIGGERS
-- TRIGGERS
-- TRIGGERS
-- TRIGGERS
-- TRIGGERS

-- CREATE TO LOG EVERY SALARY CHANGE 
DELIMITER //
CREATE TRIGGER SalChangeLog 
AFTER UPDATE 
ON employees_new 
FOR EACH ROW 
BEGIN 
IF OLD.salary != NEW.salary THEN 
INSERT INTO salary_log(emp_id,old_salary,new_salary,changed_on) values(OLD.id,OLD.salary,NEW.salary,NOW());
END IF;
END //
DELIMITER ; 

SELECT * FROM employees_new;
UPDATE employees_new SET salary=65000 where id=7;

SELECT * FROM salary_log;


-- PREVENT INSERTION OF LOW SALARY EMPLOYEES
DELIMITER //
CREATE TRIGGER PreventLowSal 
BEFORE INSERT ON employees_new 
FOR EACH ROW
BEGIN 
IF NEW.salary<=10000 THEN 
SIGNAL SQLSTATE '45000'
SET Message_TEXT='Salary too Low (<=10000)'; 
END IF;
END //
DELIMITER ;

INSERT INTO employees_new(name,dept_id,salary,hire_date) values('Sagar',3,10000,'2023-01-01');


-- Prevent deletion of employees from the "HR" department.

DELIMITER //
CREATE TRIGGER PreventDelHR 
BEFORE DELETE ON employees_new 
FOR EACH ROW
BEGIN 
DECLARE deptname varchar(50);
SELECT dept_name INTO deptname FROM departments where id=OLD.dept_id;
IF deptname='HR' THEN 
SIGNAL SQLSTATE '45000'
SET Message_TEXT='HR Employees cannot be deleted'; 
END IF;
END //
DELIMITER ;

SELECT * FROM employees_new;
DELETE FROM employees_new where id=4;

INSERT INTO employees_new(name,dept_id,salary) values('STRO',2,50000);

-- Automatically set the joining date to current date if it's not provided during insert.
DELIMITER //
CREATE TRIGGER AutoJoinCurrentDate
BEFORE INSERT ON employees_new
FOR EACH ROW
BEGIN 
IF NEW.hire_date IS NULL THEN 
SET NEW.hire_date=NOW(); 
END IF;
END //
DELIMITER ;

INSERT INTO employees_new(name,dept_id,salary) values('Theseus',2,50000);


-- Block insert if employee name already exists in the table.
DELIMITER //
CREATE TRIGGER PreventSameNameInsert
BEFORE INSERT ON employees_new
FOR EACH ROW
BEGIN 
IF EXISTS (SELECT 1 FROM employees_new where name=NEW.name) THEN 
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT ='Duplicate name insertion performed';
END IF;
END //
DELIMITER ;

INSERT INTO employees_new(name,dept_id,salary) values('Theseus',3,60000);

-- Keep a count of inserts into a table using a stats(counter_name, value) table. stats table will keep count of diff things with operation name 'counter_name'
CREATE TABLE stats (
  counter_name VARCHAR(50) PRIMARY KEY,
  value INT
);

DELIMITER //
CREATE TRIGGER CountEmpInsertions
AFTER INSERT ON employees_new
FOR EACH ROW
BEGIN 
IF NOT EXISTS (SELECT 1 FROM stats where counter_name='emp_count') THEN 
INSERT INTO stats values('emp_count',0);
END IF;
UPDATE stats SET value=value+1 where counter_name='emp_count';
END //
DELIMITER ;

DROP TRIGGER CountEmpInsertions;
INSERT INTO employees_new(name,dept_id,salary) values('Sagar',1,70000);
SELECT * FROM stats;
INSERT INTO employees_new(name,dept_id,salary) values('S',1,70000);

-- Create a trigger that saves the entire row of an employee into a backup table before it's deleted.
CREATE TABLE empBackup (
    id INT,
    name VARCHAR(100),
    dept_id INT,
    salary DECIMAL(10,2),
    hire_date DATE
);


DELIMITER //
CREATE TRIGGER BackUpEmp
BEFORE DELETE ON employees_new
FOR EACH ROW
BEGIN 
INSERT INTO empBackup(id,name,dept_id,salary,hire_date) values(OLD.id,OLD.name,OLD.dept_id,OLD.salary,OLD.hire_date);
END //
DELIMITER ;

DROP TRIGGER BackUpEmp;
SELECT * FROM empBackup;
DELETE FROM employees_new where id=12;

-- Enforce a rule: Total salary in a department must not exceed ₹500,000 (before insert/update).
SELECT SUM(salary),dept_name FROM employees_new e INNER JOIN departments d on e.dept_id=d.id group by dept_name; -- engineering got sum = 285000

DELIMITER //
CREATE TRIGGER PreventLargeSalSumOfDept 
BEFORE INSERT ON employees_new 
FOR EACH ROW
BEGIN 
DECLARE newSum INT; 
SELECT SUM(salary) INTO newSum FROM employees_new e INNER JOIN departments d on e.dept_id=d.id where dept_id=NEW.dept_id;
IF newSum + NEW.salary >500000 THEN 
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sum of Salaries in the department exceeding limit';
END IF;  
END //
DELIMITER ;

INSERT INTO employees_new(name,dept_id,salary) values('GMC',1,215001);


-- Track every promotion (when salary increases by more than 30%) in a table promotion_log(emp_id, old_salary, new_salary, promoted_on).
CREATE TABLE promotion_log (
    emp_id INT,
    old_salary INT,
    new_salary INT,
    promoted_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES employees_new(id) ON DELETE SET NULL
);
-- OR CAN DO ON DELETE CASCADE TO ALSO DELETE FROM LOGS

DELIMITER //
CREATE TRIGGER TrackBigPromotions 
AFTER UPDATE 
ON employees_new 
FOR EACH ROW
BEGIN 
IF NEW.salary > OLD.salary + OLD.salary*0.3 THEN
INSERT INTO promotion_log(emp_id,old_salary,new_salary,promoted_on) values(NEW.id,OLD.salary,NEW.salary,NOW());
END IF;
END //
DELIMITER ;

SELECT * FROM employees_new;
UPDATE employees_new SET salary=salary+salary*0.31 where id=4;
SELECT * FROM  promotion_log;

-- Write a trigger that ensures no two employees in the same department can have the exact same salary.
DELIMITER //
CREATE TRIGGER PreventSameDeptSameSal
BEFORE UPDATE 
ON employees_new 
FOR EACH ROW
BEGIN 
IF EXISTS (SELECT 1 FROM employees_new where salary=NEW.salary AND dept_id=NEW.dept_id ) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Two employees in the same dept cannot have same salary';
END IF;
END //
DELIMITER ;
-- this will be a problem since if the person is updating his salary to its current value again the exists query will find itself so instead use  SELECT 1 FROM employees_new where salary=NEW.salary AND dept_id=NEW.dept_id  AND id <> NEW.id
UPDATE employees_new SET salary=58950 where id=6;

-- Maintain a table department_stats(dept_id, total_employees, avg_salary) that gets updated after every insert, update, or delete on employees_new.

CREATE TABLE department_stats(dept_id INT, total_employees INT, avg_salary INT, FOREIGN KEY (dept_id) references departments(id) ON DELETE SET NULL);

DELIMITER //
CREATE TRIGGER DeptStatsonUpdate
AFTER UPDATE  
ON employees_new 
FOR EACH ROW
BEGIN 
DECLARE totalemps INT;
DECLARE avgsal INT;
IF NOT EXISTS (SELECT 1 FROM department_stats where dept_id=NEW.dept_id ) THEN
SELECT COUNT(*),AVG(salary) INTO totalemps,avgsal FROM employees_new where dept_id=NEW.dept_id;
INSERT INTO  department_stats(dept_id,total_employees,avg_salary) values(NEW.dept_id,totalemps,avgsal);
ELSE 
SELECT COUNT(*),AVG(salary) INTO totalemps,avgsal FROM employees_new where dept_id=NEW.dept_id;
UPDATE department_stats SET total_employees=totalemps,avg_salary=avgsal where dept_id=NEW.dept_id;
END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER DeptStatsonInsert
AFTER INSERT
ON employees_new 
FOR EACH ROW
BEGIN 
DECLARE totalemps INT;
DECLARE avgsal INT;
IF NOT EXISTS (SELECT 1 FROM department_stats where dept_id=NEW.dept_id ) THEN
SELECT COUNT(*),AVG(salary) INTO totalemps,avgsal FROM employees_new where dept_id=NEW.dept_id;
INSERT INTO  department_stats(dept_id,total_employees,avg_salary) values(NEW.dept_id,totalemps,avgsal);
ELSE 
SELECT COUNT(*),AVG(salary) INTO totalemps,avgsal FROM employees_new where dept_id=NEW.dept_id;
UPDATE department_stats SET total_employees=totalemps,avg_salary=avgsal where dept_id=NEW.dept_id;
END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER DeptStatsOnDelete
AFTER DELETE 
ON employees_new 
FOR EACH ROW
BEGIN 
DECLARE totalemps INT;
DECLARE avgsal INT;
IF NOT EXISTS (SELECT 1 FROM department_stats where dept_id=OLD.dept_id ) THEN
SELECT COUNT(*),AVG(salary) INTO totalemps,avgsal FROM employees_new where dept_id=OLD.dept_id;
INSERT INTO  department_stats(dept_id,total_employees,avg_salary) values(OLD.dept_id,totalemps,avgsal);
ELSE 
SELECT COUNT(*),AVG(salary) INTO totalemps,avgsal FROM employees_new where dept_id=OLD.dept_id;
UPDATE department_stats SET total_employees=totalemps,avg_salary=avgsal where dept_id=OLD.dept_id;
END IF;
END //
DELIMITER ;

SELECT * FROM department_stats;
INSERT INTO employees_new(name,dept_id,salary) values('Yuvi',2,90000);
SELECT * FROM employees_new;
UPDATE employees_new SET salary=75000 where id=1;
DELETE FROM employees_new where id=14;


-- If an employee's salary is increased by more than 50%, block it unless they have spent at least 3 years in the company.
DELIMITER //
CREATE TRIGGER BlockPromoteIfNotExperience
BEFORE UPDATE ON employees_new
FOR EACH ROW
BEGIN 
IF NEW.salary> OLD.salary+OLD.salary*0.5 AND datediff(NOW(),OLD.hire_date) <1095 THEN
SIGNAL sqlstate '45000' SET MESSAGE_TEXT ='Not experienced enough to get big promotion';
END IF;
END //
DELIMITER ;

drop trigger BlockPromoteIfNotExperience;
UPDATE employees_new SET salary=salary*1.51 where id=11;
UPDATE employees_new SET salary=salary*1.51 where id=6;


-- Allow only 5 new employees to join a department per month.
DELIMITER //
CREATE TRIGGER StopOverHiringMonthly
BEFORE INSERT ON employees_new
FOR EACH ROW
BEGIN 
IF (SELECT COUNT(*) FROM employees_new where month(hire_date)=month(NOW()) AND YEAR(hire_date)=year(now()))=4 THEN
SIGNAL sqlstate '45000' SET message_text= 'Stop overhiring for the month';
END IF;
END //
DELIMITER ;

-- OR 

DELIMITER //
CREATE TRIGGER StopOverHiringMonthly
BEFORE INSERT ON employees_new
FOR EACH ROW
BEGIN 
IF (SELECT COUNT(*) FROM employees_new where month(hire_date)=month(NEW.hire_date) AND YEAR(hire_date)=year(NEW.hire_date))=4 THEN
SIGNAL sqlstate '45000' SET message_text= 'Stop overhiring for the month';
END IF;
END //
DELIMITER ;

INSERT INTO employees_new(name,dept_id,salary) values ('Chiggu',1,67000), ('Skool',3,72000);
INSERT INTO employees_new(name,dept_id,salary) values ('Chinu',2,65000);

-- When a new employee joins with a salary more than 1.5x the department average, trigger a warning and reduce their salary to the average.
DELIMITER //
CREATE TRIGGER SalaryWayAboveAvgSal
BEFORE INSERT ON employees_new
FOR EACH ROW
BEGIN 
IF NEW.salary IS NOT NULL AND NEW.salary>1.5*(SELECT AVG(salary) FROM employees_new where dept_id=NEW.dept_id) THEN
INSERT INTO audit_log(action_type,emp_id,log_time) values('sal way above avg sal insertion attempted',NEW.id,now());
SET NEW.salary=(SELECT AVG(salary) FROM employees_new where dept_id=NEW.dept_id);
END IF;
END //
DELIMITER ;

SELECT AVG(salary),dept_id FROM employees_new group by dept_id;
SELECT * FROM audit_log;

SELECT * FROM employees_new;

SELECT COUNT(*) FROM employees_new where month(hire_date)=month('2024-02-24') AND YEAR(hire_date)=year('2024-02-24');
INSERT INTO employees_new(name,dept_id,salary,hire_date) values('Oreo',2,1.6*50750,'2024-02-24');

-- Block any modification (UPDATE or DELETE) on employees whose names are in a protected list stored in protected_employees(name).
CREATE TABLE protected_employees(name varchar(50) primary key);
INSERT INTO protected_employees value('STRO');

DELIMITER //
CREATE TRIGGER BlockCrudOnEmps
BEFORE DELETE ON employees_new
FOR EACH ROW
BEGIN 
IF EXISTS (SELECT name FROM protected_employees where name=OLD.name) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Protected employee';
END IF;
END //
DELIMITER ; 

SELECT * FROM protected_employees;
DELETE FROM employees_new where id=8;




-- INDEXES
-- INDEXES
-- INDEXES
-- INDEXES
-- INDEXES

SELECT * FROM employees_new where dept_id=2;
EXPLAIN SELECT * FROM employees_new where dept_id=2;

-- non unique index
CREATE INDEX dept_id_idx ON employees_new(dept_id);
EXPLAIN SELECT * FROM employees_new where dept_id=2;

-- unique index
-- primary key index is a type/ special case of unique index. primary key itself is primary key index

CREATE fulltext index emp_name_idx  ON employees_new(name);
SELECT * FROM employees_new where match(name) against ('S');    -- too rare or less than 4 character words are filtered out/ not counted 

DROP INDEX emp_name_idx ON employees_new;


-- DUMMY TABLE FOR INDEXESSSSS
CREATE TABLE seq_1_to_10000 (seq INT PRIMARY KEY AUTO_INCREMENT) ENGINE=MyISAM;
DROP TABLE seq_1_to_10000;

DELIMITER //
CREATE PROCEDURE fill_seq()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 10000 DO
    INSERT INTO seq_1_to_10000 VALUES (i);
    SET i = i + 1;
  END WHILE;
END //
DELIMITER ;

CALL fill_seq();

SELECT * FROM seq_1_to_10000;


CREATE TABLE employees_bulk (name varchar(50) primary key , dept_id int, salary int , hire_date date, foreign key(dept_id) references departments(id));

INSERT INTO employees_bulk (name, dept_id, salary, hire_date)
SELECT 
  CONCAT('Emp', seq),                             -- Emp name
  FLOOR(1 + RAND() * 5),                          -- dept_id 1 to 5
  FLOOR(10000 + RAND() * 90000),                 -- salary between 10k and 100k
  DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 3650) DAY) -- random date in last 10 years
FROM seq_1_to_10000;

SELECT * FROM employees_bulk ORDER BY hire_date;

SELECT * FROM employees_bulk where dept_id=2;
CREATE INDEX dept_idx ON employees_bulk(dept_id);
EXPLAIN SELECT * FROM employees_bulk where dept_id=2;

CREATE fulltext index name_index on employees_bulk(name);

SELECT * FROM employees_bulk where match(name) against ('emp1+'); -- not valid full text index is to search words in sentences not letters in words
-- use like for that instead not index
SELECT * FROM employees_bulk where name like 'Emp1%';

