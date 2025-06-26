SELECT
  customer_id,
  TO_CHAR(order_date, 'YYYY-MM') AS tahun_bulan,
  COUNT(*) AS total_orders
FROM 
  e_commerce_transactions ect
GROUP BY 
  customer_id,
  TO_CHAR(order_date, 'YYYY-MM')
HAVING 
  COUNT(*) > 1
 order by 
	customer_id 