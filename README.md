# 🏎️ Apex Motors - Data Engineering & Business Intelligence Project

Um projeto completo de **Data Engineering** e **Business Intelligence** que demonstra a construção de um pipeline de dados robusto, desde a ingestão até a visualização em tempo real.

## 📊 Visão Geral

Este projeto implementa uma solução end-to-end de dados para a **Apex Motors**, uma concessionária de veículos, incluindo:

- **Infraestrutura em Cloud** (AWS EC2, PostgreSQL em Render)
- **Orquestração de Pipelines** (Apache Airflow)
- **Data Warehouse** (Google BigQuery)
- **Transformações de Dados** (dbt)
- **Business Intelligence** (Google Looker Studio)

### 📈 Estatísticas do Projeto

| Métrica | Valor |
|---------|-------|
| **Registros de Vendas** | 6.500+ |
| **Período de Dados** | Jan/2023 - Out/2025 (35 meses) |
| **Total de Vendas** | R$ 21.128.250 |
| **Concessionárias** | 34 |
| **Vendedores** | 87 |
| **Modelos de Carros** | 7 |
| **Tabelas no BigQuery** | 22 |
| **Documentação** | 122 páginas |

---

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────────────────────┐
│                     APEX MOTORS DATA PIPELINE                   │
└─────────────────────────────────────────────────────────────────┘

1. INGESTÃO
   └─ PostgreSQL (Render) ──> Dados brutos

2. ORQUESTRAÇÃO
   └─ Apache Airflow (EC2) ──> Agendamento e monitoramento

3. TRANSFORMAÇÃO
   └─ dbt + BigQuery ──> Camadas: raw, stg, dim, fact, analysis

4. ARMAZENAMENTO
   └─ Google BigQuery ──> Data Warehouse centralizado

5. VISUALIZAÇÃO
   └─ Google Looker Studio ──> Dashboard executivo

6. DOCUMENTAÇÃO
   └─ 122 páginas ──> Roadmap completo do projeto
```

---

## 🛠️ Stack Tecnológico

### Infraestrutura
- **AWS EC2** - Servidor para Airflow
- **PostgreSQL** - Banco de dados transacional (hospedado em Render)
- **Docker** - Containerização

### Orquestração & Transformação
- **Apache Airflow** - Orquestração de pipelines
- **dbt (Data Build Tool)** - Transformações de dados
- **Python** - Scripts de processamento

### Data Warehouse & Analytics
- **Google BigQuery** - Data Warehouse
- **SQL** - Queries analíticas

### Visualização
- **Google Looker Studio** - Dashboard BI

### Versionamento & Documentação
- **Git** - Controle de versão
- **Markdown** - Documentação

---

## 📁 Estrutura do Repositório

```
apex-motors/
├── README.md                          # Este arquivo
├── requirements.txt                   # Dependências Python
│
├── docs/
│   ├── ROADMAP.md                     # Roadmap completo do projeto
│   ├── ARQUITETURA.md                 # Detalhes da arquitetura
│   ├── GUIA_COMPLETO.pdf              # Documentação em PDF (122 pág)
│   └── TABELAS.md                     # Descrição de todas as tabelas
│
├── sql/
│   ├── raw_tables.sql                 # Criação de tabelas raw
│   ├── stg_tables.sql                 # Criação de tabelas staging
│   ├── dim_tables.sql                 # Criação de dimensões
│   ├── fact_tables.sql                # Criação de fatos
│   ├── analysis_queries.sql           # Queries de análise
│   └── dbt_models/                    # Modelos dbt
│
├── python/
│   ├── airflow_dags.py                # DAGs do Airflow
│   ├── transformations.py             # Scripts de transformação
│   ├── data_validation.py             # Validação de dados
│   └── utils.py                       # Funções utilitárias
│
├── docker/
│   ├── docker-compose.yml             # Composição Docker
│   └── Dockerfile                     # Configuração do container
│
├── looker/
│   ├── dashboard_config.json          # Configuração do dashboard
│   └── looker_studio_link.txt         # Link do dashboard ao vivo
│
└── screenshots/
    ├── dashboard_overview.png         # Screenshot do dashboard
    ├── airflow_dag.png                # Screenshot do Airflow
    └── bigquery_tables.png            # Screenshot do BigQuery
```

---

## 🚀 Como Usar Este Projeto

### Pré-requisitos

- Python 3.8+
- Git
- Conta Google Cloud (BigQuery, Looker Studio)
- Conta AWS (EC2)
- PostgreSQL

### Instalação

1. **Clone o repositório**
```bash
git clone https://github.com/bruvitorino/apex-motors.git
cd apex-motors
```

2. **Instale as dependências**
```bash
pip install -r requirements.txt
```

3. **Configure as credenciais**
```bash
# BigQuery
export GOOGLE_APPLICATION_CREDENTIALS="path/to/credentials.json"

