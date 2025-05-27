-- NIVELL 1

-- EXERCICI 1
-- La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit.
-- La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules
-- ("transaction" i "company"). Després de crear la taula serà necessari que ingressis la informació del document denominat 
-- "dades_introduir_credit". Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.

CREATE TABLE IF NOT EXISTS credit_card 
(
id VARCHAR(15) PRIMARY KEY, 
iban VARCHAR(40) , 
pan VARCHAR(40), 
pin VARCHAR(10), 
cvv INT , 
expiring_date VARCHAR(20) );

SELECT *
FROM credit_card;

ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id)
REFERENCES credit_card (id);

-- EXERCICI 2
-- El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID CcU-2938.
-- La informació que ha de mostrar-se per a aquest registre és: R323456312213576817699999. 
-- Recorda mostrar que el canvi es va realitzar.

SELECT * -- Revisar la informació previa
FROM credit_card
WHERE id = "CcU-2938";


UPDATE credit_card -- Reemplaçar la informació
SET iban = "R323456312213576817699999"
WHERE id = "CcU-2938";


-- EXERCICI 3

-- En la taula "transaction" ingressa un nou usuari amb la següent informació:
-- Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
-- credit_card_id	CcU-9999
-- company_id	b-9999
-- user_id	9999
-- lat	829.999
-- longitude	-117.999
-- amount	111.11
-- declined	0


INSERT INTO company (id)
VALUES ("b-9999");

INSERT INTO credit_card (id)
VALUES ("CcU-9999");

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ("108B1D1D-5B23-A76C-55EF-C568E49A99DD", "CcU-9999", "b-9999", 9999, 829.999, -117.999, 111.11, 0);


-- EXERCICI 4

-- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_*card. 
-- Recorda mostrar el canvi realitzat.

SELECT *
FROM credit_card;

ALTER TABLE credit_card
DROP COLUMN pan;

-- NIVELL 2

-- EXERCICI 1

-- Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.

SELECT *
FROM transaction
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

DELETE FROM transaction
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

-- EXERCICI 2

-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions.
-- Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
-- Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
-- Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.


SELECT company_name AS company, phone, country, ROUND(AVG(amount),2) AS average
FROM company
JOIN transaction
ON company.id = company_id
WHERE declined = 0
GROUP BY company_id;





SELECT *
FROM VistaMarketing
ORDER BY average DESC;


-- EXERCICI 3

-- Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"

SELECT *
FROM VistaMarketing 
WHERE country = "Germany";


-- NIVELL 3

-- EXERCICI 1

-- Un company del teu equip va realitzar modificacions en la base de dades, però no recorda com les va realitzar.
-- Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:

-- Inserim el ID d'usuari "9999" que vam introduir al exercici 3 del nivell 1 i connectem la FOREIGN KEY.

INSERT INTO user (id)
VALUES ("9999");


ALTER TABLE transaction
ADD FOREIGN KEY (user_id)
REFERENCES user (id);

		-- A la taula company no hi es la columna de "website", l'hem d'eliminar

ALTER TABLE company
DROP COLUMN website;

		-- A la taula "user" a canviat el nom de "email" per "personal_email" i canviem el nom de la taula de USER a DATA_USER

ALTER TABLE user
RENAME COLUMN email to personal_email;

ALTER TABLE user
RENAME TO data_user;

		-- A la taula "credit_card" s'ha canviat el tipus de DATATYPE a les columnes "id" de VARCHAR(15) a VARCHAR(20),
        -- "iban" de VARCHAR(40) a VARCHAR(50),
        -- "pin" de VARCHAR(10) a VARCHAR(4) i s'ha afegit la columna "fecha_actual" DATE

ALTER TABLE credit_card
MODIFY COLUMN id VARCHAR(20),
MODIFY COLUMN iban VARCHAR(50),
MODIFY COLUMN pin VARCHAR(4),
ADD fecha_actual DATE
DEFAULT (CURRENT_DATE());


-- EXERCICI 2

-- L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent informació:
-- ID de la transacció
-- Nom de l'usuari/ària
-- Cognom de l'usuari/ària
-- IBAN de la targeta de crèdit usada.
-- Nom de la companyia de la transacció realitzada.
-- Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de nom columnes segons sigui necessari.


SELECT transaction.id AS IDTransaccio, name AS Nom, surname AS Cognom, iban AS IBANTargeta, company_name AS NomCompanyia
FROM transaction
INNER JOIN data_user
ON user_id = data_user.id
LEFT JOIN credit_card
ON credit_card_id = credit_card.id
LEFT JOIN company
ON company_id = company.id;

-- Mostra els resultats de la vista, ordena els resultats de manera descendent en funció de la variable ID de transaction.

SELECT *
FROM InformeTecnico
ORDER BY IDTransaccio DESC;
