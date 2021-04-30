---------------- Exercice 2 : base gescom ----------------

-- 1. Afficher par code produit, la somme des quantités commandées et le prix total correspondant. 

CREATE OR REPLACE VIEW v_Details
AS
SELECT pro_ref, SUM(ode_quantity) AS QteTot, SUM(ode_quantity * ode_unit_price) AS PrixTot
FROM products
INNER JOIN orders_details ON ode_pro_id = pro_id
GROUP BY pro_ref

-- 2. Afficher les ventes dont le code produit est ZOOM (affichage de toutes les colonnes de la table orders_details).
        -- produit 'ZOOM' n'existe pas donc création products/orders/orders_details --

CREATE OR REPLACE VIEW v_Ventes_Zoom
AS
SELECT * 
FROM orders_details
INNER JOIN products ON ode_pro_id = pro_id
WHERE pro_name = 'ZOOM'
