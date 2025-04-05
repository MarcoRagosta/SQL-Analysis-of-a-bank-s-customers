/*
ANALISI DI UN SISTEMA BANCARIO

Creare una tabella denormalizzata che contenga indicatori comportamentali sul cliente, 
calcolati sulla base delle transazioni e del possesso prodotti. 
Lo scopo è creare le feature per un possibile modello di machine learning supervisionato.

Ogni indicatore va riferito al singolo id_cliente.

- Età
- Numero di transazioni in uscita su tutti i conti
- Numero di transazioni in entrata su tutti i conti
- Importo transato in uscita su tutti i conti
- Importo transato in entrata su tutti i conti
- Numero totale di conti posseduti
- Numero di conti posseduti per tipologia (un indicatore per tipo)
- Numero di transazioni in uscita per tipologia (un indicatore per tipo)
- Numero di transazioni in entrata per tipologia (un indicatore per tipo)
- Importo transato in uscita per tipologia di conto (un indicatore per tipo)
- Importo transato in entrata per tipologia di conto (un indicatore per tipo)
*/

/*Per svolgere il progetto, creo tante temporary table per poi effettuare un join finale costruendo la tabella con le info desiderate. */


USE banca;
SHOW TABLES;
 
DESCRIBE cliente;  # per il cliente abbaimo id_cliente, nome, cognome e data di nascita
DESCRIBE conto;   # per il conto abbiamo id_conto, id_cliente, id_tipo_conto
DESCRIBE tipo_conto;  # per il tipo conto abbiamo id_tipo_conto, desc_tipo_conto
DESCRIBE tipo_transazione;  # per il tipo di transazione abbiamo id_tipo_transazione, desc_tipo_trans, segno
DESCRIBE transazioni;  # per le transazioni abbiamo data, id_tipo_trans, importo e id_conto



# Vediamo cosa c'è dentro le singole tabelle

select * from banca.cliente
select * from banca.conto
select * from banca.tipo_conto
select * from banca.tipo_transazione
select * from banca.transazioni


-- Creiamo una temporary table con l'età e vediamone il contenuto

create temporary table banca.temp_età as select id_cliente, round(datediff(current_date(), data_nascita)/365) as età from banca.cliente

select * from banca.temp_età


-- Creiamo una temporary table per le transazioni in uscita su tutti i conti

create temporary table banca.num_trans_uscita as
select 
    cont.id_cliente, 
    count(tipo_trans.segno) as numero_transazioni_uscita
from banca.transazioni trans 
left join banca.conto cont                       # left join perchè vogliamo tutte le righe della colonna di sinistra anche se non esistono delle corrispondenze in quella di destra
on cont.id_conto = trans.id_conto
left join banca.tipo_transazione tipo_trans
on tipo_trans.id_tipo_transazione = trans.id_tipo_trans
where segno = '-'
group by 1;

select * from banca.num_trans_uscita


-- Creiamo una temporary table per le transazioni in entrata su tutti i conti

create temporary table banca.num_trans_entrata as
select 
    cont.id_cliente, 
    count(tipo_trans.segno) as numero_transazioni_entrata
from banca.transazioni trans 
left join banca.conto cont                       # left join perchè vogliamo tutte le righe della colonna di sinistra anche se non esistono delle corrispondenze in quella di destra
on cont.id_conto = trans.id_conto
left join banca.tipo_transazione tipo_trans
on tipo_trans.id_tipo_transazione = trans.id_tipo_trans
where segno = '+'
group by 1;

select * from banca.num_trans_entrata


-- Creiamo una temporary table per l'importo transato in uscita su tutti i conti

create temporary table banca.importo_trans_uscita as
select
cont.id_cliente,
round(sum(trans.importo),3) as importo_transato_uscita
from banca.transazioni trans
left join banca.conto cont
on cont.id_conto = trans.id_conto
left join banca.tipo_transazione tipo_trans
on tipo_trans.id_tipo_transazione = trans.id_tipo_trans
where segno ='-'
group by 1 

select * from banca.importo_trans_uscita


-- Creiamo una temporary table per l'importo transato in entrata su tutti i conti

create temporary table banca.importo_trans_entrata as
select
cont.id_cliente,
round(sum(trans.importo),3) as importo_transato_entrata
from banca.transazioni trans
left join banca.conto cont
on cont.id_conto = trans.id_conto
left join banca.tipo_transazione tipo_trans
on tipo_trans.id_tipo_transazione = trans.id_tipo_trans
where segno ='+'
group by 1 

select * from banca.importo_trans_entrata


-- Creiamo una temporary table il numero di conti posseduti

create temporary table banca.conti_posseduti as
select
id_cliente,
count(id_tipo_conto) as numero_conti
from banca.conto
group by id_cliente

select * from banca.conti_posseduti


-- Creiamo una temporary table il numero di conti posseduti per tipologia

