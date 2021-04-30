--*********************** Procédures stockées ***********************--

---------------- Exercice 1 : ----------------
-- 1. Créez la procédure stockée Lst_Supplier correspondant à la requête "afficher le nom des fournisseurs pour lesquels une commande a été passée".

DELIMITER |

CREATE PROCEDURE Lst_Supplier()
BEGIN

    SELECT sup_name 
    FROM suppliers
    JOIN products ON pro_sup_id = sup_id
    JOIN orders_details ON ode_pro_id = pro_id
    GROUP BY sup_name;

END |

DELIMITER ;

---------------- Exercice 2 : ----------------
-- 2. Créer la procédure stockée Lst_Rush_Orders, qui liste les commandes ayant le libelle "commande urgente".

DELIMITER |

CREATE PROCEDURE Lst_Rush_Orders()
BEGIN
    SELECT ord_id
    FROM orders
    WHERE ord_status = "Commande urgente";

END |

DELIMITER ;

---------------- Exercice 3 : ----------------
-- 3. Créer la procédure stockée CA_Supplier, qui pour un code fournisseur et une année entrée en paramètre, calcule et restitue le CA potentiel de ce fournisseur pour l'année souhaitée.

         --3. On exécutera la requête que si le code fournisseur est valide, c'est-à-dire dans la table suppliers.

                    --3.  Création de la vue des Fournisseurs triés par année avec le C.A pour vérification.

                    CREATE OR REPLACE VIEW v_suppliers_CA
                    AS
                        SELECT sup_id, sup_name, YEAR(ord_order_date) AS d_date, TRUNCATE((sum(ode_unit_price - ode_unit_price / 100 * ode_discount) * ode_quantity), 2) AS CA
                        FROM orders AS o
                        JOIN orders_details AS ode ON o.ord_id = ode.ode_ord_id
                        JOIN products AS p ON ode.ode_pro_id = p.pro_id
                        JOIN suppliers AS s ON p.pro_sup_id = s.sup_id
                        GROUP BY sup_id, d_date
                        ORDER BY sup_name, d_date ASC;


DELIMITER |

CREATE PROCEDURE sp_CA_Supplier(
    IN s_sup_id INT(10), -- donnée d'entrer
    IN d_date INT(4), -- donnée d'entrer
    OUT c_CA DECIMAL(7,2)-- donnée de sortie
)

BEGIN

DECLARE s_existe INT(10); -- déclaration de variable pour le suppliers


SET s_existe = (SELECT sup_id
                FROM suppliers
                WHERE sup_id = s_sup_id);    -- récupère les données de la ddb : comparaison avec les données d'entrée pour suppliers

IF s_existe IS NOT NULL
THEN
            SELECT TRUNCATE((sum(ode_unit_price - ode_unit_price / 100 * ode_discount) * ode_quantity), 2) INTO c_CA
            FROM orders AS o
            JOIN orders_details AS ode ON o.ord_id = ode.ode_ord_id
            JOIN products AS p ON ode.ode_pro_id = p.pro_id
            JOIN suppliers AS s ON p.pro_sup_id = s.sup_id
            WHERE s_sup_id = sup_id AND d_date = YEAR(ord_order_date); -- requête calculant le chiffre d'affaire
ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This supplier does not exist'; -- message d'erreur suppliers_id = NULL
END IF;

IF ISNULL(c_CA)
THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No data for this year'; -- message d'erreur ord_order_date = NULL
END IF;
END |

DELIMITER ;


------ Execution ------

SET @ca = 0;
        CALL sp_CA_Supplier (3, 2006, @ca);  -- requête valide
        SELECT @ca AS "Chiffre d'affaire"

SET @ca = 0;
        CALL sp_CA_Supplier (3, 2028, @ca);  -- requête date NULL -- message d'erreur 'No data for this year'
        SELECT @ca AS "Chiffre d'affaire"

SET @ca = 0;
        CALL sp_CA_Supplier (12, 2006, @ca);  -- requête suppliers NULL -- message d'erreur 'This supplier does not exist'
        SELECT @ca AS "Chiffre d'affaire"

