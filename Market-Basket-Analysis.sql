--- add a new column with a unique value for each row

alter table "MBA".groceries 
add transaction_id int generated always as identity

--- convert columns to row to reshape dataset so it's easier for data manipulation

select g.transaction_id, p.*
from "MBA".groceries g 
	cross join lateral (
		values
			(g."Item 1", 'Item 1'),
			(g."Item 2", 'Item 2'),
			(g."Item 3", 'Item 3'),
			(g."Item 4", 'Item 4'),
			(g."Item 5", 'Item 5'),
			(g."Item 6", 'Item 6'),
			(g."Item 7", 'Item 7'),
			(g."Item 8", 'Item 8'),
			(g."Item 9", 'Item 9'),
			(g."Item 10", 'Item 10'),
			(g."Item 11", 'Item 11'),
			(g."Item 12", 'Item 12'),
			(g."Item 13", 'Item 13'),
			(g."Item 14", 'Item 14'),
			(g."Item 15", 'Item 15'),
			(g."Item 16", 'Item 16'),
			(g."Item 17", 'Item 17'),
			(g."Item 18", 'Item 18'),
			(g."Item 19", 'Item 19'),
			(g."Item 20", 'Item 20'),
			(g."Item 21", 'Item 21'),
			(g."Item 22", 'Item 22'),
			(g."Item 23", 'Item 23'),
			(g."Item 24", 'Item 24'),
			(g."Item 25", 'Item 25'),
			(g."Item 26", 'Item 26'),
			(g."Item 27", 'Item 27'),
			(g."Item 28", 'Item 28'),
			(g."Item 29", 'Item 29'),
			(g."Item 30", 'Item 30'),
			(g."Item 31", 'Item 31'),
			(g."Item 32", 'Item 32')
	) as p(product, item)
order by transaction_id

--- drop all blank value

delete
from "MBA".uncleaned_groceries
where product = ''

--- delete all low support items (support < 0.002 ) to prevent them from skewing the analysis result since the dataset is too large

with cte as
(select 
	product,
	support
from
(select 
	product,
	cast (count(*) as numeric (10,5)) / (select cast (count(*) as numeric (10,5)) from "MBA".uncleaned_groceries) as support
from "MBA".uncleaned_groceries
group by 1)
where support < 0.002
order by 2 desc)

delete from "MBA".uncleaned_groceries a
where a.product in (select product from cte)

--- data overview after data preparation

select
	count (distinct product)
from "MBA".uncleaned_groceries

--- top 10 most purchased product

select 
	product,
	count (product) as purchased_count
from "MBA".uncleaned_groceries
group by 1
order by 2 desc
limit 10

--- calculate support

select 
	a.product as item_A,
	b.product as item_B,
	cast ((count(*)) as numeric (10,5)) / (select cast (count (*) as numeric (10,5)) from "MBA".uncleaned_groceries) as support
from "MBA".uncleaned_groceries a
join "MBA".uncleaned_groceries b on a.transaction_id = b.transaction_id 
where a.product < b.product 
group by 1,2
order by 3 desc
limit 10

--- calculate confidence

select 
	a.product as item_A,
	b.product as item_B,
	counta.freq_a,
	cast ((count(*)) as numeric (10,5)) as freq_ab,
	(cast ((count(*)) as numeric (10,5)) / counta.freq_a) as confidence
from
"MBA".uncleaned_groceries a join
"MBA".uncleaned_groceries b on a.transaction_id = b.transaction_id and a.product < b.product join 
	(
	select 
		product,
		cast ((count(*)) as numeric (10,5)) as freq_a
	from "MBA".uncleaned_groceries
	group by 1
	) as counta on a.product = counta.product
group by 1,2,3
order by 4 desc
limit 10

--- calculate lift

select 
	a.product as item_a,
	b.product as item_b,
	(cast (count(*) as numeric (10,5)) / (select cast (count (*) as numeric (10,5)) from "MBA".uncleaned_groceries)) /
	(((select cast (count(*) as numeric (10,5)) from "MBA".uncleaned_groceries where product = a.product) / (select cast (count(*) as numeric (10,5)) from "MBA".uncleaned_groceries)) *
	((select cast (count(*) as numeric (10,5)) from "MBA".uncleaned_groceries where product = b.product) / (select cast (count(*) as numeric (10,5)) from "MBA".uncleaned_groceries))) as lift
from "MBA".uncleaned_groceries a
join "MBA".uncleaned_groceries b on a.transaction_id = b.transaction_id 
where a.product < b.product
group by 1,2
order by lift desc 
limit 10

---
