# 🏗️ Arquitetura do Projeto Apex Motors

## Visão Geral

A arquitetura do projeto Apex Motors segue o padrão **Modern Data Stack** com foco em escalabilidade, confiabilidade e facilidade de manutenção.

```
┌─────────────────────────────────────────────────────────────────┐
│                   APEX MOTORS DATA ARCHITECTURE                  │
└─────────────────────────────────────────────────────────────────┘

CAMADA 1: INGESTÃO
├─ PostgreSQL (Render) ─────────────────> Dados Transacionais
└─ APIs Externas ──────────────────────> Dados de Terceiros

CAMADA 2: ORQUESTRAÇÃO
└─ Apache Airflow (EC2) ───────────────> Agendamento & Monitoramento

CAMADA 3: TRANSFORMAÇÃO
├─ Python Scripts ─────────────────────> Processamento
└─ dbt (Data Build Tool) ──────────────> Transformações SQL

CAMADA 4: ARMAZENAMENTO
└─ Google BigQuery ────────────────────> Data Warehouse

CAMADA 5: VISUALIZAÇÃO
└─ Google Looker Studio ───────────────> Dashboard BI
```

---

## 1. Camada de Ingestão

### PostgreSQL (Fonte Transacional)

**Localização**: Render (hospedagem em nuvem)

**Responsabilidade**: Armazenar dados transacionais da operação

**Tabelas Principais**:
- `vendas` - Transações de vendas
- `clientes` - Dados de clientes
- `concessionarias` - Dados de concessionárias
- `vendedores` - Dados de vendedores
- `veiculos` - Catálogo de veículos
- `estados` - Estados brasileiros
- `cidades` - Cidades brasileiras

**Frequência de Sincronização**: Diária (via Airflow)

---

## 2. Camada de Orquestração

### Apache Airflow (EC2 AWS)

**Localização**: AWS EC2 (servidor dedicado)

**Responsabilidade**: Orquestrar e monitorar o pipeline de dados

**Componentes**:
- **Webserver** - Interface web (porta 8080)
- **Scheduler** - Agendador de tarefas
- **Executor** - Executor de tarefas (LocalExecutor)

**DAGs Principais**:
1. `apex_motors_daily_pipeline` - Pipeline diário
2. `apex_motors_data_cleanup` - Limpeza de dados
3. `apex_motors_weekly_report` - Relatório semanal

**Fluxo de Execução**:
```
Extração → Validação → Transformação → Alertas
```

---

## 3. Camada de Transformação

### dbt (Data Build Tool)

**Responsabilidade**: Transformar dados brutos em dados analíticos

**Estrutura de Modelos**:

#### Raw Layer
- Cópia 1:1 dos dados do PostgreSQL
- Sem transformações
- Serve como camada de backup

#### Staging Layer
- Limpeza de dados
- Padronização de formatos
- Tratamento de nulos
- Remoção de duplicatas

#### Dimension Layer
- Dimensões para análise
- Chaves primárias e estrangeiras
- Dados desnormalizados para performance

#### Fact Layer
- Tabela de fatos `fct_vendas`
- Contém IDs de dimensões
- Métricas numéricas

#### Analysis Layer
- Tabelas pré-agregadas
- Otimizadas para dashboard
- Cálculos complexos pré-computados

---

## 4. Camada de Armazenamento

### Google BigQuery

**Responsabilidade**: Data Warehouse centralizado

**Características**:
- Escalabilidade automática
- Consultas SQL padrão
- Integração com Looker Studio
- Backup automático

**Dataset**: `apex_motors_dw`

**Tabelas**: 22 (raw, stg, dim, fact, analysis)

**Volume de Dados**:
- 6.500+ registros de vendas
- 35 meses de histórico
- ~100 MB de armazenamento

---

## 5. Camada de Visualização

### Google Looker Studio

**Responsabilidade**: Dashboard executivo

**Componentes**:
- Série temporal (35 meses)
- Gráficos de barras
- Gráficos de pizza
- Scorecards
- Tabelas interativas
- Filtros dinâmicos

**Atualização**: Em tempo real (conectado ao BigQuery)

---

## Fluxo de Dados Completo

### Passo 1: Extração (Diária)
```
PostgreSQL → Airflow → Extrai dados brutos
```

### Passo 2: Carregamento Raw (Diária)
```
Dados Brutos → BigQuery → raw_vendas, raw_clientes, etc
```

