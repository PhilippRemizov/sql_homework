--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). 
--Вывести: model, maker, type

SELECT model, maker, "type" FROM product

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, 
--у кого цена вышей средней PC - "1", у остальных - "0"

select *,
case 
	when price > (select AVG(price) from PC)
	then 1
	else 0
end flag
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

select outcomes.ship from outcomes 
left join ships on outcomes.ship = ships."name" 
where ships.class is null
union
select ships."name" from ships 
where ships.class is null

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

select "name" from battles 
where cast(left(cast("date" as varchar(20)),4) as int) <> all (select distinct launched from ships)

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select battle from outcomes where ship = any 
(select "name" from ships where class = 'Kongo')

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, 
--если стоимость больше > 300. Во view три колонки: model, price, flag

create view all_products_flag_300 as
select a.*,
case 
	when a.price > 300
	then 1
	else 0
end as flag
from
(select model, price from pc
union
select model, price from printer
union
select model, price from laptop) a

select * from all_products_flag_300

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, 
--если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as

with all_products_ as (
select model, price from pc
union
select model, price from printer
union
select model, price from laptop
)

select all_products_.*,
case 
	when all_products_.price > (select avg(price) from all_products_)
	then 1
	else 0
end as flag
from all_products_

select * from all_products_flag_avg_price

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней 
--по принтерам производителя = 'D' и 'C'. Вывести model

with avg_price_ as (
select AVG(price) as AVG_price  
from product 
join printer on product.model = printer.model 
where maker in ('D','C'))

select product.model from product 
join printer on product.model = printer.model
where maker = 'A' and price > (select AVG_price from avg_price_)

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней 
--по принтерам производителя = 'D' и 'C'. Вывести model

with avg_price_ as (
select AVG(price) as AVG_price  
from product 
join printer on product.model = printer.model 
where maker in ('D','C'))

select model from 
(select product.model, printer.price from product join printer on product.model = printer.model where maker = 'A'
union
select product.model, laptop.price from product join laptop on product.model = laptop.model where maker = 'A'
union
select product.model, pc.price from product join pc on product.model = pc.model where maker = 'A') a
where a.price > (select AVG_price from avg_price_)

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

select avg(price) from
(select product.model, printer.price from product join printer on product.model = printer.model where maker = 'A'
union
select product.model, laptop.price from product join laptop on product.model = laptop.model where maker = 'A'
union
select product.model, pc.price from product join pc on product.model = pc.model where maker = 'A') a

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. 
--Во view: maker, count

create view count_products_by_makers as 

select maker, count(*) from product group by maker

select * from count_products_by_makers 

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

--готово (в файле ipynb).

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

CREATE TABLE printer_updated AS
SELECT * FROM printer where
model <> all (select product.model from product join printer on product.model = printer.model where maker = 'D')

select * from printer_updated

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя 
--(название printer_updated_with_makers)

create view printer_updated_with_makers as 
select printer_updated.*, product.maker from printer_updated join product on product.model = printer_updated.model

select * from printer_updated_with_makers

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). 
--Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

CREATE OR REPLACE view sunk_ships_by_classes as 
select coalesce(ships.class,'0') as class, count(outcomes.ship) from outcomes left join ships on outcomes.ship = ships."name"
where outcomes."result" = 'sunk'
group by ships.class

select * from sunk_ships_by_classes

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

select * from sunk_ships_by_classes

--готово (в файле ipynb)

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: 
--если количество орудий больше или равно 9 - то 1, иначе 0

CREATE TABLE classes_with_flag AS
SELECT *,
case 
when numguns >= 9
then 1
else 0
end flag
FROM classes

select * from classes_with_flag

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

select country, count(class) from classes group by country

--готово (в файле ipynb)

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

select count(*) from
(select ship from outcomes
union
select name from ships) a
where a.ship like 'O%' or a.ship like 'M%' 

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select count(*) from
(select ship from outcomes
union
select name from ships) a
where a.ship like '% %' and a.ship not like '% % %' 

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

select launched, count("name") from ships group by launched order by launched

--готово (в файле ipynb)
