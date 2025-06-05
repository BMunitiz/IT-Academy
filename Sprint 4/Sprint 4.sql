-- NIVELL 1

-- Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui,
-- almenys 4 taules de les quals puguis realitzar les següents consultes:

CREATE SCHEMA modeling_2;
USE modeling_2;

-- Primer crearem les taules amb les seves PRIMARY KEYS i FOREIGN KEYS

CREATE TABLE companies(
company_id VARCHAR (30) PRIMARY KEY,
company_name VARCHAR (255),
phone VARCHAR (30),
email VARCHAR (50),
country VARCHAR (50),
website VARCHAR (255)
);


CREATE TABLE data_user(
id VARCHAR (30) PRIMARY KEY,
name VARCHAR (30),
surname VARCHAR (30),
phone VARCHAR (30),
email VARCHAR (50),
birth_date VARCHAR (50),
country VARCHAR (50),
city VARCHAR (50),
postal_code VARCHAR (50),
address VARCHAR (255)
);


CREATE TABLE credit_cards(
id VARCHAR (30) PRIMARY KEY,
user_id VARCHAR (30) ,
iban VARCHAR (200),
pan VARCHAR (200),
pin VARCHAR (200),
cvv VARCHAR (30),
track1 VARCHAR (255),
track2 VARCHAR (255),
expiring_date VARCHAR (100),
CONSTRAINT user_id FOREIGN KEY(user_id) REFERENCES data_user(id)
);



CREATE TABLE transactions(
id VARCHAR (255) PRIMARY KEY,
card_id VARCHAR (30),
business_id VARCHAR (30),
timestamp TIMESTAMP,
amount DECIMAL(10,2),
declined TINYINT (1),
product_ids VARCHAR (30),
user_id VARCHAR (30),
lat FLOAT,
longitude FLOAT,
CONSTRAINT card_id FOREIGN KEY(card_id) REFERENCES credit_cards(id),
CONSTRAINT business_id FOREIGN KEY(business_id) REFERENCES companies(company_id),
CONSTRAINT t_user_id FOREIGN KEY(user_id) REFERENCES data_user(id)
);



-- Ara inserirem les dades a les taules

LOAD DATA LOCAL INFILE '/Users/borja/Desktop/IT Academy/Especialització/SQL/Sprint 4/companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT *
FROM companies;



LOAD DATA LOCAL INFILE '/Users/borja/Desktop/IT Academy/Especialització/SQL/Sprint 4/users_ca.csv'
INTO TABLE data_user
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


LOAD DATA LOCAL INFILE '/Users/borja/Desktop/IT Academy/Especialització/SQL/Sprint 4/users_uk.csv'
INTO TABLE data_user
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


LOAD DATA LOCAL INFILE '/Users/borja/Desktop/IT Academy/Especialització/SQL/Sprint 4/users_usa_1.csv'
INTO TABLE data_user
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT *
FROM data_user;


LOAD DATA LOCAL INFILE '/Users/borja/Desktop/IT Academy/Especialització/SQL/Sprint 4/credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT *
FROM credit_cards;


LOAD DATA LOCAL INFILE '/Users/borja/Desktop/IT Academy/Especialització/SQL/Sprint 4/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SELECT *
FROM transactions;




-- EXERCICI 1 
-- Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.


SELECT name, surname
FROM data_user
WHERE data_user.id IN (SELECT user_id
						FROM transactions
						GROUP BY user_id
						HAVING Count(id) > 30);


-- EXERCICI 2
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.

SELECT  company_name, iban, ROUND(AVG(amount),2) AS mitjana
FROM transactions
INNER JOIN companies
ON (business_id = company_id)
INNER JOIN credit_cards
ON card_id = credit_cards.id
WHERE company_name = "Donec Ltd"
GROUP BY company_name, iban;


-- NIVELL 2


-- Un cop tenim les taules amb les seves dades podem refer les relacions entre les taules i eliminar aquells camps que no necessitem
-- Primer eliminarem el camp user_id de la taula TRANSACTIONS ja que es pot accedir a aquesta taula a traves de la taula CREDIT_CARDS,
-- així tindrem un esquema de floc de neu.

