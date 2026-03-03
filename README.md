# Projeto Demonstração de Fluxo de Caixa (DFC) – Versão 3.0  

---

## 📌 Sumário
1. Evolução da Arquitetura até a Versão 3.0  
2. Arquitetura do Projeto | Versão 3.0  
3. Stack Tecnológica  
4. Pipeline de Dados (Bronze / Silver / Gold)  
5. Caso Real de Data Quality (Aprendizado Crítico)  
6. Boas Práticas Consolidadas  
7. Desenvolvimento  
8. Conclusão  

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
- Apenas padronizações técnicas mínimas.

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