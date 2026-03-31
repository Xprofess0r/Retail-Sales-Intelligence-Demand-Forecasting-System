CREATE TABLE sales (
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    region VARCHAR(50),
    sales FLOAT,
    profit FLOAT,
    quantity INT
);

SELECT COUNT(*) FROM sales;

SELECT 
    TO_CHAR(DATE_TRUNC('month', order_date), 'YYYY-MM') AS month,
    SUM(sales) AS revenue
FROM sales
GROUP BY month
ORDER BY month;

SELECT 
    category,
    ROUND(SUM(sales)::numeric, 2) AS revenue
FROM sales
GROUP BY category
ORDER BY revenue DESC;

SELECT 
    category,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND((SUM(profit)/SUM(sales))::numeric * 100, 2) AS profit_margin
FROM sales
GROUP BY category;

SELECT 
    region,
    SUM(sales) AS revenue,
    RANK() OVER (ORDER BY SUM(sales) DESC) AS rank
FROM sales
GROUP BY region;

SELECT 
    order_date,
    SUM(sales) OVER (ORDER BY order_date) AS running_total
FROM sales;

WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS revenue
    FROM sales
    GROUP BY month
)
SELECT 
    TO_CHAR(month, 'YYYY-MM') AS month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month,
    ROUND(
    CASE 
        WHEN LAG(revenue) OVER (ORDER BY month) = 0 THEN NULL
        ELSE ((revenue - LAG(revenue) OVER (ORDER BY month)) 
        / LAG(revenue) OVER (ORDER BY month)) * 100
    END::numeric, 2
) AS growth_percent
FROM monthly_sales;

SELECT 
    sub_category,
    SUM(sales) AS revenue,
    RANK() OVER (ORDER BY SUM(sales) DESC) AS rank
FROM sales
GROUP BY sub_category;

SELECT 
    region,
    category,
    SUM(sales) AS revenue
FROM sales
GROUP BY region, category
ORDER BY region, revenue DESC;

SELECT 
    ROUND(AVG(sales)::numeric, 2) AS avg_order_value
FROM sales;