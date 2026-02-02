-- Tabelas dimensão x fato a serem criadas:
-- dim_bancos, dim_plano_contas, dim_calendario, f_movimentos, f_saldo_anterior

-- tabelas dimensao

-- dim_bancos
create table if not exists gold.dim_bancos as
select
  banco_id,
  banco
from silver.bancos;

alter table gold.dim_bancos
add constraint pk_bancos primary key (banco_id);

select * from gold.dim_bancos
limit 10;

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

select * from gold.dim_plano_contas
limit 10;

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

select * from gold.dim_calendario
limit 10;

-- tabelas fato

-- f_movimentos

-- f_saldo_anterior



