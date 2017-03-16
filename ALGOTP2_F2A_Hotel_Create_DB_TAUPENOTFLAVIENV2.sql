PRAGMA Foreign_Keys= ON;

create table TTITRE(
	TIT_CODE char (8) not null,
	TIT_LIBELLE char (32),
	primary key (TIT_CODE) );
	
create table TCLIENT(
	CLI_ID int (10) not null,
	CLI_NOM char (32) not null,
	CLI_PRENOM char (25) not null,
	CLI_ENSEIGNE char (100),
	TIT_CODE char (8) not null,
	primary key (CLI_ID),
	foreign key (TIT_CODE) references TTITRE on delete no action on update cascade );
	
create table TADRESSE(
	ADR_ID int (10) not null,
	CLI_ID int (10) not null,
	ADR_LIGNE1 char (32) not null,
	ADR_LIGNE2 char (32),
	ADR_LIGNE3 char (32),
	ADR_LIGNE4 char (32),
	ADR_CP char (5) not null,
	ADR_VILLE char (32) not null,
	primary key (ADR_ID),
	foreign key (CLI_ID) references TCLIENT on delete no action on update cascade );
	
create table TEMAIL(
	EML_ID int (10) not null,
	CLI_ID int (10) not null,
	EML_ADRESSE char (100) not null,
	EML_LOCALISATION char (64) not null,
	primary key (EML_ID),
	foreign key (CLI_ID) references TCLIENT on delete no action on update cascade );
	
create table TTYPE(
	TYP_CODE char (8) not null,
	TYP_LIBELLE char (32),
	primary key (TYP_CODE) );
	
create table TTELEPHONE(
	TEL_ID int (10) not null,
	TYP_CODE char (8) not null,
	CLI_ID int (10) not null,
	TEL_NUMERO char (20) not null,
	TEL_LOCALISATION char (64),
	primary key (TEL_ID),
	foreign key (CLI_ID) references TCLIENT on delete no action on update cascade,
	foreign key (TYP_CODE) references TTYPE on delete no action on update cascade );
	
create table TFACTURE(
	FAC_ID int (10) not null,
	CLI_ID int (10) not null,
	PMT_CODE char (8),
	FAC_DATE date not null,
	FAC_PMT_DATE date,
	primary key (FAC_ID),
	foreign key (CLI_ID) references TCLIENT on delete no action on update cascade ); --En théorie PMT_CODE devrait aussi être une foreign key, mais...--
	
create table TLIGNEFACTURE(
	LIF_ID int (10) not null,
	FAC_ID int (10) not null,
	LIF_QTE int(5) not null,
	LIF_REMISEPOURCENT int(3),
	LIF_REMISEMONTANT int (5),
	LIF_MONTANT int (5) not null,
	LIF_TAUXTVA int(3) not null,
	primary key (LIF_ID),
	foreign key (FAC_ID) references TFACTURE on delete no action on update cascade );
	
create table TMODEPAIEMENT(
	PMT_CODE char (8) not null,
	PMT_LIBELLE char (64),
	primary key (PMT_CODE) );

create table TPLANNING(
	PLN_JOUR date not null,
	primary key (PLN_JOUR) );
	
create table TCHAMBRE(
	CHB_ID int (10) not null,
	CHB_NUMERO int (10) not null,
	CHB_ETAGE char (3) not null,
	CHB_BAIN int (1) not null,
	CHB_DOUCHE int (1) not null,
	CHB_WC int (1) not null,
	CHB_COUCHAGE int (2) not null,
	CHB_POSTETEL char (3) not null,
	primary key (CHB_ID) );

create table TJCHBPLNCLI(
	CLI_ID int (10) not null,
	CHB_ID int (10) not null,
	PLN_JOUR date not null,
	CHB_PLN_CLI_NBPERS int (3),
	CHB_PLN_CLI_RESERVE int (1) not null,
	CHB_PLN_CLI_OCCUPE int (1) not null,
	primary key (CLI_ID, CHB_ID, PLN_JOUR),
	foreign key (CLI_ID) references TCLIENT on delete no action on update cascade,
	foreign key (CHB_ID) references TCHAMBRE on delete no action on update cascade,
	foreign key (PLN_JOUR) references TPLANNING on delete no action on update cascade);
	
create table TTARIF(
	TRF_DATEDEBUT date not null,
	TRF_TAUXTAXES decimal(3,2) not null,
	TRF_PETITDEJEUNER decimal(5,2) not null,
	primary key (TRF_DATEDEBUT) );
	
create table TJTRFCHB(
	CHB_ID int (10) not null,
	TRF_DATEDEBUT date not null,
	TRF_CHB_PRIX decimal (5,2) not null,
	foreign key (CHB_ID) references TCHAMBRE on delete no action on update cascade,
	foreign key (TRF_DATEDEBUT) references TTARIF on delete no action on update cascade);