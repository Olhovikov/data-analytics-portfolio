-- 1. Monthly retail KPIs
SELECT date_trunc('month', sale_date)::date AS month,
       ROUND(SUM(gross_revenue), 2) AS revenue,
       ROUND(SUM(gross_profit), 2) AS gross_profit,
       ROUND(SUM(gross_profit) / NULLIF(SUM(gross_revenue), 0) * 100, 2) AS margin_pct,
       COUNT(DISTINCT transaction_id) AS transactions,
       ROUND(SUM(gross_revenue) / NULLIF(COUNT(DISTINCT transaction_id), 0), 2) AS avg_basket
FROM sales_transactions
WHERE channel = 'Retail'
GROUP BY 1
ORDER BY 1;

-- 2. Store performance
SELECT location,
       ROUND(SUM(gross_revenue), 2) AS revenue,
       ROUND(SUM(gross_profit), 2) AS gross_profit,
       ROUND(SUM(gross_profit) / NULLIF(SUM(gross_revenue), 0) * 100, 2) AS margin_pct,
       COUNT(DISTINCT transaction_id) AS transactions,
       ROUND(SUM(gross_revenue) / NULLIF(COUNT(DISTINCT transaction_id), 0), 2) AS avg_basket
FROM sales_transactions
WHERE channel = 'Retail'
GROUP BY location
ORDER BY revenue DESC;

-- 3. Highest-revenue retail products
SELECT sku, product_name,
       ROUND(SUM(gross_revenue), 2) AS revenue,
       ROUND(SUM(gross_profit), 2) AS gross_profit,
       ROUND(SUM(quantity), 0) AS units
FROM sales_transactions
WHERE channel = 'Retail' AND NOT is_return
GROUP BY sku, product_name
ORDER BY revenue DESC
LIMIT 20;

-- 4. Category performance and margin
SELECT category,
       ROUND(SUM(gross_revenue), 2) AS revenue,
       ROUND(SUM(gross_profit), 2) AS gross_profit,
       ROUND(SUM(gross_profit) / NULLIF(SUM(gross_revenue), 0) * 100, 2) AS margin_pct,
       ROUND(SUM(quantity), 0) AS units
FROM sales_transactions
WHERE channel = 'Retail' AND NOT is_return
GROUP BY category
ORDER BY revenue DESC;

-- 5. Basket distribution by transaction
WITH baskets AS (
    SELECT transaction_id,
           SUM(gross_revenue) AS basket_value,
           SUM(quantity) AS basket_units
    FROM sales_transactions
    WHERE channel = 'Retail' AND NOT is_return
    GROUP BY transaction_id
)
SELECT ROUND(AVG(basket_value), 2) AS average_basket,
       ROUND(percentile_cont(0.5) WITHIN GROUP (ORDER BY basket_value)::numeric, 2) AS median_basket,
       ROUND(percentile_cont(0.9) WITHIN GROUP (ORDER BY basket_value)::numeric, 2) AS p90_basket,
       ROUND(AVG(basket_units), 2) AS average_units
FROM baskets;

-- 6. Return rate by store
SELECT location,
       ROUND(ABS(SUM(gross_revenue) FILTER (WHERE is_return)), 2) AS returned_value,
       ROUND(SUM(gross_revenue) FILTER (WHERE NOT is_return), 2) AS positive_revenue,
       ROUND(ABS(SUM(gross_revenue) FILTER (WHERE is_return)) /
             NULLIF(SUM(gross_revenue) FILTER (WHERE NOT is_return), 0) * 100, 3) AS return_rate_pct
FROM sales_transactions
WHERE channel = 'Retail'
GROUP BY location
ORDER BY return_rate_pct DESC;

-- 7. Discount intensity and profitability
SELECT CASE
           WHEN discount_pct = 0 THEN 'No discount'
           WHEN discount_pct <= 0.10 THEN '1–10%'
           WHEN discount_pct <= 0.20 THEN '11–20%'
           ELSE 'Over 20%'
       END AS discount_band,
       ROUND(SUM(gross_revenue), 2) AS revenue,
       ROUND(SUM(gross_profit), 2) AS profit,
       ROUND(SUM(gross_profit) / NULLIF(SUM(gross_revenue), 0) * 100, 2) AS margin_pct,
       ROUND(SUM(quantity), 0) AS units
