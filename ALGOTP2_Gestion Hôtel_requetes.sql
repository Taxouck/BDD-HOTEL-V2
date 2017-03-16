--Nombre de clients
SELECT count(CLI_ID) AS 'Nombre de Clients' FROM TCLIENT;
--Les clients triés sur le titre et le nom
SELECT * FROM TCLIENT ORDER BY TIT_CODE, CLI_NOM;
--Les clients triés sur le libellé du titre et le nom
SELECT CLI_ID,CLI_NOM,CLI_PRENOM,TCLIENT.TIT_CODE,CLI_ENSEIGNE FROM TCLIENT,TTITRE WHERE TCLIENT.TIT_CODE=TTITRE.TIT_CODE ORDER BY TTITRE.TIT_LIBELLE, CLI_NOM;
--Les clients commençant par 'B'
SELECT * FROM TCLIENT WHERE upper(CLI_NOM) LIKE upper('B%');
--Les clients homonymes
SELECT * FROM TCLIENT AS TC WHERE CLI_NOM in (SELECT CLI_NOM FROM TCLIENT AS TCLI WHERE TC.CLI_ID!=TCLI.CLI_ID);
--Nombre de titres différents
SELECT count(TIT_CODE) as 'Nombre de Titres' from TTITRE;
--Nombre d'enseignes
SELECT count(distinct CLI_ENSEIGNE) as 'Nombre d enseignes' from TCLIENT;
--Les clients qui représentent une enseigne 
SELECT * from TCLIENT WHERE CLI_ENSEIGNE not null;
--Les clients qui représentent une enseigne de transports
SELECT * from TCLIENT WHERE upper(CLI_ENSEIGNE) like upper('%transport%');
--Nombre d'hommes,Nombres de femmes, de demoiselles, Nombres de sociétés

--Nombre d'emails
select count(EML_ID) FROM TEMAIL;
--Client sans email 
select * FROM TCLIENT where CLI_ID not in (select CLI_ID from TEMAIL);
--Clients sans téléphone 
select * FROM TCLIENT where CLI_ID not in (select CLI_ID from TTELEPHONE);
--Les phones des clients
select * FROM TTELEPHONE;
--Ventilation des phones par catégorie
select * FROM TTELEPHONE order by TYP_CODE;
--Les clients ayant plusieurs téléphones
select * FROM TCLIENT as TCLI where CLI_ID in (select distinct CLI_ID FROM TTELEPHONE as TT WHERE TT.CLI_ID in (SELECT TTEL.CLI_ID FROM TTELEPHONE AS TTEL WHERE TT.TEL_ID!=TTEL.TEL_ID));
--Clients sans adresse:
select * FROM TCLIENT as TCLI where CLI_ID not in (select CLI_ID FROM TADRESSE);
--Clients sans adresse mais au moins avec mail ou phone 
select * FROM TCLIENT as TCLI where CLI_ID not in (select CLI_ID FROM TADRESSE) AND CLI_ID in ((SELECT CLI_ID FROM TEMAIL) OR (SELECT CLI_ID FROM TTELEPHONE));
--Dernier tarif renseigné
select * FROM TTARIF where TRF_DATE_DEBUT >= ( SELECT max(TRF_DATE_DEBUT) FROM TTARIF);
--Tarif débutant le plus tôt 
select * FROM TTARIF where TRF_DATE_DEBUT <= ( SELECT min(TRF_DATE_DEBUT) FROM TTARIF);
--Différentes Années des tarifs
select distinct strftime('%Y',TRF_DATE_DEBUT) FROM TTARIF;
--Nombre de chambres de l'hotel 
select count(CHB_ID) FROM TCHAMBRE;
--Nombre de chambres par étage

