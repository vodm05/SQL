LESSON 5 - data cleaning

Vyzbírávání části dat - píše se do SELECTU
LEFT(phone_number, 3) - vybere první tři členy zleva
RIGHT(phone_number, 8) - vybere prvních 8 členů zprava
LENGTH(phone_number) - vybee celé, může se použít LENGTH(phone_number) - 4 -> vezme celek a odebere zprava první 4 členy a vyprintuje do sloupce*/

WITH aka AS (SELECT RIGHT(website, 3), id
FROM accounts)

SELECT COUNT(*), aka.right
FROM aka
GROUP BY 2

/* hledání koncovky webové adresy*/

SELECT LEFT(name, 1), name
FROM accounts  
ORDER BY 1

/* hledání prvního člena výrazu*/ 

WITH ab as (SELECT CASE WHEN LEFT (name, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN 1 ELSE 0 END AS num, a.id
FROM accounts a
ORDER BY 1 DESC)

SELECT num, COUNT(num)
FROM ab
GROUP BY 1

/* rozlišení na firmy, které začínají číslem a které písmenem*/

WITH ab as (SELECT CASE WHEN LEFT (name, 1) IN ('a', 'e', 'i', 'o', 'u') OR LEFT(name, 1) IN ('A', 'E', 'I', 'O', 'U') THEN 1 ELSE 0 END AS num, a.id
FROM accounts a
ORDER BY 1 DESC)

SELECT num, COUNT(num)
FROM ab
GROUP BY 1

/* hledání firem, které začínají na samohálsky*/

******** Další statementy
position -> (',' IN city_state) AS where_is_comma = column s číslem určující zleva doprava pozici zadaného členu
)

POZOR*********
v SQL je na v indexaci na prvním místě 1: AHOJ, idex 1 = A 

strops -> (city_state, ',') -> k hledání stringu, v tomto případě výsledek stejný jako u position

*****
STROPS a POSITION mají stejný výsledek, ale jiný syntax + citlivé na velká a malá písmena.

LOWER/UPPER -> LOWER/UPPER(city_state) - vše malé nebo velké

KOMBINACE

LEFT(city_state, POSITION(',' IN city_state)) AS city -> napíše město se státem a zatím čárku
city_state = Cincinati, OH, tudíž POSITION(',' IN city_state) je přesně ta čárka v "Cinacinati, OH"



WITH abc AS (SELECT primary_poc, POSITION(' ' IN primary_poc) aqd
FROM accounts)

SELECT LEFT(primary_poc, aqd), RIGHT(primary_poc, - aqd), primary_poc
FROM abc

/*Rozdělení jména a příjemní v jednom sloupci do dvou jednotlivých sloupců
1. najdu mezeru, konrkétně její index,
2. jdu zleva a utnu to vždy kdy je mezera - označen indexem z inner queru
3. jdu zprava, kde jsem například "Tamara Tuma" = 11 členů, kdyby to vzal v 7, kde je mezera, tak mi to
vypíše "ra Tuma", proto musím udělat - ta mezera, abych (můžu to chápat):
a) 11 - 7 = 4 -> "Tuma 
b) počítám - 7 od jména Tamara.. -> zastavím se na té mezeře a pak jede RIGHT */

CONCAT -> spojení dvou sloupců 
CONCAT(first_column,' ', second_column)

WITH comma AS (SElECT POSITION(' ' IN primary_poc) comma_position, primary_poc, name
FROM accounts),

nameparts AS (SELECT LEFT(primary_poc, comma_position) AS names, RIGHT(primary_poc, - comma_position) AS surname, name
FROM comma)

SELECT concat(names, '.', surname, '@', name, '.com')
FROM nameparts

/* vytvoření mailvoé adresy, ale jsou mezery v názvech firem*/

WITH comma AS (SELECT POSITION(' ' IN primary_poc) comma_position, primary_poc, name
FROM accounts),

nameparts AS (SELECT LEFT(primary_poc, comma_position) AS names, RIGHT(primary_poc, - comma_position) AS surname, name
FROM comma)

SELECT concat(names, '.', surname, '@', REPLACE(name, ' ', ''),'.com')
FROM nameparts

/* zde použita navíc funkce replace, která odstranila mezery mezi názvy firem*/

