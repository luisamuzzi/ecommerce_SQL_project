-- Qual a quantidade de cidades únicas de todos os vendedores da base?
SELECT 
	COUNT( DISTINCT s.seller_city) AS unique_seller_city
FROM sellers s 

-- Qual o valor médio do preço de todos os pedidos?
SELECT
	ROUND(AVG(price),2) AS avg_price
FROM order_items oi 

-- Qual o maior valor de preço entre todos os pedidos?
SELECT
	MAX(oi.price) AS max_price
FROM order_items oi

-- Qual o menor valor de preço entre todos os pedidos?
SELECT
	MIN(oi.price) AS min_price
FROM order_items oi 

-- Qual a quantidade de produtos distintos vendidos?
SELECT
	COUNT(DISTINCT oi.product_id) AS unique_products
FROM order_items oi

-- Quais os tipos de pagamentos existentes?
SELECT
	DISTINCT op.payment_type AS payment_types
FROM order_payments op

-- Qual o maior número de parcelas realizado?
SELECT
	MAX(op.payment_installments) AS max_payment_installments
FROM order_payments op

-- Qual o menor número de parcelas realizado?
SELECT
	MIN(op.payment_installments) AS min_payment_installments
FROM order_payments op

-- Qual a média do valor pago no cartão de crédito?
SELECT
	ROUND(AVG(op.payment_value),2) AS avg_credit_payment
FROM order_payments op
WHERE op.payment_type = 'credit_card'

-- Quais os tipos de status para um pedido?
SELECT
	DISTINCT o.order_status AS unique_status
FROM orders o 

-- Quantos clientes distintos fizeram um pedido?
SELECT
	COUNT(DISTINCT o.customer_id) AS unique_customer_qty
FROM orders o 

-- Qual o número de clientes únicos de todos os estados?
SELECT
	c.customer_state,
	COUNT(DISTINCT c.customer_id) AS clientes_unicos
FROM customer c 
GROUP BY c.customer_state
ORDER BY clientes_unicos DESC

-- Qual o número de cidades únicas de todos os estados?
SELECT 
	g.geolocation_state, 
	COUNT(DISTINCT g.geolocation_city) AS numero_cidades
FROM geolocation g 
GROUP BY g.geolocation_state
ORDER BY numero_cidades DESC

-- Qual o número de clientes únicos por estado e por cidade?
SELECT 
	c.customer_state,
	c.customer_city,
	COUNT(DISTINCT c.customer_id) AS clientes_unicos
FROM customer c 
GROUP BY c.customer_state, c.customer_city 

-- Qual a quantidade de pedidos, a média do valor do pagamento e o número máximo de parcelas por tipo de pagamentos?
SELECT
	op.payment_type,
	COUNT(op.order_id) AS pedidos,
	AVG(op.payment_value) AS AVG_pagamento,
	MAX(op.payment_installments) AS max_parcelas 
FROM order_payments op 
GROUP BY op.payment_type 

-- Qual a valor mínimo, máximo, médio e as soma total paga por cada tipo de pagamento e número de parcelas disponíveis?
SELECT
	op.payment_type,
	op.payment_installments,
	MIN(op.payment_value) AS valor_minimo,
	MAX(op.payment_value) AS valor_maximo,
	AVG(op.payment_value) AS valor_medio,
	SUM(op.payment_value) AS soma_valor
FROM order_payments op 
GROUP BY op.payment_type, op.payment_installments 

-- Quantos produtos estão cadastrados na empresa por categoria?
SELECT 
	p.product_category_name AS categoria,
	COUNT(p.product_id) AS qtd_produtos
FROM products p
GROUP BY p.product_category_name
ORDER BY qtd_produtos DESC

/* Qual o número total de pedidos únicos, a data mínima e máxima de envio, o valor máximo, mínimo e médio do frete
dos pedidos abaixo de R$ 1.100 por cada vendedor? */
SELECT 
	oi.seller_id,
	COUNT(DISTINCT oi.order_id) AS pedidos,
	MIN(DATE(oi.shipping_limit_date)) AS data_min,
	MAX(DATE(oi.shipping_limit_date)) AS data_max,
	MAX(oi.freight_value) AS frete_max,
	MIN(oi.freight_value) AS frete_min,
	AVG(oi.freight_value) AS frete_medio
FROM order_items oi 
WHERE oi.price < 1100
GROUP BY oi.seller_id

