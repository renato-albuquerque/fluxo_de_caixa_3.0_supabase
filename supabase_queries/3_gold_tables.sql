-- Tabelas dimensao x fato a serem criadas:
-- dim_bancos, dim_plano_contas, dim_calendario, fato_movimentos, fato_saldo_anterior

-- tabelas dimensao

-- dim_bancos
create table if not exists gold.dim_bancos as
select
  banco_id,
  banco
from silver.bancos;

alter table gold.dim_bancos
add constraint pk_bancos primary key (banco_id);

select * from gold.dim_bancos;

-- dim_plano_contas
create table if not exists gold.dim_plano_contas as
select
  conta_id,
  conta,
  subgrupo_id,
  subgrupo
from silver.plano_contas;  

alter table gold.dim_plano_contas
add constraint pk_dim_plano_contas primary key (conta_id);

select * from gold.dim_plano_contas;

-- dim_calendario
create table if not exists gold.dim_calendario (
  data_id        int primary key,   -- YYYYMMDD
  data           date not null,
  ano            int,
  mes            int,
  mes_nome       text,
  trimestre      int,
  dia            int,
  dia_semana     int,
  dia_semana_nome text,
  is_fim_semana  boolean
);

insert into gold.dim_calendario
select
  to_char(d, 'YYYYMMDD')::int as data_id,
  d as data,
  extract(year from d)::int as ano,
  extract(month from d)::int as mes,
  lower(to_char(d, 'Month')) as mes_nome,
  extract(quarter from d)::int as trimestre,
  extract(day from d)::int as dia,
  extract(dow from d)::int as dia_semana,
  lower(to_char(d, 'Day')) as dia_semana_nome,
  case when extract(dow from d) in (0,6) then true else false end as is_fim_semana
from generate_series(
  date '2020-01-01',
  date '2030-12-31',
  interval '1 day'
) d;

-- inserindo coluna mes_nome_abrev (ex.: jan, feb, mar, may, apr, ...)
alter table gold.dim_calendario
add column mes_nome_abrev text;

-- populando coluna mes_nome_abrev
update gold.dim_calendario
set mes_nome_abrev = lower(to_char(data, 'Mon'));

select * from gold.dim_calendario;

-- tabelas fato

-- fato_saldo_anterior
create table if not exists gold.fato_saldo_anterior as
select
  banco_id,   -- fk para gold.dim_bancos
  valor
from silver.saldo_anterior; 

-- inserir coluna data_id   -- fk para gold.dim_calendario
alter table gold.fato_saldo_anterior
add column data_id int;

-- populando coluna data_id
update gold.fato_saldo_anterior f
set data_id = d.data_id
from gold.dim_calendario d
where d.data = (
  select min(data) - interval '1 day'
  from silver.movimentos
);

-- PK & FK
alter table gold.fato_saldo_anterior
add constraint pk_fato_saldo_anterior
  primary key (data_id, banco_id),

add constraint fk_fsa_data
  foreign key (data_id)
  references gold.dim_calendario (data_id),

add constraint fk_fsa_banco
  foreign key (banco_id)
  references gold.dim_bancos (banco_id);

select * from gold.fato_saldo_anterior;

-- fato_movimentos
create table if not exists gold.fato_movimentos as
select
  banco_id,   --fk para gold.dim_bancos
  conta_id,   --fk para gold.dim_plano_contas
  tipo,
  data,
  valor
from silver.movimentos_transf; 

-- PK & FK
alter table gold.fato_movimentos
add constraint fk_fm_banco
    foreign key (banco_id)
    references gold.dim_bancos (banco_id),

add constraint fk_fm_conta
    foreign key (conta_id)
    references gold.dim_plano_contas (conta_id);

select * from gold.fato_movimentos;

-- tabelas camada gold criadas:
-- gold.dim_bancos
-- gold.dim_plano_contas
-- gold.dim_calendario
-- gold.fato_saldo_anterior
-- gold.fato_movimentos

-- criar views

-- vw_dim_bancos
create or replace view gold.vw_dim_bancos as
select
  banco_id,
  banco as banco_nome
from gold.dim_bancos;

select * from gold.vw_dim_bancos;

-- vw_dim_plano_contas
create or replace view gold.vw_dim_plano_contas as
select
  conta_id,
  conta as conta_nome,
  subgrupo_id,
  subgrupo as subgrupo_nome
from gold.dim_plano_contas;

select * from gold.vw_dim_plano_contas;

-- vw_dim_calendario
create or replace view gold.vw_dim_calendario as
select
  data_id,
  data,
  ano,
  mes,
  mes_nome,
  mes_nome_abrev,
  trimestre,
  dia,
  dia_semana,
  dia_semana_nome,
  is_fim_semana
from gold.dim_calendario;

select * from gold.vw_dim_calendario;

-- vw_fato_saldo_anterior
create or replace view gold.vw_fato_saldo_anterior as
select
  data_id,
  banco_id,
  valor
from gold.fato_saldo_anterior;

select * from gold.vw_fato_saldo_anterior;

-- vw_fato_movimentos
create or replace view gold.vw_fato_movimentos as
select
  banco_id,  
  conta_id,   
  tipo as tipo_movimento,
  data,
  valor
from gold.fato_movimentos;

select * from gold.vw_fato_movimentos;

-- views criadas no supabase
vw_dim_bancos
vw_dim_plano_contas
vw_dim_calendario
vw_fato_saldo_anterior
vw_fato_movimentos


-- end.







