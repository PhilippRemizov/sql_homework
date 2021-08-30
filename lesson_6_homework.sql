--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson6, дополнительно)
-- SQL: Создайте таблицу с синтетическими данными (10000 строк, 3 колонки, все типы int) 
--и заполните ее случайными данными от 0 до 1 000 000. Проведите EXPLAIN операции и сравните базовые операции.

create table table_synth as
select  cast(random()*1000000 as int) as ind1, 
cast(random()*1000000 as int) as ind2, 
cast(random()*1000000 as int) as ind3
from generate_series(1,10000)

--EXPLAIN
--Function Scan on generate_series  (cost=0.00..32.50 rows=1000 width=12)

--EXPLAIN ANALYZE
--Function Scan on generate_series  (cost=0.00..32.50 rows=1000 width=12) (actual time=0.628..1.991 rows=10000 loops=1)
--Planning time: 0.064 ms
--Execution time: 7.071 ms

select * from table_synth limit 100
select count(*) from table_synth

--task2 (lesson6, дополнительно)
-- GCP (Google Cloud Platform): Через GCP загрузите данные csv в базу PSQL по личным реквизитам 
-- (используя только bash и интерфейс bash) 


