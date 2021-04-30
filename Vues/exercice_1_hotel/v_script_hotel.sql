
---------------- Exercice 1 : base hotel ----------------

-- 1. Afficher la liste des hôtels avec leur station. 

CREATE VIEW v_hotel_station 
AS 
SELECT sta_nom AS station, hot_nom AS hotel
FROM hotel INNER JOIN station ON hot_sta_id = sta_id

-- 2. Afficher la liste des chambres et leur hôtel.

CREATE OR REPLACE VIEW v_hotel_chambre 
AS 
SELECT cha_numero AS numero_de_chambre, hot_nom AS hotel
FROM chambre 
JOIN hotel ON cha_hot_id = hot_id 
JOIN station ON hot_sta_id = sta_id

-- 3. Afficher la liste des réservations avec le nom des clients

CREATE OR REPLACE VIEW v_reservation_client
AS
SELECT res_date AS reservation, CONCAT(cli_nom,' ',cli_prenom) AS Nom__Prenom FROM reservation 
JOIN client ON res_cli_id = cli_id 
JOIN chambre ON res_cha_id = cha_id 
JOIN hotel ON cha_hot_id = hot_id

-- 4. Afficher la liste des chambres avec le nom de l'hôtel et le nom de la station

CREATE OR REPLACE VIEW v_station_hotel_chambre 
AS 
SELECT cha_numero AS numero_de_chambre, hot_nom AS hotel, sta_nom AS station
FROM chambre 
JOIN hotel ON cha_hot_id = hot_id 
JOIN station ON hot_sta_id = sta_id

-- 5. Afficher les réservations avec le nom du client et le nom de l'hôtel

CREATE OR REPLACE VIEW v_reservation_client_hotel
AS
SELECT res_date AS reservation, CONCAT(cli_nom,' ',cli_prenom) AS Nom__Prenom, hot_nom AS hotel FROM reservation 
JOIN client ON res_cli_id = cli_id 
JOIN chambre ON res_cha_id = cha_id 
JOIN hotel ON cha_hot_id = hot_id
