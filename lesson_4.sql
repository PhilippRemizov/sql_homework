--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson4)
-- Корабли: Вывести список кораблей, у которых начинается с буквы "S"

SELECT *
FROM Ships
WHERE class NOT LIKE '%go' 
and class LIKE '%o' ;

SELECT *
FROM Ships
WHERE "name" LIKE 'S%' ;

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название: pc_with_flag_speed_price) над таблицей PC c флагом: flag = 1 для тех,
-- у кого speed > 500 и price < 900, для остальных flag = 0

CREATE OR REPLACE VIEW films_recent AS
  SELECT * FROM films WHERE date_prod >= '2002-01-01';


CREATE OR REPLACE VIEW pc_with_flag_speed_price_second_stream as
select *, 
case 
	when speed > 500 and price < 900
	then 1
	else 0
end as flag
from PC;

select * from pc_with_flag_speed_price_second_stream

drop view pc_with_flag_speed_price_second_stream

--task3  (lesson4)
-- Компьютерная фирма: Сделать view (название: pc_maker_a) со всеми товарами производителя A. 
--В view должны быть следующие колонки: model, price

CREATE OR REPLACE VIEW pc_maker_a_second_stream as
select product.model, 
case 
when PC.model is not null
then PC.price
when laptop.model is not null
then laptop.price
when printer.model is not null
then printer.price
else 0
end price
from product 
left join PC on product.model = PC.model
left join laptop on product.model = laptop.model
left join printer on product.model = printer.model
where maker = 'A'

select * from pc_maker_a_second_stream

--task4 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы laptop (название: laptop_under_1000) и удалить из нее все товары с ценой выше 1000.

CREATE TABLE laptop_second_stream AS
TABLE laptop;

select * from laptop_second_stream

delete from laptop_second_stream where price >1000

--task4.5 
-- all_products - необходимо сделать таблицы со всеми товарами. В таблице должны быть следуюшие колонки: maker, price, model

create table all_products as 
select product.model, 
case 
when PC.model is not null
then PC.price
when laptop.model is not null
then laptop.price
when printer.model is not null
then printer.price
else 0
end price,
product.maker
from product 
left join PC on product.model = PC.model
left join laptop on product.model = laptop.model
left join printer on product.model = printer.model

select * from all_products

--task5 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы (название: all_products) со средней стоимостью всех продуктов, 
--с максимальной ценой и количеством по каждому производителю. (дубликаты можно учитывать).

CREATE TABLE all_products_copy as
select all_products.maker, 
avg(all_products.price) as avg_price, 
max(all_products.price) as max_price,
count(all_products.model) as count
from all_products
group by all_products.maker;

select * from all_products_copy

--task6 (lesson4)
-- Компьютерная фирма: Построить по all_products график в colab/jupyter (X: maker, Y: средняя цена)

 --(в файле ipynb)

--task7 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы (название: all_products) со средней стоимостью всех продуктов, 
--с максимальной ценой продукта и количеством продуктов по каждому производителю. (дубликаты можно учитывать).

--task8 (lesson4)
-- Компьютерная фирма: Сделать view (название products_price_categories), в котором по всем продуктам 
--нужно посчитать количество продуктов всего в зависимости от цены:
-- Если цена > 1000, то category_price = 2
-- Если цена < 1000 и цена > 500, то  category_price = 1
-- иначе category_price = 0
-- Вывести: category_price, count

create view products_price_categories as 
select a.category_price, count(a.category_price) as count
from 
(select *, 
case
when price > 1000
then 2
when price < 1000 and price > 500
then 1
else 0
end as category_price
from all_products) a
group by a.category_price

select * from products_price_categories

--task9 (lesson4)
-- Сделать предыдущее задание, но дополнительно разбить еще по производителям 
--(название products_price_categories_with_makers). Вывести: category_price, count, price

create view products_price_categories_with_makers as 
select a.category_price, a.maker, count(a.category_price) as count
from 
(select *, 
case
when price > 1000
then 2
when price < 1000 and price > 500
then 1
else 0
end as category_price
from all_products) a
group by a.category_price, a.maker

select * from products_price_categories_with_makers

--task10 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по каждому производителю график (X: category_price, Y: count)

--Готово (в файле ipynb)

--task11 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по A & D график (X: category_price, Y: count)

select * from products_price_categories_with_makers where maker in ('A','D')

--task12 (lesson4)
-- Корабли: Сделать копию таблицы ships, но у название корабля не должно начинаться с буквы N (ships_without_n)

CREATE TABLE ships_without_n AS
SELECT * FROM ships WHERE
"name" not like 'N_%';

select * from ships_without_n
