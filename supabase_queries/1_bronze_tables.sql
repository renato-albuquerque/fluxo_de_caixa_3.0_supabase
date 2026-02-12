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

-- ###
-- erro inconsistencia dado (coluna valor), upload do arquivo para a camada bronze. 
select
  sum(
    cast(
      replace(
        replace(valor, '.', ''),
      ',', '.'
      ) as numeric(14,2)
    )
  ) as total_bronze
from bronze.movimentos_raw;
-- Bronze (após upload): -4.034.895,76
-- Excel (correto): -5.876.243,17
-- Diferenca: ~1,84 Mi

select count(*) as qtd_bronze
from bronze.movimentos_raw;
-- 16792
-- 14932 linhas (excel), informacoes divergentes

-- diagnostico, pesquisa erro:
-- Excel está em formato pt-BR: 5.876.243,17
-- PostgreSQL/Supabase trabalha naturalmente com padrão en-US: 5876243.17

-- acao
-- foi criado nova coluna no dataset, valor_novo, formula inserida, =SUBSTITUIR(SUBSTITUIR(E2;".";"");",";".")
-- depois, nesta nova coluna, copiar colar com valores 

create table bronze.movimentos_novo_raw (
  tipo text,
  conta text,
  data text,
  banco text,
  valor_novo text   
);

-- upload realizado do novo csv
-- checks:
select
  sum(valor_novo::numeric(14,2)) as total_bronze
from bronze.movimentos_novo_raw;
-- Bronze (após upload): -5876243.17
-- Excel: -5.876.243,17
-- ingestao na camada bronze corrigida

select count(*) as qtd_bronze
from bronze.movimentos_novo_raw;
-- 14932 (ok)

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
select * from bronze.movimentos_novo_raw;
select * from bronze.plano_contas_raw;
select * from bronze.saldo_anterior_raw;

-- tabela com erro, ingestao para a camada bronze (fora de uso no projeto)
select * from bronze.movimentos_raw;

-- tabelas camada bronze criadas.
-- end.