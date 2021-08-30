--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index как объединение всех данных по ключу code (union all).
-- Сделать индекс по полю type

create table all_products_with_index as 
select printer.price, printer.code, product.maker, product.model, product."type" from product join printer on product.model = printer.model
union all
select laptop.price, laptop.code, product.maker, product.model, product."type" from product join laptop on product.model = laptop.model
union all
select pc.price, pc.code, product.maker, product.model, product."type" from product join pc on product.model = pc.model

select * from all_products_with_index
CREATE INDEX type_idx ON all_products_with_index (type)

--task2  (lesson6)
--Компьютерная фирма: Вывести список всех уникальных PC и производителя с ценой выше хотя бы одного принтера. 
--Вывод: model, maker

select distinct product.model, product.maker 
from product join pc on product.model = pc.model
where pc.price > (select min(price) from printer)

--task3  (lesson6)
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model

select b.model
from
(select a.*, row_number() over (order by price desc) num_price from 
(select model, price from printer
union
select model, price from laptop
union
select model, price from pc) a) b
where num_price = 1

--task4  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task4 как объединение всех данных по ключу code (union all) 
-- и сделать флаг (flag) по цене > максимальной по принтеру. Сделать индекс по flag

create table all_products_with_index_task4 as
select printer.price, printer.code, product.maker, product.model, product."type",
case 
when printer.price > (select max(price) from printer)
then 1
else 0
end flag
from product join printer on product.model = printer.model
union all
select laptop.price, laptop.code, product.maker, product.model, product."type", 
case 
when laptop.price > (select max(price) from printer)
then 1
else 0
end flag
from product join laptop on product.model = laptop.model
union all
select pc.price, pc.code, product.maker, product.model, product."type", 
case 
when pc.price > (select max(price) from printer)
then 1
else 0
end flag
from product join pc on product.model = pc.model

select * from all_products_with_index_task4

CREATE INDEX flag_idx ON all_products_with_index_task4 (flag)

--task5  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу model (union all) 
-- и сделать флаг (flag) по цене > максимальной по принтеру. 
-- Также добавить нумерацию (через оконные функции) по каждой категории продукта в порядке возрастания цены (price_index). 
-- По этому price_index сделать индекс


create table all_products_with_index_task5 as
select printer.price, printer.code, product.maker, product.model, product."type",
case 
when printer.price > (select max(price) from printer)
then 1
else 0
end flag,
row_number() over (order by price) price_index
from product join printer on product.model = printer.model
union all
select laptop.price, laptop.code, product.maker, product.model, product."type", 
case 
when laptop.price > (select max(price) from printer)
then 1
else 0
end flag,
row_number() over (order by price) price_index
from product join laptop on product.model = laptop.model
union all
select pc.price, pc.code, product.maker, product.model, product."type", 
case 
when pc.price > (select max(price) from printer)
then 1
else 0
end flag,
row_number() over (order by price) price_index
from product join pc on product.model = pc.model

explain ANALYZE
select AVG(price) from all_products_with_index_task5
explain ANALYZE
select AVG(price_index) from all_products_with_index_task5


CREATE INDEX price_index_idx ON all_products_with_index_task5 (price_index)