--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. 
--Вывести: класс и число потопленных кораблей.

with sunk_ships as (select ship from outcomes where "result" = 'sunk')

select class, count(name) from ships 
join sunk_ships on ships."name" = sunk_ships.ship
group by class

--Классов немного, т.к. потопленные корабли, в основном, отсутствуют в таблице ships, а есть только в outcomes

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. 
--Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. 
--Вывести: класс, год.

with class_min_launch1 as (
select class, launched
from ships
where ships."name" = ships.class
),
class_min_launch2 as (
select class, min(launched) as min_launch
from ships
group by class
)

select ships.class, 
case 
	when class_min_launch1.launched is not null
	then cast(class_min_launch1.launched as varchar(4))
	when class_min_launch2.min_launch is not null
	then cast(class_min_launch2.min_launch as varchar(4))
	else 'не понятна дата спуска'
end launch
from ships
left join class_min_launch1 on ships.class = class_min_launch1.class
left join class_min_launch2 on ships.class = class_min_launch2.class

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

with sunk_ships as (select ships.class from outcomes 
join ships on ships."name" = outcomes.ship
where outcomes."result" = 'sunk')

select sunk_ships.class, a.count_ships from sunk_ships
join 
(SELECT class, count(name) as count_ships,
case 
	when count(name) > 2
	then 1
	else 0
end count_ships_flag
FROM ships 
group by class) a on sunk_ships.class = a.class
where a.count_ships_flag = 1

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения 
--(учесть корабли из таблицы Outcomes).

select ship
from outcomes where ship in (
select distinct classes1.class from classes as classes1 
where numguns >= all (select numguns from classes where classes.displacement = classes1.displacement)
and (
select  
case 
	when count(displacement) > 1
	then 1
	else NULL
end cnt_displacement
from classes 
where classes.displacement = classes1.displacement
group by displacement
) is not null)
union
select ships."name"
from ships where ships.class in (
select distinct classes1.class from classes as classes1 
where numguns >= all (select numguns from classes where classes.displacement = classes1.displacement)
and (
select  
case 
	when count(displacement) > 1
	then 1
	else NULL
end cnt_displacement
from classes 
where classes.displacement = classes1.displacement
group by displacement
) is not null)

select ship from outcomes where ship <> all (select "name" from ships) -- корабли, которые есть только в outcomes
select * from ships where class in (select ship from outcomes where ship <> all (select "name" from ships))  -- данных по кораблям, 
--которые есть в таблице outcomes нет в таблице ships если искать только по соответствию класса (т.е. как для головного корабля)  
select * from ships where class = 'Tennessee'
select * from classes where class <> all (select class from ships) -- классы, которые есть только в classes

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и 
--с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

select distinct maker from product where maker in
(select maker from product where model in 
(select distinct model from PC where speed =
(select max(speed) from PC 
where ram = (select min(ram) from PC))
and ram = (select min(ram) from PC)))
and "type" = 'Printer'

--или так

with min_ram as (
select min(ram) from PC
),
max_speed as (
select max(speed) from PC where ram = (select * from min_ram) 
),
model_with_min_ram_and_max_speed as (
select distinct model from PC where speed = (select * from max_speed) 
and ram = (select * from min_ram) 
),
maker_super_PC as (
select maker from product where model in (select * from model_with_min_ram_and_max_speed)
)
select distinct maker 
from product 
where maker in (select * from maker_super_PC)
and "type" = 'Printer'

