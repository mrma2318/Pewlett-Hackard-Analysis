# Pewlett-Hackard-Analysis
## Overview: Generate a list of all employees eligible for the retirement package, determine the number of retiring employees based on title, and those eligible to participate in a mentorship program.

### The purpose of this analysis is to assist Pewlett Hackard identify the number of upcoming retirements so they can prepare ahead. I will be using SQL to apply data modeling, engineering, and analysis skills to help Bobby build an employee database with the information being requested. 

## Analysis
- Before I could start my analysis, I needed to identify relationships between the CSV files Bobby provided me. I needed to understand the commonalities between the files, such as the primary keys and foreign keys, to understand the connections. The primary keys provided the connection between datasets, while the foreign keys were unique identifies that referenced other dataset's primary key. 

- Once I got a better understanding of the connections between the data files, I needed to create a solid foundation of the data. I completed this by modeling the data into entity relationship diagrams. This will help in navigating through the relationships more easily and be used as a reference to create tables of the data in SQL, Table 1.

### Table 1

![Employee DB](https://github.com/mrma2318/Pewlett-Hackard-Analysis/blob/c91d6a7cfb871c61f438e19455ec8a1920d1957f/EmployeeDB.png)

### Table 2

![Employee DB2](https://github.com/mrma2318/Pewlett-Hackard-Analysis/blob/c91d6a7cfb871c61f438e19455ec8a1920d1957f/EmployeeDB2.png)

- Now I can start creating tables in SQL for each CSV file. To create tables in SQL, I need to use to the CREATE TABLE syntax and provide a name for each table. Then, within the parentheses, I need to specify the column names and tell SQL that no null fields will be allowed when importing by using the NOT NULL syntax. I also need to identify in the table what my primary key is and add the unique constraints. After creating tables of all the CSV files, I wanted to make sure my tables were successfully created before I could upload the data into the tables. Therefore, I used the SELECT statement to run a query to show the result of the tables in the Data Output tab. 

- I've created tables modeled after our entity relationship diagrams, and I can import the CSV files to their corresponding tables. So now that the data has been properly imported, I can start running analysis. The first analysis I needed to complete was to find the number of retiring employees by their title. To do this I needed to get the information on the employee number, their first name, last name, their title, from date, and to date vales. From the employees dataset, I wanted to join the titles dataset on the employee number, where employees were born between 1952-01-01 and 1955-12-31. Once I got this information I could then save it into it's own query and export it as a CSV file called [retirement_titles.csv](https://github.com/mrma2318/Pewlett-Hackard-Analysis/blob/c91d6a7cfb871c61f438e19455ec8a1920d1957f/Data/retirement_titles.csv) and order the output in ascending order by employee number. 

However, when looking at the [retirement_titles.csv](https://github.com/mrma2318/Pewlett-Hackard-Analysis/blob/c91d6a7cfb871c61f438e19455ec8a1920d1957f/Data/retirement_titles.csv) file, you can see there are duplicates. Therefore, in order to remove those duplicates, I used the DISTINCT ON() function for employee number from the retirement_titles.csv I just created. I also wanted to look at employees that were still employed there, so I also filtered the data to show only those with a to date of 9999-01-01. Then I saved the new dataset in another query and exported it as a CSV file called [unique_titles.csv](https://github.com/mrma2318/Pewlett-Hackard-Analysis/blob/c91d6a7cfb871c61f438e19455ec8a1920d1957f/Data/unique_titles.csv)

-- Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) rt.emp_no,
rt.first_name,
rt.last_name,
rt.title

INTO unique_titles
FROM retirement_titles AS rt
WHERE (rt.to_date = '9999-01-01')
ORDER BY rt.emp_no ASC, rt.to_date DESC;

- I have all the employees and their most reecent job titles that are getting ready to retire. However, the list is very long, so in order to find the total number of employees that are retiring I can use the COUNT() function. 

-- Retrieve the number of employees by their most recent job title
SELECT COUNT(title),title 
INTO retiring_titles
FROM unique_titles 
GROUP BY title
ORDER BY COUNT(title) DESC;

- Bobby also wanted me to create a mentorship-eligibility table that holds the current employees who were born between January 1, 1965 and December 31, 1965. Therefore, I needed to get the same variables I did to get the number of employees by title and use the DISTINCT ON() function based on employee number. However, I needed to join the tables not only on titles between the employees and titles CSV files, but also on employee number between the employees and dept_emp CSV files. 

- In addition, I needed to organize the data where employees are still employeed and born between 1965-01-01 and 1965-12-31 to get the employees eligible to be a mentor. Once I got the data, I was able to save it into a table called mentorship_eligibility and export it as a CSV called [mentorship_eligibility.csv](https://github.com/mrma2318/Pewlett-Hackard-Analysis/blob/c91d6a7cfb871c61f438e19455ec8a1920d1957f/Data/mentorship_eligibility.csv). 

-- Create a mentorship-eligbility table
SELECT DISTINCT ON (emp_no) e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date,
    titles.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles
ON (e.emp_no = title.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no ASC;

## Results
- There are four major points you can make from the analysis. First, we can conclude that there are 133,776 employees are that are getting ready to retire that were born between 1952-01-01 and 1955-12-31. However, that's a lot of employees, and some employees are in the list multiple times because they've progressed through the company and their titles have changed. 

- Therefore, the next point we can make from the analysis is that we organized the data to reflect all employees on their current title. This provided us then with a total of 72,458 employees still employed with their most recent title that are getting ready to retire. 

- Another point we can gather is that the 72,458 employees that are getting ready to retire, is total number of employees across all the departments at the company. Thus, the next major point to consider is how many employees are retiring in each department. Since the number of employees retiring is a great amount within the company, looking at each department will break up that number. This will provide a more reasonable number of employees retiring per department than looking at the overall total. 

- The last point we can gather from this analysis is that there are 1,549 employees that are eligible to be mentors. This means that employees who were born between January 1, 1965 and December 31, 1965, are eligible to mentor new incoming employees that will fill some of the upcoming open positions. 

## Summary
- To summarize, there are 72,458 employees that will be retiring. This indicates that overall there will also be 72,458 positions that will need to be filled as employees begin to retire. Since this number is across all the departments, I thought it would be beneficial to look at the number of employees retiring per department, [additional_challenge_queries.sql](https://github.com/mrma2318/Pewlett-Hackard-Analysis/blob/13a0d445f6c2c94bc66af06cc3953921344ac64d/additional_challenge_queries.sql). Overall, there are nine departments at the Pewlett Hackard organization. See Table 3 for the number of employees retiring per department. 

### Table 3: Number of Employees Retiring Per Dept

![Department Count](https://github.com/mrma2318/Pewlett-Hackard-Analysis/blob/6306e71a6c2c3227f4ba379a35d91cc75c798e7f/Resources/Dept_Count.png)

- Now we can see how many employees are leaving per department to get a better understanding of how many roles will need to be filled by department. For example, the Development department will have 18,368 positions (25% of the overall positions) to fill as employees begin to retire. 

- In addition, to know if we have enough mentors eligible to mentor incoming employees filling the open positions I wanted to know how many mentors were eligible per department as well. Overall, we have 1,549 eligible mentors for the mentorship. See Table 4 for the breakdown of eligible mentors per department. 

### Table 4: Eligible Mentors Per Dept

![Mentor Count](https://github.com/mrma2318/Pewlett-Hackard-Analysis/blob/6306e71a6c2c3227f4ba379a35d91cc75c798e7f/Resources/Mentor_dept_count.png)

- From Table 4, you can see that the Development department has 396 employees that are mentorship eligible (25% of the overall eligible mentors). Comparing the two tables and looking at the percentage of mentors compared to the percentage of employees per department, I would say we have enough qualified mentors to mentor the next generation at Pewlett Hackard. 