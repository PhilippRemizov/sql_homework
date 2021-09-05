--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). 
-- В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

select * from laptop

create table table1 as
select  cast(random()*1000 as int) as ind1, 
cast(random()*1000 as int) as ind2, 
cast(random()*1000 as int) as ind3
from generate_series(1,1000)

select * from table1
drop table table1

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select distinct Email 
from
(select Email, count(*) over (partition by Email) as cnt 
from Person) a
where a.cnt>1

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

select e1.Name as Employee from Employee e1 join Employee e2 
on e1.ManagerId = e2.Id
where e1.Salary > e2.Salary

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

Select cast(Score as NUMERIC(4,2)) as "Score",  
dense_rank () over (ORDER BY score desc) as "Rank"
from Scores

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select Person.FirstName as "FirstName", 
Person.LastName as "LastName",
Address.City as "City",
Address.State as "State"
from Person left join Address on Person.PersonId = Address.PersonId


