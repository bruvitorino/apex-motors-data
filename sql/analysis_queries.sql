-- ============================================================================
-- APEX MOTORS - ANALYSIS QUERIES
-- Queries principais para análise de dados
-- ============================================================================

-- 1. TOTAL DE VENDAS POR ANO
-- ============================================================================
SELECT 
  EXTRACT(YEAR FROM f.data_venda) as ano,
  COUNT(*) as quantidade_vendas,
  SUM(f.valor_venda) as total_vendas,
  ROUND(AVG(f.valor_venda), 2) as ticket_medio
FROM `apex-motors-analytics.apex_motors_dw.fct_vendas` f
GROUP BY ano
ORDER BY ano DESC;


-- 2. TOP 10 CONCESSIONÁRIAS POR VENDAS
-- ============================================================================
SELECT 
  c.nome as concessionaria,
  COUNT(*) as quantidade_vendas,
  SUM(f.valor_venda) as total_vendas,
  ROUND(AVG(f.valor_venda), 2) as ticket_medio
FROM `apex-motors-analytics.apex_motors_dw.fct_vendas` f
JOIN `apex-motors-analytics.apex_motors_dw.dim_concessionarias` c 
  ON f.concessionaria_id = c.concessionaria_id
GROUP BY c.nome
ORDER BY total_vendas DESC
LIMIT 10;


-- 3. TOP 10 VENDEDORES POR QUANTIDADE
-- ============================================================================
SELECT 
  v.nome as vendedor,
  COUNT(*) as quantidade_vendas,
  SUM(f.valor_venda) as total_vendas,
  ROUND(AVG(f.valor_venda), 2) as ticket_medio
FROM `apex-motors-analytics.apex_motors_dw.fct_vendas` f
JOIN `apex-motors-analytics.apex_motors_dw.dim_vendedores` v 
  ON f.vendedor_id = v.vendedor_id
GROUP BY v.nome
ORDER BY quantidade_vendas DESC
LIMIT 10;


-- 4. DISTRIBUIÇÃO DE MODELOS VENDIDOS
-- ============================================================================
SELECT 
  v.modelo,
  COUNT(*) as quantidade_vendas,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) as percentual,
  SUM(f.valor_venda) as total_vendas
FROM `apex-motors-analytics.apex_motors_dw.fct_vendas` f
JOIN `apex-motors-analytics.apex_motors_dw.dim_veiculos` v 
  ON f.veiculo_id = v.veiculo_id
GROUP BY v.modelo
ORDER BY quantidade_vendas DESC;


-- 5. VENDAS POR MÊS (SÉRIE TEMPORAL)
-- ============================================================================
SELECT 
  DATE_TRUNC(f.data_venda, MONTH) as mes,
  COUNT(*) as quantidade_vendas,
  SUM(f.valor_venda) as total_vendas,
  ROUND(AVG(f.valor_venda), 2) as ticket_medio
FROM `apex-motors-analytics.apex_motors_dw.fct_vendas` f
GROUP BY mes
ORDER BY mes DESC;


-- 6. VENDAS POR ESTADO
-- ============================================================================
SELECT 
  e.nome as estado,
  COUNT(*) as quantidade_vendas,
  SUM(f.valor_venda) as total_vendas,
  ROUND(AVG(f.valor_venda), 2) as ticket_medio
FROM `apex-motors-analytics.apex_motors_dw.fct_vendas` f
JOIN `apex-motors-analytics.apex_motors_dw.dim_concessionarias` c 
  ON f.concessionaria_id = c.concessionaria_id
JOIN `apex-motors-analytics.apex_motors_dw.dim_estados` e 
  ON c.estado_id = e.estado_id
GROUP BY e.nome
ORDER BY total_vendas DESC;


-- 7. TICKET MÉDIO POR MODELO
-- ============================================================================
SELECT 
  v.modelo,
  ROUND(AVG(f.valor_venda), 2) as ticket_medio,
  MIN(f.valor_venda) as valor_minimo,
  MAX(f.valor_venda) as valor_maximo,
  COUNT(*) as quantidade_vendas
FROM `apex-motors-analytics.apex_motors_dw.fct_vendas` f
JOIN `apex-motors-analytics.apex_motors_dw.dim_veiculos` v 
  ON f.veiculo_id = v.veiculo_id
GROUP BY v.modelo
ORDER BY ticket_medio DESC;


-- 8. PERFORMANCE DE VENDEDORES (ÚLTIMOS 3 MESES)
-- ============================================================================
SELECT 
  v.nome as vendedor,
  COUNT(*) as quantidade_vendas,
  SUM(f.valor_venda) as total_vendas,
  ROUND(AVG(f.valor_venda), 2) as ticket_medio,
  RANK() OVER (ORDER BY SUM(f.valor_venda) DESC) as ranking
FROM `apex-motors-analytics.apex_motors_dw.fct_vendas` f
JOIN `apex-motors-analytics.apex_motors_dw.dim_vendedores` v 
  ON f.vendedor_id = v.vendedor_id
WHERE f.data_venda >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)
GROUP BY v.nome
ORDER BY total_vendas DESC;


-- 9. CRESCIMENTO MÊS A MÊS
-- ============================================================================
WITH vendas_mensais AS (
  SELECT 
    DATE_TRUNC(f.data_venda, MONTH) as mes,
    SUM(f.valor_venda) as total_vendas
  FROM `apex-motors-analytics.apex_motors_dw.fct_vendas` f
  GROUP BY mes
)
SELECT 
  mes,
  total_vendas,
  LAG(total_vendas) OVER (ORDER BY mes) as vendas_mes_anterior,
  ROUND(100 * (total_vendas - LAG(total_vendas) OVER (ORDER BY mes)) / LAG(total_vendas) OVER (ORDER BY mes), 2) as crescimento_percentual
FROM vendas_mensais
ORDER BY mes DESC;


-- 10. ANÁLISE DE CLIENTES (FREQUÊNCIA DE COMPRA)
-- ============================================================================
SELECT 
  cl.nome as cliente,
  COUNT(*) as quantidade_compras,
  SUM(f.valor_venda) as total_gasto,
  ROUND(AVG(f.valor_venda), 2) as ticket_medio,
  MAX(f.data_venda) as ultima_compra
FROM `apex-motors-analytics.apex_motors_dw.fct_vendas` f
JOIN `apex-motors-analytics.apex_motors_dw.dim_clientes` cl 
  ON f.cliente_id = cl.cliente_id
GROUP BY cl.nome
ORDER BY total_gasto DESC
LIMIT 20;
