--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). 
-- Вывод: все данные из laptop, номер страницы, список всех страниц

create view pages_all_products as 
select a.code, a.model, a.speed, a.ram, a.hd ,a.price ,a.screen,
case 
when rn%2 = 0
then 2
else 1
end num_item,
case 
when rn%2 = 0
then rn/2
else (rn/2)+1
end num_page
from
(select *, row_number(*) over (order by code) as rn
from laptop) a

select * from pages_all_products

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров 
-- по типу устройства. Вывод: производитель,

select distinct a.type, cast((a.total_by_type*1.0/a.total*1.0) * 100 as decimal(5,2)) as pct,
(a.total_by_type*1.0)/(a.total*1.0) as pct_2
from
(select *, count(*) over(partition by type) as total_by_type, count(*) over() as total from product) a


select a.maker, a.model, a.type, cast((1.0/a.total_by_type*1.0) * 100 as decimal(5,2)) as pct
from
(select *, count(*) over(partition by type) as total_by_type from product) a

create view distribution_by_type as 
select distinct a.type, cast((a.total_by_type*1.0/a.total*1.0) * 100 as decimal(5,2)) as pct
from
(select *, count(*) over(partition by type) as total_by_type, count(*) over() as total from product) a

select * from distribution_by_type

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму

select * from distribution_by_type

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но у название корабля должно состоять из двух слов

create table ships_two_words as 
select * from ships where "name" like '%_ _%' and "name"  not like '%_ %_ _%'

select * from ships_two_words

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

select * from
(select "name", class from ships 
union
select ship, NULL from outcomes where ship <> ALL(select "name" from ships )) a
where a.class is null and a."name" like 'S_%'

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' 
--и три самых дорогих (через оконные функции). Вывести model

select printer.model from printer 
join product 
on printer.model = product.model 
where product.maker = 'A' 
and printer.price > 
(select AVG(printer.price) from printer join product on printer.model = product.model where product.maker = 'C')
union
select a.model from 
(select model, price, row_number(*) over (order by price desc) rn from printer) a
where a.rn <=3 