### Passo 3: Transformação (Diária)
```
Raw Layer → dbt → Staging Layer → Dimension Layer → Fact Layer
```

### Passo 4: Análise (Diária)
```
Fact Layer → dbt → Analysis Layer (pré-agregações)
```

### Passo 5: Visualização (Tempo Real)
```
Analysis Layer → Looker Studio → Dashboard
```

---

## Tecnologias Utilizadas

### Infraestrutura
| Componente | Tecnologia | Função |
|-----------|-----------|--------|
| Servidor | AWS EC2 | Hospedagem Airflow |
| Banco Transacional | PostgreSQL | Fonte de dados |
| Hospedagem DB | Render | Cloud para PostgreSQL |
| Containerização | Docker | Isolamento de ambientes |

### Dados
| Componente | Tecnologia | Função |
|-----------|-----------|--------|
| Orquestração | Apache Airflow | Agendamento de tarefas |
| Transformação | dbt | Transformações SQL |
| Data Warehouse | Google BigQuery | Armazenamento analítico |
| Visualização | Looker Studio | Dashboard BI |

### Desenvolvimento
| Componente | Tecnologia | Função |
|-----------|-----------|--------|
| Linguagem | Python | Scripts de processamento |
| Versionamento | Git | Controle de código |
| Documentação | Markdown | Documentação técnica |

---

## Padrões de Design

### Medallion Architecture

O projeto segue o padrão **Medallion** (Bronze, Silver, Gold):

```
BRONZE (Raw Layer)
├─ raw_vendas
├─ raw_clientes
├─ raw_concessionarias
└─ ... (7 tabelas)

SILVER (Staging + Dimension Layer)
├─ stg_vendas
├─ stg_clientes
├─ dim_vendedores
└─ ... (13 tabelas)

GOLD (Fact + Analysis Layer)
├─ fct_vendas
├─ analyse_vendas_temporal
├─ analyse_vendas_concessionaria
└─ ... (5 tabelas)
```

### Idempotência

Todas as transformações são **idempotentes**, ou seja:
- Podem ser executadas múltiplas vezes
- Produzem o mesmo resultado
- Seguro para reprocessamento

---

## Segurança

### Credenciais
- Variáveis de ambiente
- Não commitadas no Git
- Rotação periódica

### Acesso
- IAM roles no Google Cloud
- Permissões granulares
- Auditoria de acessos

### Dados
- Backup automático
- Replicação
- Criptografia em trânsito

---

## Performance

### Otimizações

1. **Particionamento**
   - Tabelas particionadas por data
   - Reduz custo de queries

2. **Clustering**
   - Dados agrupados por dimensões principais
   - Melhora performance

3. **Índices**
   - Índices em chaves estrangeiras
   - Acelera joins

4. **Pré-agregações**
   - Analysis layer com dados pré-agregados
   - Dashboard carrega rápido

### Métricas

| Métrica | Valor |
|---------|-------|
| Tempo de Pipeline | ~15 minutos |
| Tempo de Query (Dashboard) | <2 segundos |
| Disponibilidade | 99.9% |
| RTO (Recovery Time) | <1 hora |

---

## Monitoramento

### Alertas Configurados

1. **Pipeline Falhou**
   - Email para data-team
   - Slack notification

2. **Qualidade de Dados**
   - Registros duplicados
   - Valores nulos inesperados
   - Outliers

3. **Performance**
   - Queries lentas
   - Uso de recursos alto

---

## Escalabilidade

### Plano de Crescimento

**Fase 1 (Atual)**: 6.500 registros
- ✅ Implementado

**Fase 2 (Próxima)**: 100.000+ registros
- Aumentar frequência de pipeline
- Implementar particionamento avançado

**Fase 3 (Futuro)**: 1M+ registros
- Implementar Spark para processamento distribuído
- Usar Databricks

---

## Disaster Recovery

### Backup
- Backup automático diário
- Retenção de 30 dias
- Testado mensalmente

### Restauração
- RTO: <1 hora
- RPO: <1 dia
- Procedimento documentado

---

## Roadmap Futuro

- [ ] Implementar Machine Learning (previsão de vendas)
- [ ] Adicionar Spark para processamento distribuído
- [ ] Implementar alertas em tempo real
- [ ] Expandir para mais concessionárias
- [ ] Integrar com CRM externo
- [ ] Análise de churn de clientes

---

**Última atualização**: Março de 2026
