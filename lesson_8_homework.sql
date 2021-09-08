--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

select d.Name as "Department", e.Name as "Employee", 
e.Salary as "Salary"
from Employee e join Department d 
on e.DepartmentId = d.Id
where 3>
(
    select count(distinct e2.Salary)
    from Employee e2
    where e2.Salary > e.Salary and e.DepartmentId = e2.DepartmentId
)

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

select member_name, FM.status, sum(amount*unit_price) as costs 
from FamilyMembers FM join Payments PAY
on FM.member_id = PAY.family_member
where date between '2005-01-01' and '2006-01-01'
group by member_name, FM.status

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

select Passenger.name
from Passenger 
group by Passenger.name
having count(Passenger.id) > 1

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(*) as count from student where first_name = 'Anna'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

select count(classroom) as count
from schedule 
where date = '2019-09-02'

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(*) as count from student where first_name = 'Anna'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

select round(a.age_avg) as age 
from 
(select AVG(YEAR(NOW())-YEAR(birthday)) as age_avg from FamilyMembers) a

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

select GoodTypes.good_type_name, sum(Payments.amount*Payments.unit_price)  as costs
FROM Payments join goods 
on Payments.good = goods.good_id
join GoodTypes on goods.type = GoodTypes.good_type_id
where year(Payments.date) = '2005'
group by GoodTypes.good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

select case 
when month(a.birthday)>month(NOW())
then YEAR(NOW())-YEAR(birthday)-1
when month(a.birthday)=month(NOW()) and day(a.birthday)>day(NOW())
then YEAR(NOW())-YEAR(birthday)-1
when month(a.birthday)=month(NOW()) and day(a.birthday)<day(NOW())
then YEAR(NOW())-YEAR(birthday)
when month(a.birthday)<month(NOW())
then YEAR(NOW())-YEAR(birthday)
else 500 end as year
from 
(select MAX(birthday) as birthday from Student) a

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

select case 
when month(a.birthday)>month(NOW())
then YEAR(NOW())-YEAR(birthday)-1
when month(a.birthday)=month(NOW()) and day(a.birthday)>day(NOW())
then YEAR(NOW())-YEAR(birthday)-1
when month(a.birthday)=month(NOW()) and day(a.birthday)<day(NOW())
then YEAR(NOW())-YEAR(birthday)
when month(a.birthday)<month(NOW())
then YEAR(NOW())-YEAR(birthday)
else 500 end as max_year
from 
(select min(birthday) as birthday from student where id in
(select student from student_in_class where class in 
(select id from Class where name like '10__'))) a

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

select FamilyMembers.status, FamilyMembers.member_name, 
SUM(Payments.amount*Payments.unit_price) as costs 
from Payments join FamilyMembers 
on Payments.family_member = FamilyMembers.member_id
where good in
(select good_id from Goods where type =
(select good_type_id from GoodTypes 
where good_type_name = 'entertainment'))
group by FamilyMembers.status, FamilyMembers.member_name

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

delete from Company where id in
(select company from Trip group by Company having count(id) = 
(select min(a.cnt) as min_cnt from 
(select company, count(id) as cnt from Trip group by Company) a))

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

select classroom from Schedule 
group by classroom
having count(*) = (select max(a.count) from 
(select classroom, count(*) as count from Schedule group by classroom order by count(*)) a)

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

Select last_name from Teacher where id in 
(select teacher from Schedule where subject = 
(select id from Subject where name  = 'Physical Culture'))
order by last_name 

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

select CONCAT(last_name,'.',left(upper(first_name), 1),'.',left(upper(middle_name), 1),'.') as name
from Student
order by name asc
