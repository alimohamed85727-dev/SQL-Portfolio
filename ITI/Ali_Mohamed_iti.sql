     
         --بسم الله الرحمن الرحيم--
use[ITI]
go
--1 Retrieve number of students who have a value in their age.
select count (St_Id) as [num students]
from Student
where St_Age is not null

----------------------------------------------

--2 Get all instructors Names without repetition.
select distinct Ins_Name as [instructors name]
from Instructor

----------------------------------------------

--3 Display student with the following Format (use isNull function):
-- Required Columns: [Student ID], [Student Full Name], [Department name]
select  
St_Id as [Student ID] ,
concat(St_Fname,' ',St_Lname) as [Student full name] ,
isnull (d.Dept_Name,'no_depart')  as [Department Name]
from Student s left join Department d 
on s.Dept_Id=d.Dept_Id 

--------------------------------------------------

--4 Display instructor Name and Department Name.
-- Note: Display all the instructors if they are attached to a department or not.
select 
Ins_Name as [Instructors Name],
Dept_Name as [Department Name]
from Instructor i left join Department d
on i.Dept_Id = d.Dept_Id

-----------------------------------------------------

--5 Display student full name and the name of the course he is taking.
-- Note: For only courses which have a grade.
select 
St_Fname +' '+ St_Lname as [student full name],
Crs_Name as [Course Name]
from Student s inner join Stud_Course sc
on s.St_Id=sc.St_Id
inner join Course c 
on c.Crs_Id=sc.Crs_Id
where Grade is not null

---------------------------------------------------

--6 Display number of courses for each topic name.
select Top_Name,count(Crs_Id) as [number of courses]
from Topic t right join Course c
on t.Top_Id=c.Top_Id
group by Top_Name

----------------------------------------------------

--7 Display max and min salary for instructors.
select
max(Salary) as [maximum],
min(Salary) as [minimum]
from Instructor

------------------------------------------------------

--8 Display instructors who have salaries less than the average salary of all instructors.
select 
Ins_Name as [instructors_Name], Salary
from Instructor
where  Salary < (select avg(Salary) from Instructor)
-------------------------------------------------------

--9 Display the Department name that contains the instructor who receives the minimum salary.
select
d.Dept_Name as [Department name], i.Salary
from Department d inner join Instructor i
on d.Dept_Id=i.Dept_Id
where i.Salary=(select min(Salary) from Instructor)

--------------------------------------------------------

--10 Select max two salaries in instructor table.
select
top(2) Salary as [max two salaries]
from instructor
order by Salary desc

--------------------------------------------------------

--11 Select instructor name and his salary but if there is no salary display instructor bonus keyword. “use coalesce Function”
select Ins_Name as [Instructor name],
coalesce (cast( Salary as varchar(20)),'instructor bonus') as [Salary Statue]
from Instructor 

----------------------------------------------------------

--12 Select Average Salary for instructors.
select avg(Salary) as [Average Salary]
from Instructor

------------------------------------------------------------

--13 Select Student first name and the data of his supervisor
select 
s.St_Fname as [Student first name],
super.St_Fname as [Supervisor first name]
from Student s left join Student super
on s.St_super = super.St_Id

---------------------------------------------------------------

--14 Write a query to select the highest two salaries in Each Department for instructors
-- who have salaries. “using one of Ranking Functions”
select Ins_Name,Dept_Id,Salary
from
(select Ins_Name,Dept_Id,Salary,
dense_rank() over (partition by Dept_Id order by Salary desc) as [Salary Rank]
from Instructor) as [ranked Table]
where [Salary Rank] <=2

-------------------------------------------------------------

--15 Write a query to select a random student from each department.
-- “using one of Ranking Functions”
select St_Fname,Dept_Id
from
(select St_Fname,Dept_Id,
row_number() over (partition by Dept_Id order by newid()) as [each depart] 
from Student) as [random student]
where [each depart]=1