FROM sales_transactions
WHERE channel = 'Retail' AND NOT is_return
GROUP BY 1
ORDER BY 1;

-- 8. Comparable-month YoY analysis
WITH monthly AS (
    SELECT EXTRACT(YEAR FROM sale_date)::int AS year,
           EXTRACT(MONTH FROM sale_date)::int AS month_number,
           SUM(gross_revenue) AS revenue
    FROM sales_transactions
    WHERE channel = 'Retail' AND EXTRACT(MONTH FROM sale_date) IN (5, 6, 7)
    GROUP BY 1, 2
)
SELECT month_number,
       ROUND(MAX(revenue) FILTER (WHERE year = 2025), 2) AS revenue_2025,
       ROUND(MAX(revenue) FILTER (WHERE year = 2026), 2) AS revenue_2026,
       ROUND((MAX(revenue) FILTER (WHERE year = 2026) /
              NULLIF(MAX(revenue) FILTER (WHERE year = 2025), 0) - 1) * 100, 2) AS yoy_pct
FROM monthly
GROUP BY month_number
ORDER BY month_number;

-- 9. Weekday pattern
SELECT EXTRACT(ISODOW FROM sale_date)::int AS weekday_number,
       to_char(sale_date, 'Dy') AS weekday,
       ROUND(SUM(gross_revenue), 2) AS revenue,
       COUNT(DISTINCT transaction_id) AS transactions,
       ROUND(SUM(gross_revenue) / NULLIF(COUNT(DISTINCT transaction_id), 0), 2) AS avg_basket
FROM sales_transactions
WHERE channel = 'Retail'
GROUP BY 1, 2
ORDER BY 1;

-- 10. ABC classification by retail revenue
WITH product_sales AS (
    SELECT sku, product_name, SUM(gross_revenue) AS revenue
    FROM sales_transactions
    WHERE channel = 'Retail' AND NOT is_return
    GROUP BY sku, product_name
), ranked AS (
    SELECT *,
           SUM(revenue) OVER (ORDER BY revenue DESC) /
           NULLIF(SUM(revenue) OVER (), 0) AS cumulative_share
    FROM product_sales
)
SELECT sku, product_name, ROUND(revenue, 2) AS revenue,
       ROUND(cumulative_share * 100, 2) AS cumulative_share_pct,
       CASE WHEN cumulative_share <= 0.80 THEN 'A'
            WHEN cumulative_share <= 0.95 THEN 'B' ELSE 'C' END AS abc_class
FROM ranked
ORDER BY revenue DESC;

-- 11. XYZ demand variability by product
WITH months AS (
    SELECT generate_series(date '2025-05-01', date '2026-07-01', interval '1 month')::date AS month
), products AS (
    SELECT DISTINCT sku FROM sales_transactions WHERE channel = 'Retail'
), demand AS (
    SELECT p.sku, m.month, COALESCE(SUM(s.quantity), 0) AS units
    FROM products p CROSS JOIN months m
    LEFT JOIN sales_transactions s ON s.sku = p.sku
      AND s.channel = 'Retail' AND NOT s.is_return
      AND date_trunc('month', s.sale_date)::date = m.month
    GROUP BY p.sku, m.month
), variability AS (
    SELECT sku, AVG(units) AS avg_units, STDDEV_SAMP(units) / NULLIF(AVG(units), 0) AS cv
    FROM demand GROUP BY sku
)
SELECT sku, ROUND(avg_units, 2) AS avg_monthly_units, ROUND(cv, 2) AS coefficient_of_variation,
       CASE WHEN cv <= 0.50 THEN 'X' WHEN cv <= 1.00 THEN 'Y' ELSE 'Z' END AS xyz_class
FROM variability
ORDER BY avg_monthly_units DESC;

-- 12. Retail vs wholesale comparison without mixing basket metrics
SELECT channel,
       ROUND(SUM(gross_revenue), 2) AS revenue,
       COUNT(DISTINCT transaction_id) AS transactions,
       ROUND(SUM(gross_revenue) / NULLIF(COUNT(DISTINCT transaction_id), 0), 2) AS avg_transaction_value,
       ROUND(SUM(gross_profit) / NULLIF(SUM(gross_revenue), 0) * 100, 2) AS margin_pct
FROM sales_transactions
GROUP BY channel;

