--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson5)
-- Компьютерная фирма: Вывести список самых дешевых принтеров по каждому типу (type)

select *, 
row_number(*) over (order by maker) as rn,
count(*) over (partition by "type") as total
from product

select *, 
row_number(*) over (partition by type order by maker) as rn,
count(*) over (partition by type) as total
from product

SELECT *, 
rank () over (ORDER BY type) as rnk, 
dense_rank () over (ORDER BY type) as dense_rnk,
count (*) over ()  as total
FROM product

SELECT *, price - AVG(price) OVER(PARTITION BY cd) AS dprice 
FROM PC;

select * from 
(select *, row_number(*) over (partition by type order by price) as cheap from printer) a
where cheap = 1

--task2  (lesson5)
-- Компьютерная фирма: Вывести список самых дешевых PC по каждому типу скорости

select * from 
(select *, row_number(*) over (partition by speed order by price) as cheap from PC) a
where cheap = 1

select * from PC

--Компьютерная фирма: Вывести список самых дорогих PC по каждому типу hd

select * from 
(select *, row_number(*) over (partition by hd order by price desc) as expensive from PC) a
where expensive = 1

--task3  (lesson5)
-- Компьютерная фирма: Найти производителей, которые производят более 2-х моделей PC (через RANK, не having).

select distinct maker
from
(SELECT *, 
rank () over (partition by maker ORDER BY model) as rnk
--dense_rank () over (ORDER BY type) as dense_rnk
--count (*) over ()  as total
FROM product
where "type" = 'PC') a
where a.rnk > 2

select * from product

--task4 (lesson5)
-- Компьютерная фирма: Вывести список самых дешевых PC по каждому производителю. Вывод: maker, code, price

select maker, model, price
from 
(select maker, PC.model, price, rank () over (partition by maker ORDER BY price) as rnk,
row_number(*) over (partition by maker order by price) as rn
from PC join product 
on PC.model = product.model) a
where rnk = 1


--task5 (lesson5)
-- Компьютерная фирма: Создать view (all_products_050521), в рамках которого будет только 2 самых дорогих товаров 
--по каждому производителю

create view all_products_050521 as 
select 
model, price, type, maker
from 
(select model, price, type, maker, row_number(*) over (partition by maker order by price desc) as rn
from
(select PC.model, PC.price, product."type", product.maker
from PC join product 
on PC.model = product.model
union 
select laptop.model, laptop.price, product."type", product.maker
from laptop join product 
on laptop.model = product.model
union 
select printer.model, printer.price, product."type", product.maker 
from printer join product 
on printer.model = product.model) a) b
where b.rn <=2

select * from all_products_050521

--task6 (lesson5)
-- Компьютерная фирма: Сделать график со средней ценой по всем товарам по каждому производителю (X: maker, Y: avg_price) на базе view all_products_050521

select maker, AVG(price) as price from  all_products_050521 group by maker

--task7 (lesson5)
-- Компьютерная фирма: Для каждого принтера из таблицы printer найти разность между его ценой и минимальной ценой 
--на модели с таким же значением типа (type, в долях)

select *, price - min (price) OVER(PARTITION BY type) from printer

--task8 (lesson5)
-- Компьютерная фирма: Для каждого принтера из таблицы printer найти разность между его ценой и минимальной ценой 
--на модели с таким же значением color (type, в долях)

select *, price - min (price) OVER(PARTITION BY color) from printer

select * from printer

--task9 (lesson5)
-- Компьютерная фирма: Для каждого laptop  из таблицы laptop вывести три самых дорогих устройства (через оконные функции).

select * from 
(select *, row_number(*) over (order by price desc) as rn
from laptop) a
where rn <=3

--task10 (lesson5)
-- Компьютерная фирма: Для каждого производителя вывести по три самых дешевых устройства в отдельное view (products_with_lowest_price).

create view products_with_lowest_price as 
select 
model, price, type, maker
from 
(select model, price, type, maker, row_number(*) over (partition by maker order by price) as rn
from
(select PC.model, PC.price, product."type", product.maker
from PC join product 
on PC.model = product.model
union 
select laptop.model, laptop.price, product."type", product.maker
from laptop join product 
on laptop.model = product.model
union 
select printer.model, printer.price, product."type", product.maker 
from printer join product 
on printer.model = product.model) a) b
where b.rn <=3

select * from products_with_lowest_price

--task11 (lesson5)
-- Компьютерная фирма: Построить график с со средней и максимальной ценами на базе 
--products_with_lowest_price (X: maker, Y1: max_price, Y2: avg)price

select maker, avg(price) as avg, max(price) as max_price from products_with_lowest_price group by maker

--task12 (lesson5)
-- Компьютерная фирма: Сделать view, в которой будет постраничная разбивка всех laptop (не более двух продуктов на одной странице). 
-- Вывод: все данные из laptop, номер страницы, список всех страниц

1 1
2 1
1 2
2 2
1 3
2 3

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
