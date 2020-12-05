CREATE TABLE "title" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_title" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" int   NOT NULL
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "title" ("title_id");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");
----------------------------------------------------------
-- -- DROP TABLE depts_employee_manager;
-- -- CREATE TABLE depts_employee_manager AS 
-- SELECT department.dept_no, department.dept_name, dept_emp.emp_no
-- FROM department
-- INNER JOIN dept_emp ON department.dept_no=dept_emp.dept_no
-- INNER JOIN dept_manager ON department.dept_no=dept_manager.dept_no;
-- -- SELECT * FROM depts_employee_manager;
-- ------------------------------------
-- -- DROP TABLE employee_info;
-- -- CREATE TABLE employee_info AS 
-- SELECT employees.emp_no, employees.emp_title_id, employees.birth_date, employees.first_name, employees.last_name, employees.sex, employees.hire_date, salaries.salary
-- FROM employees
-- INNER JOIN salaries ON employees.emp_no=salaries.emp_no;
-- -- SELECT * FROM employee_info;
-- ----------------------------------------------------
-- -- DROP TABLE employee_title_salary;
-- -- CREATE TABLE employee_title_salary AS
-- SELECT employees.emp_no, employees.emp_title_id, employees.birth_date, employees.first_name, employees.last_name, 
-- 	employees.sex, employees.hire_date, employees.salary, titles.title
-- FROM title
-- INNER JOIN employees ON title.title_id=employees.emp_title_id;
-- -- SELECT * FROM employee_title_salary;
-- ---------------------------------------------------
-- -- DROP TABLE total_employee;
-- -- CREATE TABLE total_employee AS
-- SELECT employee_title_salary.emp_no, employee_title_salary.emp_title_id, employee_title_salary.birth_date, employee_title_salary.first_name, employee_title_salary.last_name, 
-- 	employee_title_salary.sex, employee_title_salary.hire_date, employee_title_salary.salary, employee_title_salary.title, 
-- 	depts_employee_manager.dept_no, depts_employee_manager.dept_name
-- FROM employee_title_salary
-- INNER JOIN depts_employee_manager ON depts_employee_manager.emp_no=employee_title_salary.emp_no;
-- -- SELECT * FROM total_employee;
---------------------------------------------------------

---List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary

FROM employees
	LEFT JOIN salaries
	ON (employees.emp_no = salaries.emp_no)
ORDER BY employees.emp_no;

-- List first name, last name, and hire date for employees who were hired in 1986.

SELECT first_name, last_name, hire_date
FROM employees
WHERE date_part('year',hire_date)=1986;

-- List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.

SELECT dept_manager.dept_no, dept_manager.emp_no, departments.dept_name, employees.last_name, employees.first_name
FROM dept_manager
	INNER JOIN departments ON (dept_manager.dept_no = departments.dept_no)
	INNER JOIN employees ON (dept_manager.emp_no = employees.emp_no);

-- List the department of each employee with the following information: employee number, last name, first name, and department name.

SELECT departments.dept_name, employees.emp_no, employees.last_name, employees.first_name
FROM employees
	INNER JOIN dept_emp ON (employees.emp_no = dept_emp.emp_no)
	INNER JOIN departments ON (dept_emp.dept_no = departments.dept_no);

-- List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."

SELECT first_name, last_name, sex
FROM employees
WHERE first_name='Hercules'
AND last_name like 'B%';

-- List all employees in the Sales department, including their employee number, last name, first name, and department name.

SELECT employees.emp_no, employees.first_name, employees.last_name, departments.dept_name
FROM employees
	INNER JOIN dept_emp ON (employees.emp_no = dept_emp.emp_no)
	INNER JOIN departments ON (dept_emp.dept_no = departments.dept_no)
WHERE departments.dept_name='Sales';

-- List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
	INNER JOIN dept_emp ON (employees.emp_no = dept_emp.emp_no)
	INNER JOIN departments ON (dept_emp.dept_no = departments.dept_no)
WHERE departments.dept_name IN ('Sales', 'Development');

-- In descending order, list the frequency count of employee last names, i.e., how many employees share each last name

SELECT last_name, COUNT(last_name)
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;