--Chambres sans telephone
select CHB_ID FROM TCHAMBRE where CHB_POSTE_TEL=null;
--Existence d'une chambre n°13 ?
select CHB_ID FROM TCHAMBRE where CHB_NUMERO=13;
--Chambres avec sdb
select CHB_ID FROM TCHAMBRE where CHB_BAIN=1;
--Chambres avec douche
select CHB_ID FROM TCHAMBRE where CHB_DOUCHE=1;
--Chambres avec WC
select CHB_ID FROM TCHAMBRE where CHB_WC=1;
--Chambres sans WC séparés

--Quels sont les étages qui ont des chambres sans WC séparés ?
select distinct CHB_ETAGE FROM TCHAMBRE where
--Nombre d'équipements sanitaires par chambre trié par ce nombre d'équipement croissant
select CHB_ID, CHB_BAIN+CHB_DOUCHE+CHB_WC as 'nb equipement' FROM TCHAMBRE ORDER BY CHB_BAIN+CHB_DOUCHE+CHB_WC;
--Chambres les plus équipées et leur capacité
select CHB_ID, CHB_COUCHAGE as capacite FROM TCHAMBRE where CHB_BAIN+CHB_DOUCHE+CHB_WC >= (select max(CHB_BAIN+CHB_DOUCHE+CHB_WC) FROM TCHAMBRE);
--Repartition des chambres en fonction du nombre d'équipements et de leur capacité

--Nombre de clients ayant utilisé une chambre
select count(distinct CLI_ID) FROM TFACTURE;
--Clients n'ayant jamais utilisé une chambre (sans facture)
select CLI_ID FROM TCLIENT WHERE CLI_ID not in (SELECT CLI_ID FROM TFACTURE);
--Nom et prénom des clients qui ont une facture
select CLI_NOM, CLI_PRENOM FROM TCLIENT WHERE CLI_ID in (SELECT CLI_ID FROM TFACTURE);
--Nom, prénom, telephone des clients qui ont une facture
select CLI_NOM, CLI_PRENOM, TEL_NUMERO FROM TCLIENT,TTELEPHONE WHERE TCLIENT.CLI_ID=TTELEPHONE.CLI_ID and TCLIENT.CLI_ID in (SELECT CLI_ID FROM TFACTURE);
--Attention si email car pas obligatoire : jointure externe

--Adresse où envoyer factures aux clients

--Répartition des factures par mode de paiement (libellé)

--Répartition des factures par mode de paiement 

--Différence entre ces 2 requêtes ? 

--Factures sans mode de paiement 
SELECT * FROM TFACTURE WHERE PMT_CODE="" OR PMT_CODE=null;
--Repartition des factures par Années

--Repartition des clients par ville

--Montant TTC de chaque ligne de facture (avec remises)

--Classement du montant total TTC (avec remises) des factures

--Tarif moyen des chambres par années croissantes

--Tarif moyen des chambres par étage et années croissantes

--Chambre la plus cher et en quelle année
SELECT TCHAMBRE.CHB_ID,CHB_NUMERO, strftime('%Y',TRF_DATE_DEBUT) FROM TCHAMBRE,TJTRFCHB WHERE TCHAMBRE.CHB_ID=TJTRFCHB.CHB_ID AND TCHAMBRE.CHB_ID=(SELECT CHB_ID FROM TJTRFCHB WHERE TRF_CHB_PRIX >= (select max(TRF_CHB_PRIX) FROM TJTRFCHB)) AND strftime('%Y',TRF_DATE_DEBUT)=(SELECT strftime('%Y',TRF_DATE_DEBUT) FROM TJTRFCHB WHERE TRF_CHB_PRIX >= (select max(TRF_CHB_PRIX) FROM TJTRFCHB));
--Chambre la plus cher par année 

--Clasement décroissant des réservation des chambres 

--Classement décroissant des meilleurs clients par nombre de réservations

--Classement des meilleurs clients par le montant total des factures

--Factures payées le jour de leur édition
SELECT * FROM TFACTURE WHERE FAC_DATE=FAC_PMT_DATE;
--Facture dates et Délai entre date de paiement et date d'édition de la facture