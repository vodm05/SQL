/*JOINY*/
SELECT orders.standard_qty,orders.gloss_qty,orders.poster_qty,accounts.website,accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/* SELECT -> před tečku tabulka, po tečce sloupec, 
FROM -> může být na kteroukoli tabulku
JOIN -> zvolit
ON -> podle tabulky z FROM, musí být zase s tečkou a rovná se na sloupec už bez tečky, ten je totiž odkázaný na tabulku z JOIN.*/

/* EDR - entity relationship diagram - vizulizace tabulek a jejich propojení*/

SELECT w.occurred_at, w.channel, a.name, a.primary_poc
FROM web_events w
JOIN accounts a
ON web_events.account_id = accounts.id
WHERE name = ('Walmart')
/* Joinutí + firltrování eventu s Walmartem*/
/* "web_events w" funguje jako AS (alias)*/

SELECT sales_reps.name, sales_reps.id, region.name AS reg_names
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
ORDER BY region.name
/* NUTNOST PŘEJMENOVÁNÍ JEDNOHO ZE SLOUPCU "name" -> není možné mít 2 sloupce se stejným jménem*/

SELECT region.name AS reg_name, sales_reps.name,(orders.total_amt_usd/(orders.total + 0.01)) AS unit_price
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts 
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id
/* přičteno 0.01. aby se nedělilo 0*/ 

SELECT region.name, accounts.name as ac_name, sales_reps.name AS rep_name
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
AND region.name IN ('Midwest')
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
/* použití AND pod JOIN funguje jako WHERE pro filtraci*/
/*alternativa místo AND pod ON, vložit pod JOINY WHERE*/
WHERE region.name = ('Midwest')

/* obměna kódu, hledáme začínají na S a řadíme abecendě*/
SELECT region.name, sales_reps.name AS sal_name, accounts.name AS ac_name
FROM region
JOIN sales_reps
ON sales_reps.region_id = region.id
AND sales_reps.name LIKE 'S%'
AND region.name IN ('Midwest')
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
ORDER BY accounts.name

/*oběma -> druhé jméno začíná na K*/

SELECT region.name, sales_reps.name AS sal_name, accounts.name AS ac_name
FROM region
JOIN sales_reps
ON sales_reps.region_id = region.id
AND sales_reps.name LIKE '%% K%'
AND region.name IN ('Midwest')
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
ORDER BY accounts.name

/* obměna*/
SELECT region.name, accounts.name AS ac_name, (orders.total_amt_usd/(orders.total+0.01)) AS unit_price
FROM region
JOIN sales_reps
ON sales_reps.region_id = region.id
JOIN accounts
ON accounts.sales_rep_id = sales_reps.id
JOIN orders
ON orders.account_id = accounts.id                                                                
AND orders.total > 100

/* obměna*/
SELECT region.name, accounts.name AS ac_name, (orders.total_amt_usd/(total+0.01)) AS unit_price
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id                                                 
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id
AND orders.total > 100
AND orders.poster_qty > 50

/*něco jiného*/

SELECT DISTINCT w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.id = 1001

/*čas*/

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY occurred_at DESC;