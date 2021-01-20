-- Dropping Tables
DROP TABLE public.departments cascade;
DROP TABLE public.dept_emp cascade;
DROP TABLE public.dept_manager cascade;
DROP TABLE public.employees cascade;
DROP TABLE public.salaries cascade;
DROP TABLE public.titles cascade;

-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/4jNKTT
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INTEGER   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INTEGER   NOT NULL,
    "title_id" VARCHAR   NOT NULL,
    "birth_date" Date   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" Date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INTEGER   NOT NULL,
    "salary" INTEGER   NOT NULL
);

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);


ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

-----------------------------------------------------------------------------------------------------

--1. List the following details of each employee: employee number, last name, first name, sex, and salary

select employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
from employees
left join salaries on (employees.emp_no=salaries.emp_no);

--2. List first name, last name, and hire date for employees who were hired in 1986.

select employees.first_name, employees.last_name, employees.hire_date
from employees
where employees.hire_date < '01/01/1987' and employees.hire_date > '12/31/1985' ;

--3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT departments.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM dept_manager 
JOIN departments ON (departments.dept_no = dept_manager.dept_no)
JOIN employees ON (dept_manager.emp_no = employees.emp_no);

--4. List the department of each employee with the following information: employee number, last name, first name, and department name.

select employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
from dept_emp
join departments on (departments.dept_no = dept_emp.dept_no)
join employees on (dept_emp.emp_no = employees.emp_no);

--5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."

Select employees.last_name, employees.first_name, employees.sex
from employees
where employees.first_name = 'Hercules' and last_name like 'B%';

--6. List all employees in the Sales department, including their employee number, last name, first name, and department name.

select employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
from dept_emp
join employees on (employees.emp_no = dept_emp.emp_no)
join departments on (departments.dept_no = dept_emp.dept_no)
where departments.dept_name = 'Sales';

--7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

select employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
from dept_emp
join employees on (employees.emp_no = dept_emp.emp_no)
join departments on (departments.dept_no = dept_emp.dept_no)
where departments.dept_name = 'Sales' or departments.dept_name = 'Development' ;

--8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

select employees.last_name, count(employees.last_name)
from employees
group by last_name
order by count(employees.last_name) desc;

--9.## Epilogue "Search your ID Number"..
select employees.last_name, employees.first_name
from employees
where employees.emp_no = 499942