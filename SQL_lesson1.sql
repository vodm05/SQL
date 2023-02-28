SELECT occurred_at, account_id, channel /* označení slouplce*/
FROM web_events /*označení matice */
LIMIT 15; /* počet řádku k zobrazení*/

/*ORDER BY - musí být mezi FROM a LIMIT + DESC bude sortovat od Z do A, default je od A do Z*/

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
ORDER by 
LIMIT 10;
/* 10 nejstarších objednávek*/

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 10;
/* 10 nejdražších objedáven*/

SELECT total_amt_usd, id, account_id
FROM orders
ORDER BY total_amt_usd
limit 20;
/* 20 nejlevnějcíh objednávek*/


/* ORDER BY vícenásobné, řadí podle pořadí zadaných sloupců. Opět lze použít řazení DESC*/

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC
/* podle ID a jejich nejvyšší hodnoty až po ty nejnižší = dává smysl*/

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id, id
/* podle výšky částky pak čísla účtu a ID = nedává smysl, vypíše nejvyšší částky u každého účtu, nesplňuje zadání jako v předchozím*/

/* WHERE - vyselektujeme určitou část podle argumentu, využití operátorů*/

SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5
/* všechny sloupce, 5 řádků splňující podmínku*/

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10

/* WHERE se stringem; WHERE name(jako column) = 'Exxon Mobil'*/

SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil' and website = 'www.exxonmobil.com'

/*Derived column = sloupec, který vznke matematickou operací mezi dvěma jinými sloupci
    pojmenování "alias" AS*/

SELECT 
	id,
    account_id,
    (standard_amt_usd/standard_qty) AS price_for_standard_paper
FROM orders
LIMIT 10;
/* zjištění ceny 1 ks standardizovaného papíru*/

SELECT id, account_id,
(poster_amt_usd/(poster_amt_usd+standard_amt_usd+gloss_amt_usd))*100 AS per_rev_poster
FROM orders
LIMIT 10;
/* % podíl na tržbách plakátového papíru*/

/* LIKE = využití s where, při znalosti pouze přibližné hledané hodnoty
     %xxxx% - xxxx = hledaná, % = čísla/písmena okolo hledané hodnoty*/

SELECT *
FROM accounts
WHERE name LIKE '%s'
/*končící na 's'*/

SELECT *
FROM accounts
WHERE name LIKE '%one%'
/* obsahující 'one'*/

SELECT *
FROM accounts
WHERE name LIKE 'C%'
/*Začíná na 'C'*/

/* IN = využítí s WHERE, při hledání konrétní hodnoty
        v uvozovkách stringy, float a integry ne, pozor stringy s apostrofy s dvojitými uvozovkami*/

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom')
/*hledání podle zadaného Walmart..*/

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') 

/*NOT = píše se před IN, LIKE... neguje*/

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom')
/* vše kromě zadaných - stejné i u dalších příkladů*/

SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords') 

SELECT *
FROM accounts
WHERE name NOT LIKE ('C%')


/* použití OR, AND, between, and. Část kódu jsem neuložil, tak tanto příklad vystihuje všechno*/

SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') 
           AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') 
           AND primary_poc NOT LIKE '%eana%');

/* between - je to uzavřený interval, pozor výjimka u času. bere to čas od půnoci do půlnoci, takže se to musí posnunout o jeden den*/

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;
/*chci to za celý rok 2016, ale musím to dát do 01.01.2017, protože se 31.12.2016 23:59 a jde to do té půlnoci, která je 01.01.2017*/