WITH beg AS (SELECT LEFT(primary_poc, 1) f_l_n, POSITION(' ' IN primary_poc) space, RIGHT(primary_poc, 1) l_l_s, primary_poc, REPLACE(name, ' ', '') company
FROM accounts),

CON AS (SELECT LEFT(primary_poc, space) name_prim, RIGHT(primary_poc, -space) surname_prim, f_l_n, space, l_l_s, primary_poc, company
FROM beg),

CON05 AS (SELECT REPLACE(name_prim, ' ', '') name_prim2, surname_prim, f_l_n, space, l_l_s, primary_poc, company
FROM CON),

CON2 AS (SELECT primary_poc, name_prim2, surname_prim, f_l_n, RIGHT(name_prim2, 1) l_l_n, LEFT(surname_prim, 1) f_l_s, l_l_s, LENGTH(name_prim2) len_name, LENGTH(surname_prim) len_sur, UPPER(company) 
FROM CON05)

SELECT CONCAT(f_l_n, l_l_n, f_l_s, l_l_s, len_name, len_sur, upper), primary_poc
FROM CON2

/*Kód ke generování hesel:
1. první + poslední písmeno jména
2. první + poslední přísmeno příjmení
3. délka jména + příjmení
4. velkými písmeny bez mezer název firmy, pro kterou pracují
Tamara Tuma = TaTa64WALMART*/


***********Práce s datumy

Správný zápis datumu v SQL:

yyyy-mm-dd

DATE_PART('month', TO_DATE(month, 'month')) 
-> změní January na 1

CAST(date_column AS DATE) AS formatted_date
-> změní datum(string) na datum(date). změna data_type

Alternativa ke CAST:

date_column::DATE.

WITH clean AS (SELECT date, LEFT(date, 10), REPLACE(LEFT(date,10),'/','') date_numbers
FROM sf_crime_data
LIMIT 10),

clean1 AS (SELECT LEFT(date_numbers, 2) AS DAYS, RIGHT(date_numbers, 4) AS YEARS, 
SUBSTRING(date_numbers, 3,2) months, date_numbers
FROM clean)

SELECT (YEARS || '-' || DAYS || '-' || MONTHS)::date
FROM clean1

2014-01-31T00:00:00.000Z
-> formát je yyyy-mm-dd, ale musí se zadat jako yyyy-dd-mm

***** COALESCE

-> pro práci s NULL - values
nahradí NULL - value zadaným výrazem

COALESCE(primary_poc, 'THERE_IS_NO_primary_poc')

WITH prvni AS (SELECT a.id acka, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL)

SELECT *, COALESCE(acka, acka)
FROM prvni

/* našli jsme firmu, která má celkové objednávky NULL value a přiřadili jim ID a přidali jim id.*/

SELECT COALESCE(a.id, o.id), a.name, a.website, a.lat
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL

/* přiřazení čísel z objednávek*/

SELECT COALESCE(a.id, o.id), a.name, a.website, a.lat, COALESCE(o.standard_qty, '0') stan_qty_cover, COALESCE(o.gloss_qty, '0') gloss_qty_cover, COALESCE(o.poster_qty, '0') poster_qty_cover,
COALESCE(o.standard_amt_usd, '0') stan_usd_cover,
COALESCE(o.poster_amt_usd, '0') poster_usd_cover,
COALESCE(o.gloss_amt_usd, '0') gloss_usd_cover
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL

/* nadstaba z pedchozího, individuální množstevní a peněžní sloupce nahrazené '0'.*/

SELECT COUNT(a.id), 
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
/* celkově i s NULL hodnotami -> 6913 id*/

SELECT COUNT(a.id),
COALESCE(a.id, o.id), a.name, a.website, a.lat, COALESCE(o.standard_qty, '0') stan_qty_cover, COALESCE(o.gloss_qty, '0') gloss_qty_cover, COALESCE(o.poster_qty, '0') poster_qty_cover,
COALESCE(o.standard_amt_usd, '0') stan_usd_cover,
COALESCE(o.poster_amt_usd, '0') poster_usd_cover,
COALESCE(o.gloss_amt_usd, '0') gloss_usd_cover
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
GROUP BY 2,3,4,5,6,7,8,9,10,11

/* tento kód má za výsledek -> 6912 id, přesnější data, NEovlivnění NULL value*/
