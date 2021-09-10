--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select Students.Name, Grades.Grade, Students.Marks from Students join Grades on 
Students.Marks between Grades.Min_Mark and Grades.Max_Mark where Grades.Grade>=8 
UNION ALL
select 'NULL', Grades.Grade, Students.Marks from Students join Grades on 
Students.Marks between Grades.Min_Mark and Grades.Max_Mark where Grades.Grade<8 order by 2 desc, 1 asc, 3 asc
;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

select min(rez.PC),min(rez.Printer),min(rez.Laptop) from
(select row_number() over(partition by "type" order by model) as rn
,case "type" when 'PC' then model end PC
,case "type" when 'Printer' then model end Printer
,case "type" when 'Laptop' then model end Laptop
FROM product) rez
group by rn
order by rn

select min(rez.Doctor) as Doctor, min(rez.Professor) as Professor, min(rez.Singer) as Singer,
min(rez.Actor) as Actor from 
(select row_number() over(partition by OCCUPATION order by Name) as rn
,case OCCUPATION when 'Doctor' then Name else 'NULL' end Doctor
,case OCCUPATION when 'Professor' then Name else 'NULL' end Professor
,case OCCUPATION when 'Singer' then Name else 'NULL' end Singer
,case OCCUPATION when 'Actor' then Name else 'NULL' end Actor
from OCCUPATIONS) rez
group by rez.rn
order by rez.rn;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select CITY from (select distinct CITY, left(lower(CITY),1) as vowel from STATION) c 
where c.vowel not in ('a','e','i','o','u');

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select CITY from (select distinct CITY, right(lower(CITY),1) as vowel from STATION) c 
where c.vowel not in ('a','e','i','o','u');

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select CITY from (select distinct CITY, left(lower(CITY),1) as vowel_start, 
                  right(lower(CITY),1) as vowel_end  from STATION) c 
where c.vowel_start not in ('a','e','i','o','u') 
or c.vowel_end not in ('a','e','i','o','u');

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select CITY from (select distinct CITY, left(lower(CITY),1) as vowel_start, 
                  right(lower(CITY),1) as vowel_end  from STATION) c 
where c.vowel_start not in ('a','e','i','o','u') 
and c.vowel_end not in ('a','e','i','o','u');

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name from employee where salary > 2000 and months < 10 order by employee_id;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select Students.Name, Grades.Grade, Students.Marks from Students join Grades on 
Students.Marks between Grades.Min_Mark and Grades.Max_Mark where Grades.Grade>=8 
UNION ALL
select 'NULL', Grades.Grade, Students.Marks from Students join Grades on 
Students.Marks between Grades.Min_Mark and Grades.Max_Mark where Grades.Grade<8 order by 2 desc, 1 asc, 3 asc
;