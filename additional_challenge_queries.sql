SELECT DISTINCT ON (emp_no) e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
	de.dept_no,
    de.from_date,
    de.to_date,
    titles.title,
    d.dept_name
-- INTO dept_info
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles
ON (e.emp_no = titles.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no ASC;

-- Count number of people retiring by department
SELECT COUNT(dept_name),dept_name 
INTO dept_count
FROM dept_info 
GROUP BY dept_name
ORDER BY COUNT(dept_name) DESC;

-- Create a mentorship-eligbility table
SELECT DISTINCT ON (emp_no) e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date,
    titles.title,
    d.dept_name
-- INTO mentorship_dept
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles
ON (e.emp_no = titles.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no ASC;

SELECT COUNT(dept_name), dept_name
INTO mentor_count
FROM mentorship_dept
GROUP BY dept_name
ORDER BY COUNT(dept_name) DESC;