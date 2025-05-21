-- NIVELL 1

-- EXERCICI 2
-- Llistat dels països que estan fent compres.
SELECT DISTINCT country
FROM company
INNER JOIN transaction
ON company.id = transaction.company_id;


-- Des de quants països es realitzen les compres.
SELECT COUNT(DISTINCT country)
FROM company
INNER JOIN transaction
ON company.id = transaction.company_id;

-- Identifica la companyia amb la mitjana més gran de vendes.

SELECT company_name, ROUND(AVG(amount),2) as average
FROM company
JOIN transaction
ON company.id = transaction.company_id
WHERE declined = 0
GROUP BY company_name
ORDER BY average DESC
LIMIT 1;

-- EXERCICI 3

-- Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT id, company_id
FROM transaction
WHERE company_id IN (SELECT id
		FROM company
		WHERE country = 'germany');

-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT company_name
FROM company
WHERE id IN (   SELECT DISTINCT company_id
				FROM transaction
				WHERE amount > (SELECT ROUND(AVG(amount),2)
								FROM transaction));

-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT company_name
FROM company
WHERE id NOT IN (   SELECT DISTINCT company_id
					FROM transaction);



-- NIVELL 2

-- EXERCICI 1

-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
-- Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT DATE_FORMAT (timestamp, '%d/%m/%y') AS day, SUM(amount) AS total_vendes_dia
FROM transaction
WHERE declined = 0
GROUP BY day
ORDER BY total_vendes_dia DESC
LIMIT 5;

-- EXERCICI 2

-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.

SELECT country, ROUND(AVG(amount),2) as media
FROM company
INNER JOIN transaction
ON company.id = transaction.company_id
WHERE declined = 0
GROUP BY country
ORDER BY media DESC;

-- EXERCICI 3

-- la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

-- JOIN i Subqueries

SELECT transaction.id, company_id
FROM transaction
INNER JOIN (SELECT id
			FROM company
			WHERE country IN (  SELECT country 
								FROM company
								WHERE company_name = "Non Institute")AND company_name <> "Non Institute") AS filtre
ON transaction.company_id = filtre.id;

-- Subqueries

SELECT id, company_id
FROM transaction
WHERE company_id IN (   SELECT id
						FROM company
						WHERE country IN (  SELECT country 
											FROM company
											WHERE company_name = "Non Institute")AND company_name <> "Non Institute");


-- NIVELL 3

-- EXERCICI 1

-- Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 100 i 200 euros
-- i en alguna d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. 
-- Ordena els resultats de major a menor quantitat.

SELECT DISTINCT company_name, phone, country, fecha, amount
FROM company
INNER JOIN (SELECT DATE_FORMAT (timestamp, '%d/%m/%y') AS fecha, amount, company_id
			FROM transaction
			WHERE ((DATE(timestamp) = "2021-04-29") OR (DATE(timestamp) = "2021-07-20") OR (DATE(timestamp) = "2022-03-13"))AND amount BETWEEN 100 AND 200) AS filtro
ON company.id = filtro.company_id
ORDER BY amount DESC;


-- Un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.

WITH filtro AS (SELECT COUNT(amount) AS quant_trans, company_id
				FROM transaction
				GROUP BY company_id)
SELECT company_name, CASE 
						WHEN quant_trans < 4 THEN "Menys de 4 transaccions"
						ELSE  "Més de 4 transaccions"
					 END transaccions
FROM filtro
INNER JOIN company
ON filtro.company_id = company.id
ORDER BY 2 DESC;

