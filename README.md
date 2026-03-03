# Projeto Demonstração de Fluxo de Caixa (DFC) – Versão 3.0  

---

## 📌 Sumário
1. Evolução da Arquitetura até a Versão 3.0  
2. Arquitetura do Projeto | Versão 3.0  
3. Stack Tecnológica  
4. Desenvolvimento
5. Caso Real de Data Quality    
6. Conclusão  

---

# 🚀 1. Evolução da Arquitetura até a Versão 3.0

A versão **3.0** do projeto Demonstração de Fluxo de Caixa (DFC) representa uma evolução significativa na maturidade da arquitetura de dados.

Se na versão 2.0 o foco foi a migração do ETL para Python + PostgreSQL, agora o projeto evolui para:

- ☁️ Banco de dados em nuvem (**Supabase – PostgreSQL gerenciado**)  
- 🧱 Arquitetura **Medallion (Bronze / Silver / Gold)**  
- 🔄 Transformações centralizadas em **SQL**
- 📊 Consumo analítico via **Power BI**

Fluxo atual: <br>
Excel ➝ Supabase (Bronze) ➝ SQL Transformations (Silver) ➝ Camada Gold (DW) ➝ Power BI <br>

A versão 3.0 reforça princípios de:

- Governança de Dados
- Imutabilidade (Dado original permanece intacto. Camada Bronze deve representar fielmente a ingestão)
- Reprocessamento controlado
- Validação quantitativa por camada
- Engenharia de Dados orientada à confiabilidade

---

# 🏗 2. Arquitetura do Projeto | Versão 3.0

A arquitetura segue o padrão **Medallion Architecture**: <br>
![project_architecture](images/supabase_pipeline.PNG)

## 🔹 Bronze (Raw Layer)
- Dados ingeridos no formato mais próximo possível da origem.
- Sem regras de negócio.
- Sem enriquecimento.
- Camada bruta dos dados.

## 🔹 Silver (Clean Layer)
- Tratamento de tipos de dados.
- Padronização.
- Correção estrutural.
- Regras de negócio iniciais.

## 🔹 Gold (Business Layer)
- Modelagem dimensional.
- Tabelas Fato e Dimensão.
- Estrutura pronta para consumo analítico.
- Fonte única da verdade para o Power BI.

---

# 💻 3. Stack Tecnológica

- `Supabase (PostgreSQL Cloud)` – Banco de dados na nuvem
- `SQL` – Transformações e modelagem
- `Power BI` – Visualização e análise
- `Git & GitHub` – Versionamento
- `VS Code` – Desenvolvimento
- `Excel` – Fonte original dos dados financeiros

---

# 🎯 4. Desenvolvimento

- Ingestão de dados no supabase.com (upload dos datasets na plataforma)

- [Passos no supabase para criação da camada bronze.](supabase_queries/1_bronze_tables.sql)
- [Passos no supabase para criação da camada silver.](supabase_queries/2_silver_tables.sql)
- [Passos no supabase para criação da camada gold.](supabase_queries/3_gold_tables.sql) <br>

- Tabelas criadas | Camada GOLD <br>
![gold_layer_tables](images/gold_layer_tables.PNG) <br>

- Modelagem de Dados | Camada GOLD <br>
![gold_data_modeling](images/gold_data_modeling.PNG) <br>

- Desenvolvimento de VIEWS para consumo no Power BI | Camada GOLD <br>
vw_dim_bancos <br>
vw_dim_plano_contas <br>
vw_dim_calendario <br>
vw_fato_saldo_anterior <br>
vw_fato_movimentos <br>

- Dashboards no Power BI | Dataviz <br>
02 modelos foram desenvolvidos para o cliente: <br>
![dashboard_dfc](images/dashboard_dfc.PNG) <br>
![dashboard_matriz](images/dashboard_matriz.PNG)

# 🚨 5. Caso Real de Data Quality
- Lições aprendidas durante processo de "data quality" com erro identificado no dataviz. Problema identificado entre a ingestão de dados e a camada bronze. <br>
![dataviz_error](images/supabase_data_quality.PNG) 

- Correções realizadas e erro corrigido.
![error_corrected](images/check_dado_dashboard.PNG) 

- Fluxo completo, dado correto no dataviz
![dataviz_error](images/data_quality_flow.PNG) 

- [Passos no pdf de lições aprendidas.](data_quality/licoes_aprendidas_data_quality.pdf)

- [Post no Linkedin sobre este case de Data Quality.](https://www.linkedin.com/posts/renato-malbuquerque_dataengineering-etl-dataquality-activity-7426128850264383488-xDA7?utm_source=share&utm_medium=member_desktop&rcm=ACoAAASmTtwBGZ_oPJdVVzH2BmXOpsUhvTZfQPE)


# 🏆 6. Conclusão
Além da evolução tecnológica desta versão 3.0 do projeto fluxo de caixa, foi uma evolução de maturidade em Engenharia de Dados. <br>

Este projeto demonstrou:
- Investigação por camadas
- Validação quantitativa
- Rastreabilidade de erros
- Disciplina de reprocessamento
- Pensamento crítico aplicado à qualidade de dados
- Aplicação real de princípios de Data Engineering

📌 Principal aprendizado: <br>
Se o dado entra errado na Bronze, todo o pipeline estará errado. <br>

A versão 3.0 consolida o projeto DFC como um case real de:
- Arquitetura moderna
- Governança de dados
- Data Quality aplicada
- Engenharia de Dados orientada à confiabilidade
<br>

[End] 🎆
<br>

### 👍 Meus contatos
- LinkedIn - [renato-malbuquerque](https://www.linkedin.com/in/renato-malbuquerque/)
- GitHub - [renato-albuquerque](https://github.com/renato-albuquerque)
- Discord - [Renato Albuquerque#0025](https://discordapp.com/users/992621595547938837)
- Business Card - [Renato Albuquerque](https://rma-contacts.vercel.app/)


