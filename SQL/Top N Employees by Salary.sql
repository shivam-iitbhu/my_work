-- Top 3 Employees by Salary in the entire company
SELECT emp_id, salary
FROM employees
ORDER BY salary DESC
LIMIT 3;

-- Top 3 Employees by Salary (Department-wise)
SELECT department, emp_id, salary, ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS rn
FROM employees
HAVING rn <= 3
ORDER BY department, emp_id, salary;