ALTER TABLE transactions
DROP CONSTRAINT t_user_id;

ALTER TABLE transactions
DROP COLUMN user_id;



-- EXERCICI 1

-- Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes tres transaccions van ser declinades
-- i genera la següent consulta:


CREATE TABLE targetes_decl AS 
SELECT DISTINCT(transactions.card_id), times_decl AS decl_mes_de_3, STR_TO_DATE(expiring_date, "%m/%d/%y") AS expired,
CASE 
			WHEN times_decl >= 3  THEN "Targeta inactiva"
			ELSE "Targeta activa"
END estat
FROM transactions
LEFT JOIN credit_cards
ON transactions.card_id = credit_cards.id
LEFT JOIN (SELECT card_id, COUNT(card_id) AS times_decl
		   FROM transactions
		   WHERE transactions.timestamp IN (SELECT * FROM (
														   SELECT t.timestamp
														   FROM transactions t
														   WHERE t.card_id = transactions.card_id AND t.declined = 1
														   ORDER BY timestamp DESC
														   LIMIT 3
														   ) AS time
											)
			GROUP BY card_id
			HAVING COUNT(card_id)>=3
            ) AS last_decl
ON transactions.card_id = last_decl.card_id
ORDER BY card_id;


-- Quantes targetes estan actives?

SELECT COUNT(*) as targetes_actives
FROM targetes_decl
WHERE estat = "Targeta activa" AND expired > CURRENT_DATE;


-- NIVELL 3

-- EXERCICI 1

-- Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada,
-- tenint en compte que des de transaction tens product_ids. 

CREATE TABLE products(
id VARCHAR (30) PRIMARY KEY,
product_name VARCHAR (255),
price VARCHAR (30),
colour VARCHAR (30),
weight VARCHAR (50),
warehouse_id VARCHAR (50)
);

LOAD DATA LOCAL INFILE '/Users/borja/Desktop/IT Academy/Especialització/SQL/Sprint 4/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT *
FROM products;

-- Ara farem la relació entre PRODUCTS i TRANSACTIONS ja que es dona una relació N:M i hem de crear una taula intermitja per relacionar-les

CREATE TABLE trans_prods(
transactions_id VARCHAR (255),
product_id INT
);

-- per poder obtenir els ID dels productes de cada transacció utilitzarem una funció RECURSIVE per extreure de cada filera els ID que conté
-- i els inserim a la taula intermitja

INSERT INTO trans_prods 
WITH RECURSIVE trans_prod AS (
SELECT transactions.id AS trans_id,
CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(transactions.product_ids, ',', n),',', -1) AS UNSIGNED) AS prod_id,
1 AS n
FROM transactions
JOIN (
SELECT 1 AS n
UNION ALL SELECT 2
UNION ALL SELECT 3
UNION ALL SELECT 4
UNION ALL SELECT 5
) AS numbers
ON n <= 1 + (LENGTH(transactions.product_ids)-LENGTH(REPLACE(transactions.product_ids, ',','')))
)
SELECT trans_id, prod_id
FROM trans_prod;

-- comprobem que les dades introduïdes son correctes

SELECT * FROM trans_prods;


-- Un cop fet això creem les claus necessàries per connectar les taules PRODUCTS i TRANSACTIONS

ALTER TABLE trans_prods
ADD PRIMARY KEY (transactions_id, product_id),
ADD FOREIGN KEY (transactions_id) REFERENCES transactions(id),
ADD FOREIGN KEY (product_id) REFERENCES products(id);

-- Genera la següent consulta:

-- Necessitem conèixer el nombre de vegades que s'ha venut cada producte.

-- Com ja tenim una taula que relaciona les transaccions amb els productes podem fer la consulta directament


SELECT  products.id, product_name, COUNT(transactions_id) AS vegades_venut
FROM trans_prods
RIGHT JOIN products
ON products.id = product_id
GROUP BY product_name, products.id
ORDER BY vegades_venut DESC;