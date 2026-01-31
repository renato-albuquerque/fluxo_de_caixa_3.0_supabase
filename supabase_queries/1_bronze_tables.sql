-- 1_bronze_tables

-- criar schemas
create schema if not exists bronze; 
create schema if not exists silver;
create schema if not exists gold;

-- datasets:
-- bancos.xlsx
-- movimentos.xlsx
-- planoContas.xlsx
-- saldoAnterior.xlsx

-- criar tabelas bronze
create table bronze.bancos_raw (
  banco_id text,
  banco text  
);

create table bronze.movimentos_raw (
  tipo text,
  conta text,
  data text,
  banco text,
  valor text   
);

create table bronze.plano_contas_raw (
  subgrupo_id integer,
  subgrupo text,
  conta_id integer,
  conta text
);

create table bronze.saldo_anterior_raw (
  banco_id text,
  valor text  
);

-- no menu "table editor", fazer upload dos arquivos csv para "popular" as tabelas

-- checar todas as tabelas
select * from bronze.bancos_raw;
select * from bronze.movimentos_raw;
select * from bronze.plano_contas_raw;
select * from bronze.saldo_anterior_raw;

-- tabelas camada bronze criadas.
-- end.