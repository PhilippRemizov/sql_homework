--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- insert into Product_new values('E','product_by_student_19_new','PC');
--
--UPDATE product_new SET maker = 'E_updated' WHERE model = 'product_by_student_19_new'
--
 --select * from Product_new where model = 'product_by_student_19_new';
--
--DELETE from product_new WHERE model = 'product_by_student_19_new'
--
--select * from Product where model = 'product_by_student_19_new';

-- Задание 9: Посчитать количество возможных типов cd в таблице PC
select * from PC
select count(distinct cd) from PC

select * 
from product_new
join laptop
on product_new.model = laptop.model



-- Задание 10: Какое количество принтеров у каждого производителя (maker), 
--стоимость (price) которых (принтера) больше 280

select count(*), maker
from product_new
join printer
on product_new.model = printer.model
where price > 280
group by maker



-- Задание 11: Найти модели принтеров с самой высокой ценой. Вывести: model, price

select model from printer where price = (select max(price) from printer)

-- Задание 12: Вывести разницу в средней цене между PC и принтерами (Printer)

select 
(select AVG(price) from Printer)
-
(select AVG(price) from PC)


-- Задание 13: Вывести производителей самых дешевых принтеров. Вывести price, maker

select distinct maker, price from product_new
join Printer on product_new.model = Printer.model
where price = (select min(price) from Printer)

--select * from Printer

-- Задание 14: Вывести производителей самых дешевых цветных принтеров (color = 'y')

select distinct maker from product_new
join Printer on product_new.model = Printer.model
where price = (select min(price) from Printer where color = 'y')
and Printer.color='y'

--
-- Задание 15: Вывести все принтеры со стоимостью выше средней по принтерам

select * from product_new
join Printer on product_new.model = Printer.model
where price > (select AVG(price) from Printer)
--and Printer.color='y'

-- Задание 16: Какое количество уникальных продуктов среди PC и Laptop

select 
(select count(distinct model) from PC)
+
(select count(distinct model) from Laptop)

-- Задание 17: Какая средняя цена среди уникальных продуктов производителя = 'A' (только printer & laptop, без pc)
select AVG(distinct Printer.price),AVG(distinct laptop.price) from product
left join Printer on product.model = Printer.model
left join laptop on product.model = laptop.model
where product.maker = 'A'

select * from printer
select * from laptop

Select 
(
  (SELECT sum(distinct price) from printer join product on printer.model = product.model where product.maker = 'A')
  +
  (SELECT sum(distinct price) from laptop join product on laptop.model = product.model where product.maker = 'A')
) 
/ 
(
  (SELECT count(distinct price) from printer join product on printer.model = product.model where product.maker = 'A')
  +
  (SELECT count(distinct price) from laptop join product on laptop.model = product.model where product.maker = 'A')
)


select distinct price, model from 
printer
where model in (select model from product where (type = 'Printer' or type = 'Laptop') and maker = 'A')

-- Задание 18: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D'. Вывести model

select * 
from product
join Printer on product.model = Printer.model
where product.maker = 'A' and Printer.price >
(select AVG(price) 
from product
join Printer on product.model = Printer.model
where product.maker = 'D')

-- Задание 19: Найдите производителей, которые производили бы как PC со скоростью (speed) не менее 750, 
-- так и laptop со скоростью (speed) не менее 750. Вывести maker

select product.maker
from product
join laptop on product.model = laptop.model
where product.maker in
(select distinct maker
from product
join PC on product.model = PC.model
where PC.speed>=750)
and laptop.speed >=750


-- Задание 20: Найдите средний размер hd PC каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.

select p1.maker, AVG(p2.hd)
from product p1
join PC p2 on p1.model = p2.model
where p1.maker in
(
	select distinct p1.maker
	from product p1
	join printer p3 on p1.model = p3.model
)
group by p1.maker