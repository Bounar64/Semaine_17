--*********************** Triggers ddb commande_produit ***********************--


-- 1. ajoutez un produit dans une commande, vérifiez que le champ total est bien mis à jour.

DELIMITER |
CREATE TRIGGER maj_insert_total 
AFTER INSERT ON lignedecommande
FOR EACH ROW
BEGIN
    DECLARE id_c INT;
    DECLARE tot DOUBLE;
    SET id_c = NEW.id_commande; -- nous captons le numéro de commande concerné
    SET tot = (SELECT sum(prix * quantite) FROM lignedecommande WHERE id_commande = id_c); -- on recalcul le total
    UPDATE commande SET total = tot WHERE id = id_c; -- on stock le total dans la table commande
END |
DELIMITER ;

-- 2. Ce trigger ne fonctionne que lorsque l'on ajoute des produits, les modifications ou suppressions ne permettent pas de recalculer le total. Comment pourrait-on faire ?


-- Trigger Modifcation 

DELIMITER |
CREATE TRIGGER modif_maj_update_total 
AFTER UPDATE ON lignedecommande
FOR EACH ROW
BEGIN
    DECLARE id_c INT;
    DECLARE tot DOUBLE;
    SET id_c = NEW.id_commande; -- nous captons le numéro de commande concerné
    SET tot = (SELECT sum(prix * quantite) FROM lignedecommande WHERE id_commande = id_c); -- on recalcul le total
    UPDATE commande SET total = tot WHERE id = id_c; -- on stock le total dans la table commande
END |
DELIMITER ;

-- Trigger Suppression 

DELIMITER |
CREATE TRIGGER modif_maj_delete_total 
AFTER DELETE ON lignedecommande
FOR EACH ROW
BEGIN
    DECLARE id_c INT;
    DECLARE tot DOUBLE;
    SET id_c = OLD.id_commande; -- nous captons le numéro de commande concerné
    SET tot = (SELECT sum(prix * quantite) FROM lignedecommande WHERE id_commande = id_c); -- on recalcul le total
    UPDATE commande SET total = tot WHERE id = id_c; -- on stock le total dans la table commande
END |
DELIMITER ;

--3. Un champ remise était prévu dans la table commande. Comment pourrait-on le prendre en compte ?

-- recreer un trigger avec la remise pris en compte
-- exemple :

DELIMITER |
CREATE TRIGGER maj_insert_total 
AFTER INSERT ON lignedecommande
FOR EACH ROW
BEGIN
    DECLARE id_c INT;
    DECLARE tot DOUBLE;
    SET id_c = NEW.id_commande; -- nous captons le numéro de commande concerné
    SET tot = (SELECT sum((prix - prix / 100 * remise) * quantite) FROM lignedecommande WHERE id_commande = id_c); -- on recalcul le total
    UPDATE commande SET total = tot WHERE id = id_c; -- on stock le total dans la table commande
END |
DELIMITER ;
