--created by Tudome Emmanuella 
--POSTGRESQL

CREATE TABLE cleaned_weekly_sales AS
SELECT
  TO_DATE(week_date, 'DD/MM/YY') AS week_date,
  EXTRACT(WEEK FROM TO_DATE(week_date, 'DD/MM/YY')) AS week_number,
  EXTRACT(MONTH FROM TO_DATE(week_date, 'DD/MM/YY')) AS month_number,
  EXTRACT(YEAR FROM TO_DATE(week_date, 'DD/MM/YY')) AS calendar_year,
  region,
  platform,
  REPLACE(segment, 'null', 'unknown') AS segment,
  CASE
    WHEN segment LIKE '%1' THEN 'Young Adult'
    WHEN segment LIKE '%2' THEN 'Middle'
    WHEN segment LIKE '%3' THEN 'Retirees'
    WHEN segment LIKE '%4' THEN 'Retirees'
    ELSE 'unknown'
  END AS age_band,
  CASE
    WHEN LEFT(segment, 1) = 'C' THEN 'Couples'
    WHEN LEFT(segment, 1) = 'F' THEN 'Families'
    ELSE 'unknown'
  END AS demographic,
  customer_type,
  transactions,
  sales,
  ROUND((sales::decimal / transactions), 2) AS avg_transaction
FROM
  weekly_sales;
