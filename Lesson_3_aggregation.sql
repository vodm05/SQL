/Lesson 3*/

WHERE standard_qty IS NULL - tam kde chybí hodonoty

/* SUM(column) - součet sloupce
COUNT(column) - počet hodnot ve sloupci

POZOR! COUNT(*) - vrátí počet řádků ve sloupci.

/*SELECT SUM(poster_qty)
FROM orders*/

/*SELECT SUM(standard_qty)
FROM orders */

/*SELECT SUM(total_amt_usd)
FROM orders*/

/*SELECT SUM(standard_amt_usd) AS standard, SUM(gloss_amt_usd) AS gloss
FROM orders*/

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;

/*SELECT MIN(occurred_at)
FROM orders*/

/*SELECT occurred_at
FROM orders
ORDER BY occurred_at*/
/* Stejné jako předchozí, bez využií agregátorů*/

/*SELECT MAX(occurred_at)
FROM web_events*/

/*SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC*/

/* Stejné jako předchozí, bez využií agregátorů*/

/*SELECT AVG(standard_amt_usd) AS st_av,
AVG(gloss_amt_usd) AS gl_av,
AVG(poster_amt_usd) AS po_av,
AVG(total_amt_usd) AS tot_av,
AVG(standard_qty) AS standard,
AVG(gloss_qty) AS gloss,
AVG(poster_qty) AS poster
FROM orders*/

SELECT total_amt_usd, 
FROM orders
ORDER BY total_amt_usd
LIMIT 3457

/*6912 položek, sudý počet, dvě hodonoty uprostřed průměr = medián = 3457. pozice + 3456. pozice = (2482.55 + 2483,16)/2 = 2482,855*/


/*Group by -> udělá např. sumu pro danou položko. vše, kde není použitá agregační funkce (sum/avg/count...), musí být níže napsáno v group by, group by se píše mezi where a order by.*/

/*SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY o DESC*/



/*SELECT SUM(o.total_amt_usd) total, a.name 
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name*/

/*SELECT w.channel cha, w.occurred_at occ , a.name
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY occ DESC
LIMIT 1*/

/*SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel*/

/* Vypíše všechny channely a k nim jejich počet*/

/*SELECT w.occurred_at occ, a.primary_poc prm
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY occ DESC
LIMIT 1;*/

/*SELECT MIN(o.total_amt_usd) tot, a.name nm
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY nm
ORDER BY tot*/

/*SELECT COUNT(s.id) cou, r.name
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
GROUP BY r.name
ORDER BY cou DESC*/

/*Trénink agregace + group by.*/


/*SELECT a.name, AVG(o.standard_qty) AS avg_standard, AVG(o.poster_qty) AS avg_poster, AVG(o.gloss_qty) AS avg_glossy
FROM accounts a
JOIN orders o 
ON a.id = o.account_id
GROUP BY a.name*/

/*SELECT a.name, AVG(o.standard_amt_usd) av_spend_stand, AVG(o.gloss_amt_usd) av_spend_gloss, AVG(o.poster_amt_usd) av_spend_poster
FROM accounts a
JOIN orders o 
ON a.id = o.account_id
GROUP BY a.name*/

/*SELECT COUNT(w.channel), w.channel, s.name
FROM web_events w
JOIN accounts a
ON w.id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY w.channel, s.name*/

/*SELECT COUNT(w.channel), r.name, w.channel
FROM web_events w
JOIN accounts a
ON w.id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name, w.channel*/

/*DISTINCT - udělá group by, když necheme použít agregace
Píše se vždy do selectu a stačí napsat jenom jednou
vytvoří pro všechny sloupce unikátní řádky, tyto sloupce musí mít dvojici, např. č. objedávnky a počet kusů
pokud by bylo např. vícero kusů na jedné objednávce, tak to neudělá dvojici a nepropíše*/

/* klasická cesta*/
/*SELECT s.id, s.name, COUNT(s.id) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts*/

/*přes distinct*/
/*SELECT DISTINCT id, name
FROM sales_reps;*/

/*distinct vynechává, první postup je lepší*/

/* HAVING - k filtrování agregovaného*/

/*SELECT s.name, s.id, COUNT(*) AS num_accounts
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.name, s.id
HAVING COUNT(*) >= 5
ORDER BY num_accounts DESC;*/
/* pozor - count počítá počet řádků ve sloupci accounts
Získal jsem seznam prodejců, kteří jsou napojení na 5 a více účtů*/

/*SELECT a.id, COUNT(o.id) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id
HAVING COUNT(o.id) >= 20
ORDER BY num_orders
kolik účtů má 20 a více objednávek*/


SELECT a.id, SUM(o.total_amt_usd) value_per_account
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id
HAVING SUM(o.total_amt_usd) >= 30000
ORDER BY value_per_account
/*účtu s objednávaky za 30 0000 a více*/

SELECT a.id, SUM(o.total_amt_usd) value_per_account
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id
HAVING SUM(o.total_amt_usd) <= 1000
ORDER BY value_per_account
/*účtu s objednávaky za 1000 a méně*/

SELECT a.id, a.name, w.channel, COUNT(w.channel) čenl
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
GROUP BY a.id, w.channel, a.name
HAVING COUNT(w.channel) > 6 AND w.channel = 'facebook'
ORDER BY čenl
/*firmy, které použili kanál "facebook" více jak 6x.*/