/* Quantos clientes únicos tiveram seu pedidos com status de “processing”,
“shipped” e “delivered”, feitos entre os dias 01 e 31 de Outubro de 2016. Mostrar
o resultado somente se o número total de clientes for acima de 5. */
SELECT
	o.order_status,
	COUNT(DISTINCT o.customer_id) AS clientes_unicos
FROM orders o 
WHERE o.order_status IN ('processing', 'shipped', 'delivered')
	AND o.order_purchase_timestamp BETWEEN '2016-10-01' AND '2016-10-31'
GROUP BY o.order_status
HAVING COUNT(DISTINCT o.customer_id) > 5

-- Quais são os top 10 vendedores com mais clientes?
SELECT
	s.seller_id,
	COUNT(c.customer_id) AS qtde_clientes
FROM orders o LEFT JOIN order_items oi ON oi.order_id = o.order_id 
	          LEFT JOIN sellers s ON s.seller_id = oi.seller_id 
	          LEFT JOIN customer c ON c.customer_id = o.customer_id
GROUP BY s.seller_id
ORDER BY qtde_clientes DESC
LIMIT 10

-- Qual o número de pedidos com o tipo de pagamento igual a “boleto”?
SELECT
	COUNT(o.order_id)
FROM orders o 
WHERE o.order_id IN (SELECT op.order_id 
					 FROM order_payments op 
					 WHERE op.payment_type = 'boleto')
					 
/* Quantos clientes avaliaram o pedido com 5 estrelas? */
SELECT 
	COUNT(o.customer_id) AS qtde_clientes
FROM orders o LEFT JOIN order_reviews or2 ON or2.order_id = o.order_id 
WHERE or2.review_score = 5

/* Quantos clientes avaliaram o pedido com 1
estrelas? */
SELECT 
	COUNT(o.customer_id) AS qtde_clientes
FROM orders o LEFT JOIN order_reviews or2 ON or2.order_id = o.order_id 
WHERE or2.review_score = 1

/* Crie uma tabela que mostre a média de avaliações por dia, a média de preço por dia, a
soma dos preços por dia, o preço mínimo por dia, o número de pedidos por dia e o número de
clientes únicos que compraram no dia. */
SELECT
t1.date_,
t1.avg_review,
t2.avg_price,
t2.sum_price,
t2.min_price,
t3.pedido_por_dia,
t3.clientes_unicos
FROM (SELECT
		DATE( review_creation_date ) AS date_,
		AVG( review_score ) AS avg_review
	  FROM order_reviews or2
	  GROUP BY DATE( review_creation_date )) AS t1 LEFT JOIN ( SELECT
																DATE( oi.shipping_limit_date ) AS date_,
																AVG( price ) AS avg_price,
																SUM( price ) AS sum_price,
																MIN( price ) AS min_price
															   FROM order_items oi
															   GROUP BY DATE( oi.shipping_limit_date )) AS t2 ON ( t2.date_ = t1.date_)
													LEFT JOIN (SELECT
																DATE( o.order_purchase_timestamp ) AS date_,
																COUNT( o.order_id ) AS pedido_por_dia,
																COUNT( DISTINCT o.customer_id ) AS clientes_unicos
															   FROM orders o
															   GROUP BY DATE( o.order_purchase_timestamp )) AS t3 ON ( t3.date_ = t1.date_)	
															   
/* Crie uma consulta que exiba o código do produto e a categoria de cada produto
com base no seu preço:
Preço abaixo de 50 → Categoria A
Preço entre 50 e 100 → Categoria B
Preço entre 100 e 500 → Categoria C
Preço entre 500 e 1500 → Categoria D
Preço acima de 1500 → Categoria E
*/

SELECT 
	oi.product_id,
	oi.price,
	CASE
		WHEN oi.price < 50.0 THEN 'categoria a'
		WHEN oi.price < 100.0 THEN 'categoria b'
		WHEN oi.price < 500.0 THEN 'categoria c'
		WHEN oi.price < 1500.0 THEN 'categoria d'
		ELSE 'categoria e'
	END AS categoria	
FROM order_items oi

-- Calcule a quantidade de produtos para cada uma das categorias criadas anteriormente
SELECT 
	COUNT(oi.product_id),
	CASE
		WHEN oi.price < 50.0 THEN 'categoria a'
		WHEN oi.price >= 50.0 AND oi.price < 100.0 THEN 'categoria b'
		WHEN oi.price >= 100.0 AND oi.price < 500.0 THEN 'categoria c'
		WHEN oi.price >= 500.0 AND oi.price < 1500.0 THEN 'categoria d'
		ELSE 'categoria e'
	END AS categoria	
FROM order_items oi 
GROUP BY categoria
											
