--*********************** Transaction ddb Papyrus ***********************--

START TRANSACTION;
SELECT nomfou FROM fournis WHERE numfou = 120;    
UPDATE fournis SET nomfou = 'GROSBRIGAND' WHERE numfou = 120;  -- Cette transaction est déjà permanente quand je l'a rentre (ligne par ligne)...
SELECT nomfou FROM fournis WHERE numfou = 120; 

--**Normalement

-- ** La modification est visible mais pas enregistrée

-- ** Les données sont encore modifiables par d'autre utilisateur 

-- ** La transaction n'est pas terminée

-- ** Pour rendre la modification permanente il faudra ajouter un COMMIT; 

START TRANSACTION;
SELECT nomfou FROM fournis WHERE numfou = 120;    
UPDATE fournis SET nomfou = 'GROSBRIGAND' WHERE numfou = 120;
SELECT nomfou FROM fournis WHERE numfou = 120; 

COMMIT;

-- ** Pour annuler la transaction il faudra ajouter un ROLLBACK;

START TRANSACTION;
SELECT nomfou FROM fournis WHERE numfou = 120;    
UPDATE fournis SET nomfou = 'GROSBRIGAND' WHERE numfou = 120;
SELECT nomfou FROM fournis WHERE numfou = 120; 

ROLLBACK;