SELECT w.channel, a.name, COUNT(w.channel) num 
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
GROUP BY w.channel, a.name
ORDER BY num DESC
LIMIT 10
/*který 10 firem požívalo nejvíce channelu a jaké přesně*/

*******DATATIME
Datumy jsou uváděny 2017-04-02 12:52
potřebujeme filtrovat - zbavit se např. hodin a nechat jenom Datumy
DATE_TRUNC('day', occurred_at)
- vyčistí zbytek, takže zůstane 2017-04-02 00:00
DATE_PART('dow', occurred_at)
- dow, jako týden, dny jsou číselně 0-6, 0 = neděle, 6 = sobota
- pozor, nezohledňuje roky, bere data z roku 2016 i 2017


SELECT DATE_PART('year', occurred_at) date, SUM(total_amt_usd) money
FROM orders
GROUP BY DATE_PART('year', occurred_at)
ORDER BY money DESC;
/* výnosy z prodeje za jednotlivé roky*/

SELECT DATE_PART('month', occurred_at) date, SUM(total_amt_usd) money
FROM orders
GROUP BY date
ORDER BY money DESC;
/* součet příjmů měsíce každého roku*/

SELECT DATE_PART('year', occurred_at) date, COUNT(*) num_orders
FROM orders
GROUP BY date
ORDER BY num_orders DESC;
/*počet objednávek v jednotilvých letech*/

SELECT DATE_PART('month', occurred_at) date, COUNT(*) num_orders
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY date
ORDER BY num_orders
/*počet objednávek v jednotlivých měsících v letech*/


SELECT DATE_PART('year', o.occurred_at) AS date, a.name, SUM(gloss_amt_usd) AS money
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name IN ('Walmart')
GROUP BY 1, 2
ORDER BY 3
/*kolik činily tržby plynoucí ze společnosti Walmart za jednotlivé roky*/

****** Možnost nahradit slovní názvy čísly v GROUP BY a ORDER BY na základě pořadí v SELECT

****** CASE WHEN total < 3000 or total <= 3000 THEN 'Good' ELSE 'BAD' END AS objednavka
/*slouží k rozdělení dat do skupin, respektive vznike nový sloupec, který označí tyto řádky dle podmínky, píše se vždy do SELECTU, povinně musí mít CASE WHEN, THEN, END, ELSE je nepovinné*/

/*SELECT o.account_id, o.total, CASE WHEN o.total_amt_usd > 3000 THEN 'Large' ELSE 'small' END AS level_of_the_order
FROM orders o
/* je-li objednávka za ívce jak 3000 je velká jinak malá*/*/

/*SELECT o.account_id, total, CASE WHEN total > 2000 THEN 'At Least 2000'
WHEN TOTAL < 2000 AND TOTAL > 1000 THEN 'Between 1000 and 2000' ELSE 'Less than 1000' END AS number_of_orders
FROM orders o 
ORDER BY total DESC
/*objednávky rozdělené podle množství*/*/

SELECT a.name, SUM(total_amt_usd) total_sum, CASE WHEN SUM(total_amt_usd) > 200000 THEN 'first level' WHEN SUM(total_amt_usd) > 100000 AND  SUM(total_amt_usd) < 200000 THEN 'second level' ELSE 'low level' END AS Lifetime_Value
FROM orders o 
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2
/*rozdělení klientů dle výše objednávek*/

SELECT a.name, SUM(total_amt_usd) total_sum,  DATE_TRUNC('year', occurred_at), CASE WHEN SUM(total_amt_usd) > 200000 THEN 'first level' WHEN SUM(total_amt_usd) > 100000 AND  SUM(total_amt_usd) < 200000 THEN 'second level' ELSE 'low level' END AS Lifetime_Value
FROM orders o 
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31'
GROUP BY 1, 3
ORDER BY 2
/*přehled jako v minulém příkladě, sledované za rok 2016 a 2017*/

SELECT s.name, COUNT(*) num_of_orders, CASE WHEN COUNT(*) > 200 THEN 'top' ELSE 'not' END AS top_sales_reps
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY 1
ORDER BY 2 DESC;
/*žebříček nejlepších prodejců, rozdělení na top a not, musí mít alespoň 200 objednávek*/

SELECT s.name, COUNT(*) num_of_orders, SUM(o.total_amt_usd) total_dollar_amount, CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top' WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle' ELSE 'low' END AS top_sales_reps
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY 1
ORDER BY 3 DESC;
/*žebříček nejlepších prodejců, rozdělení na top a not, musí mít alespoň 200 objednávek + podmínka celkové tržby*/

******* sub-query
1. základní quer
2. ten se dá do závorek a za něj se napíše alisas - obvykle sub
3. SELECT, obvykle *. abych vzal vše z vnitřního queru, FROM se chápe jako vnitřní quer
4. ORDER BY, WHERE, se píše až pod inner quer

SELECT channel, AVG(num_events)
FROM
(SELECT COUNT(*) num_events, DATE_TRUNC('day',occurred_at) AS den, channel
FROM web_events
GROUP BY 2, 3
ORDER BY 1 DESC
) sub
GROUP BY channel
/* získám průměrný počet eventů na den*/
