/* Crie uma consulta que exiba a data de compra, o valor de cada venda e o total acumulado de vendas até aquela
data. */
SELECT 
	DATE(o.order_purchase_timestamp),
	oi.price,
	SUM(oi.price) OVER (ORDER BY DATE(o.order_purchase_timestamp)) AS total_acumulado
FROM orders o LEFT JOIN order_items oi ON oi.order_id = o.order_id  
WHERE oi.price IS NOT NULL

/* Crie uma consulta que exiba o estado do cliente, a categoria, a quantidade de produtos vendidos e o percentual de
vendas em relação ao total vendido no estado. */
SELECT
	estado,
	categoria,
	qtde_produtos,
	SUM(qtde_produtos) OVER (PARTITION BY estado) AS total_estado,
	(qtde_produtos*100.0/(SUM(qtde_produtos) OVER (PARTITION BY estado))) AS porcentagem
FROM (SELECT
		c.customer_state AS estado,
		p.product_category_name AS categoria,
		COUNT(oi.product_id) AS qtde_produtos	
	  FROM orders o LEFT JOIN customer c ON c.customer_id = o.customer_id
	  				LEFT JOIN order_items oi ON oi.order_id = o.order_id
	  				LEFT JOIN products p ON oi.product_id = p.product_id  
	  GROUP BY estado, categoria
	  HAVING categoria IS NOT NULL)

/* Crie uma consulta SQL usando a cláusula WITH para calcular o total de vendas para cada categoria e exiba o
resultado. */
WITH vendas AS (
SELECT 
	p.product_category_name AS categoria,
	SUM(oi.price) AS total_vendas
FROM order_items oi LEFT JOIN products p ON p.product_id = oi.product_id 
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name 
)
SELECT 
	categoria,
	total_vendas
FROM vendas

/* Crie uma consulta usando a cláusula WITH para calcular a receita total por mês e exiba o mês com a maior receita. */
WITH receita AS (
SELECT
	STRFTIME('%m', o.order_purchase_timestamp) AS mes,
	SUM(oi.price) AS vendas
FROM orders o LEFT JOIN order_items oi ON oi.order_id = o.order_id 
GROUP BY STRFTIME('%m', o.order_purchase_timestamp)
)
SELECT 
	mes,
	vendas
FROM receita
WHERE vendas = (SELECT 
					MAX(vendas) 
				FROM receita)

/* Crie uma consulta SQL com as seguintes colunas: 1) Categoria, 2)Preço, 3)Date limite de envio, 4) Primeira
compra, 5) Número de dias que o produto foi comprado a partir da primeira compra dentro da mesma categoria. */
WITH tabela_temp AS (
	SELECT 
		p.product_category_name AS categoria,
		oi.order_id AS compra,
		oi.price AS preco,
		oi.shipping_limit_date AS data_limite_envio,
		FIRST_VALUE(oi.shipping_limit_date) OVER (PARTITION BY p.product_category_name ORDER BY oi.shipping_limit_date ASC) AS primeira_compra
	FROM order_items oi LEFT JOIN products p ON p.product_id = oi.product_id 
	WHERE p.product_category_name IS NOT NULL
)
SELECT 
	categoria,
	preco,
	STRFTIME('%Y-%m-%d', data_limite_envio) AS data_limite_envio,
	STRFTIME('%Y-%m-%d', primeira_compra) AS primeira_compra,
	CAST((JULIANDAY(data_limite_envio) - JULIANDAY(primeira_compra)) AS INTEGER) AS dias
FROM tabela_temp

/* Qual a categoria que possui o produto com o maior
número de dias entre a primeira compra da categoria e a
sua data limite de entrega? */
WITH table_temp AS (
	SELECT
		p.product_category_name AS categoria,
		oi.shipping_limit_date AS limite_entrega,
		FIRST_VALUE(o.order_purchase_timestamp) OVER (PARTITION BY p.product_category_name ORDER BY o.order_purchase_timestamp ASC) AS primeira_compra
	FROM orders o LEFT JOIN order_items oi ON oi.order_id = o.order_id 
				  LEFT JOIN products p ON p.product_id = oi.product_id 
	WHERE categoria IS NOT NULL
)
SELECT
	categoria,
	STRFTIME('%Y-%m-%d', limite_entrega) AS limite_entrega,
	STRFTIME('%Y-%m-%d', primeira_compra) AS primeira_compra,
	MAX(CAST((JULIANDAY(limite_entrega) - JULIANDAY(primeira_compra)) AS INTEGER)) AS dias_max
FROM table_temp