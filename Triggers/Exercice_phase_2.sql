--*********************** Triggers ddb gescom_afpa ***********************--

--1. Créer une table commander_articles.

--
-- Structure de la table `commander_articles`
--

DROP TABLE IF EXISTS `commander_articles`;
CREATE TABLE IF NOT EXISTS `commander_articles` (
  `codart` INT(10) UNSIGNED NOT NULL,
  `qte` INT NOT NULL,
  `date` DATE NOT NULL,

 FOREIGN KEY(`codart`) REFERENCES `products`(`pro_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 2. Créer un déclencheur after_products_update sur la table products.

DELIMITER |
CREATE TRIGGER after_update_products
AFTER UPDATE ON products 
FOR EACH ROW
BEGIN
 
    DECLARE t_pro_id INT; 
    DECLARE t_stock INT; -- déclaration donnée stock physique
    DECLARE t_stock_alert INT; -- déclaration donnée stock alerte
    SET t_pro_id = NEW.pro_id;
    SET t_stock = (SELECT pro_stock FROM products WHERE pro_id = NEW.pro_id);  -- récupère les données de la ddb : stock physique
    SET t_stock_alert = (SELECT pro_stock_alert FROM products WHERE pro_id = NEW.pro_id);  -- récupère les données de la ddb : stock alerte
    IF(t_stock < t_stock_alert) -- si stock psysique inférieur au stock alerte ligne ajouté à commander_articles
    THEN
    INSERT INTO commander_articles (codart, qte, date) VALUES (NEW.pro_id, t_stock_alert - t_stock, NOW()); -- ligne d'ajout codart, quantité, date de l'alerte
    END IF;
END |
DELIMITER ;


------ Modification ------

UPDATE products
SET pro_stock = 6 -- pro_stock > pro_stock_alert donc aucun changement
WHERE pro_id = 8

UPDATE products
SET pro_stock = 4 -- pro_stock < pro_stock_alert donc ligne ajouter avec qte = (stock alerte - stock physique) = 5 - 4 = 1
WHERE pro_id = 8

UPDATE products
SET pro_stock = 2 -- pro_stock < pro_stock_alert donc ligne ajouter avec qte = (stock alerte - stock physique) = 5 - 4 = 1
WHERE pro_id = 8