create temporary table banca.tipologia_conti as
select 
cont.id_cliente, 
count(case when tipo_cont.id_tipo_conto = '0' then 1 else null end) conto_base,
count(case when tipo_cont.id_tipo_conto = '1' then 1 else null end) conto_business, 
count(case when tipo_cont.id_tipo_conto = '2' then 1 else null end) conto_privati, 
count(case when tipo_cont.id_tipo_conto = '3' then 1 else null end) conto_famiglie
from banca.conto cont
left join banca.tipo_conto tipo_cont
on cont.id_tipo_conto = tipo_cont.id_tipo_conto
group by 1 

select * from banca.tipologia_conti


-- Creiamo una temporary table il numero di transazioni in uscita per tipologia di conto 

create temporary table  banca.numero_tipo_trans_uscita as
select cont.id_cliente,
count(case when tipo_trans.desc_tipo_trans='Acquisto su Amazon' then 1 else null end) trans_uscita_amazon,
count(case when tipo_trans.desc_tipo_trans='Rata mutuo' then 1 else null end) trans_uscita_mutuo,
count(case when tipo_trans.desc_tipo_trans='Hotel' then 1 else null end) trans_uscita_hotel,
count(case when tipo_trans.desc_tipo_trans='Biglietto aereo' then 1 else null end) trans_uscita_aereo,
count(case when tipo_trans.desc_tipo_trans='Supermercato' then 1 else null end) trans_uscita_supermercato
from banca.transazioni trans 
left join banca.conto cont
on cont.id_conto=trans.id_conto
left join banca.tipo_transazione tipo_trans
on tipo_trans.id_tipo_transazione=trans.id_tipo_trans
group by 1;

select * from banca.numero_tipo_trans_uscita

-- Creiamo una temporary table il numero di transazioni in entrata per tipologia di conto 

create temporary table  banca.numero_tipo_trans_entrata as
select cont.id_cliente,
count(case when tipo_trans.desc_tipo_trans='Stipendio' then 1 else null end) trans_entrata_stipendio,
count(case when tipo_trans.desc_tipo_trans='Pensione' then 1 else null end) trans_entrata_pensione,
count(case when tipo_trans.desc_tipo_trans='Dividendi' then 1 else null end) trans_entrata_dividendi
from banca.transazioni trans 
left join banca.conto cont
on cont.id_conto=trans.id_conto
left join banca.tipo_transazione tipo_trans
on tipo_trans.id_tipo_transazione=trans.id_tipo_trans
group by 1;

select * from banca.numero_tipo_trans_entrata


-- Creiamo una temporary table per l'importo transato in uscita per tipologia di conto

create temporary table banca.importo_tipo_trans_uscita as
select
cont.id_cliente,
sum(case when cont.id_tipo_conto = '0' then 1 else null end) importo_uscita_conto_base,
sum(case when cont.id_tipo_conto = '1' then 1 else null end) importo_uscita_conto_business, 
sum(case when cont.id_tipo_conto = '2' then 1 else null end) importo_uscita_conto_privati, 
sum(case when cont.id_tipo_conto = '3' then 1 else null end) importo_uscita_conto_famiglie
from banca.transazioni trans
left join banca.conto cont
on cont.id_conto = trans.id_conto
left join banca.tipo_transazione tipo_trans
on tipo_trans.id_tipo_transazione = trans.id_tipo_trans
where segno = '-'
group by 1

select * from banca.importo_tipo_trans_uscita


-- Creiamo una temporary table per l'importo transato in entrata per tipologia di conto

create temporary table banca.importo_tipo_trans_entrata as
select
cont.id_cliente,
sum(case when cont.id_tipo_conto = '0' then 1 else null end) importo_entrata_conto_base,
sum(case when cont.id_tipo_conto = '1' then 1 else null end) importo_entrata_conto_business, 
sum(case when cont.id_tipo_conto = '2' then 1 else null end) importo_entrata_conto_privati, 
sum(case when cont.id_tipo_conto = '3' then 1 else null end) importo_entrata_conto_famiglie
from banca.transazioni trans
left join banca.conto cont
on cont.id_conto = trans.id_conto
left join banca.tipo_transazione tipo_trans
on tipo_trans.id_tipo_transazione = trans.id_tipo_trans
where segno = '+'
group by 1

select * from banca.importo_tipo_trans_entrata

-- Uniamo tutte le temporary table create per creare la tabella finale 
create table banca.analisi_clienti as
select *
from banca.temp_età età
left join banca.num_trans_uscita ntu using (id_cliente)
left join banca.num_trans_entrata nte using (id_cliente)
left join banca.importo_trans_uscita itu using (id_cliente)
left join banca.importo_trans_entrata ite using (id_cliente)
left join banca.conti_posseduti cp using (id_cliente)
left join banca.tipologia_conti tp using (id_cliente)
left join banca.numero_tipo_trans_uscita nttu using (id_cliente)
left join banca.numero_tipo_trans_entrata ntte using (id_cliente)
left join banca.importo_tipo_trans_uscita ittu using (id_cliente)
left join banca.importo_tipo_trans_entrata itte using (id_cliente)

select * from banca.analisi_clienti