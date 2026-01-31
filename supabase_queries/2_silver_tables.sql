-- criar tabelas & realizar tratamento dos dados no schema/bd silver
-- comandos sql abaixo: criar/inserir/tratar dados ao mesmo tempo

-- tabela silver.bancos (todas as colunas estao como text)
create table silver.bancos as
select 
  cast(banco_id as int) as banco_id,  -- text para int
  lower(trim(banco)) as banco,        -- lower para texto minusculo, trim para retirar espacos
  now() as loaded_at
from bronze.bancos_raw;

select * from silver.bancos limit 10;

-- tabela silver.plano_contas (os tipos de dados estao ok)
create table if not exists silver.plano_contas as
select
  cast(subgrupo_id as int) as subgrupo_id,
  lower(trim(subgrupo)) as subgrupo,  -- lower para texto minusculo, trim para retirar espacos
  cast(conta_id as int) as conta_id,
  lower(trim(conta)) as conta,  -- lower para texto minusculo, trim para retirar espacos
  now() as loaded_at
from bronze.plano_contas_raw;

select * from silver.plano_contas limit 10;

-- tabela silver.saldo_anterior (todas as colunas estao como text)
create table if not exists silver.saldo_anterior as
select
  cast(banco_id as int) as banco_id,
  cast(
    replace(
      replace(
        replace(
          replace(valor, 'R$', ''),
        ' ', ''),
      '.', ''),
    ',', '.')
  as numeric(14,2)) as valor,
  now() as loaded_at
from bronze.saldo_anterior_raw;

select * from silver.saldo_anterior;

-- tabela silver.movimentos (todas as colunas estao como text)
create table if not exists silver.movimentos as
select
  case
    when lower(trim(tipo)) like 'entrada%' then 'e'
    when lower(trim(tipo)) like 'saída%' 
      or lower(trim(tipo)) like 'saida%'   then 's'
    else null
  end as tipo,
  lower(trim(conta)) as conta,  -- lower para texto minusculo, trim para retirar espacos
  to_date(data, 'DD-MM-YYYY') as data,
  lower(trim(banco)) as banco,  -- lower para texto minusculo, trim para retirar espacos
  cast(
    replace(
      replace(valor, '.', ''),
    ',', '.')
  as numeric(14,2)) as valor,
  now() as loaded_at   
from bronze.movimentos_raw;  

select * from silver.movimentos
limit 10;

-- criar tabela silver.movimentos_transf (transformada)
-- inserir colunas banco_id e conta_id 
-- excluir colunas banco e conta

create table if not exists silver.movimentos_transf as
select
  b.banco_id,
  pc.conta_id,
  m.tipo,
  m.data,
  m.valor
from silver.movimentos m
left join silver.bancos b on m."banco" = b."banco"
left join silver.plano_contas pc on m."conta" = pc."conta"; 

select * from silver.movimentos_transf
limit 10;

-- tabelas camada silver criadas.
-- end.


