WITH subs AS (
  SELECT
    customer_id, 
    MAX(order_date::DATE) AS last_order_date
  FROM e_commerce_transactions 
  GROUP BY customer_id
),
RFM AS (
  SELECT
    a.customer_id,
    CURRENT_DATE - a.last_order_date AS recency,  
    COUNT(DISTINCT b.order_id) AS frequency,
    SUM(b.payment_value) AS monetary
  FROM subs a
  JOIN e_commerce_transactions b
    ON a.customer_id = b.customer_id
  GROUP BY a.customer_id, a.last_order_date
), 
SEGMENT as (
	select
		*, 
		ntile(5) OVER(order by recency) as recency_rate, 
		ntile(5) OVER(order by frequency) as frequency_rate, 
		ntile(5) OVER(order by monetary) as moneteray_rate
	from 
		rfm
)
SELECT 
  customer_id,
  recency_rate,
  frequency_rate,
  moneteray_rate,
  CONCAT(recency_rate, frequency_rate, moneteray_rate) AS rfm_score
FROM 
	segment