# AWS
export AWS_ACCESS_KEY_ID="your_key"
export AWS_SECRET_ACCESS_KEY="your_secret"
```

4. **Configure o Airflow**
```bash
airflow db init
airflow webserver -p 8080
airflow scheduler
```

5. **Execute as transformações dbt**
```bash
dbt run
dbt test
```

---

## 📊 Dashboard Looker Studio

O dashboard executivo inclui:

### Visualizações
- **Série Temporal** - Vendas ao longo de 35 meses
- **Gráfico de Barras** - Vendas por ano (2023, 2024, 2025)
- **Gráfico de Pizza** - Distribuição de modelos vendidos
- **Tabela** - Top 10 concessionárias por quantidade

### Scorecards
- **Total de Vendas** - R$ 21.128.250
- **Quantidade de Vendedores** - 87
- **Total de Concessionárias** - 34

### Filtros Interativos
- Data
- Concessionária
- Modelo de Carro
- Vendedor

**[Acesse o Dashboard ao Vivo](https://lookerstudio.google.com/reporting/seu-dashboard-id)**

---

## 📚 Documentação Detalhada

### Roadmap Completo
Veja `docs/ROADMAP.md` para um guia passo a passo de toda a implementação.

### Arquitetura
Veja `docs/ARQUITETURA.md` para detalhes técnicos da arquitetura.

### Tabelas do BigQuery
Veja `docs/TABELAS.md` para descrição de todas as 22 tabelas.

### Guia Completo em PDF
Veja `docs/GUIA_COMPLETO.pdf` para documentação completa (122 páginas).

---

## 🔄 Pipeline de Dados

### Fluxo ETL

```
1. EXTRAÇÃO (Extract)
   └─ PostgreSQL → Dados brutos

2. TRANSFORMAÇÃO (Transform)
   ├─ Raw Layer → Tabelas raw (cópia dos dados)
   ├─ Staging Layer → Limpeza e padronização
   ├─ Dimension Layer → Dimensões (clientes, produtos, etc)
   ├─ Fact Layer → Fatos (vendas)
   └─ Analysis Layer → Tabelas analíticas

3. CARREGAMENTO (Load)
   └─ BigQuery → Data Warehouse centralizado
```

### Frequência de Execução

- **Ingestão**: Diária (via Airflow)
- **Transformação**: Diária (via dbt)
- **Atualização do Dashboard**: Em tempo real

---

## 📊 Tabelas do BigQuery

### Raw Layer (7 tabelas)
- `raw_vendas` - Transações de vendas brutas
- `raw_clientes` - Dados de clientes
- `raw_concessionarias` - Dados de concessionárias
- `raw_estados` - Estados brasileiros
- `raw_cidades` - Cidades brasileiras
- `raw_veiculos` - Catálogo de veículos
- `raw_vendedores` - Dados de vendedores

### Staging Layer (7 tabelas)
- `stg_vendas` - Vendas limpas
- `stg_clientes` - Clientes padronizados
- `stg_concessionarias` - Concessionárias padronizadas
- `stg_estados` - Estados padronizados
- `stg_cidades` - Cidades padronizadas
- `stg_veiculos` - Veículos padronizados
- `stg_vendedores` - Vendedores padronizados

### Dimension Layer (6 tabelas)
- `dim_clientes` - Dimensão de clientes
- `dim_concessionarias` - Dimensão de concessionárias
- `dim_estados` - Dimensão de estados
- `dim_cidades` - Dimensão de cidades
- `dim_veiculos` - Dimensão de veículos
- `dim_vendedores` - Dimensão de vendedores

### Fact Layer (1 tabela)
- `fct_vendas` - Fatos de vendas (6.500+ registros)

### Analysis Layer (4 tabelas)
- `analyse_vendas_temporal` - Análise temporal
- `analyse_vendas_concessionaria` - Análise por concessionária
- `analyse_vendas_veiculo` - Análise por veículo
- `analyse_vendas_vendedor` - Análise por vendedor

---

## 🎯 Principais Insights

### Vendas por Período
- **2023**: R$ 2.510.000 (1.000 vendas)
- **2024**: R$ 2.490.000 (980 vendas)
- **2025**: R$ 1.500.000 (520 vendas até outubro)

### Modelo Mais Vendido
- **Apex Vortex** - 25,9% das vendas

### Concessionária Líder
- **Apex Motors Londrina** - 230 vendas

### Vendedor Top
- **José Oliveira** - 284 vendas

---

## 🔐 Segurança & Boas Práticas

- ✅ Credenciais em variáveis de ambiente
- ✅ Versionamento de código com Git
- ✅ Testes de qualidade de dados
- ✅ Documentação completa
- ✅ Monitoramento com Airflow
- ✅ Backup automático de dados

---

## 📝 Próximos Passos

- [ ] Adicionar Machine Learning (previsão de vendas)
- [ ] Implementar alertas em tempo real
- [ ] Expandir para mais concessionárias
- [ ] Integrar com CRM externo
- [ ] Adicionar análise de churn

---

## 👨‍💻 Autor

**Bruno Vitorino**
- GitHub: [@bruvitorino](https://github.com/bruvitorino)
- LinkedIn: [Bruno Vitorino](https://linkedin.com/in/bruvitorino)

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja `LICENSE` para detalhes.

---

## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests.

---

## 📞 Suporte

Para dúvidas ou sugestões, abra uma issue neste repositório.

---

**Última atualização**: Março de 2026
