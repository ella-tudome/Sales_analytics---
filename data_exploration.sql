 -- 1 What day of the week is used for each week_date value?
 SELECT week_date,
 to_char(week_date,'day') AS day_of_week
 FROM cleaned_weekly_sales 
 
 ---2 What range of week numbers are missing from the dataset?
WITH week_number_cte AS (
SELECT
	GENERATE_SERIES(1, 52) AS week_number
)
SELECT
  calender_year,
	 wn.week_number
FROM
	week_number_cte wn
WHERE
	NOT EXISTS (
	SELECT
		1
	FROM
		cleaned_weekly_sales cws
	WHERE
		cws.week_number = wn.week_number
		GROUP BY calender_year
 
 ---3 How many total transactions were there for each year in the dataset?
 SELECT
	calender_year,
	sum(transactions) AS total_transactions
FROM
	cleaned_weekly_sales
GROUP BY
	calender_year
ORDER BY
	Calender_year 
 
--4 What is the total sales for each region for each month?
 SELECT
	calender_year,
	month_number ,
	region,
	sum(sales) AS total_sales
FROM
	cleaned_weekly_sales cws
GROUP BY
	calender_year,
	month_number,
	region
ORDER BY
	calender_year,
	month_number
	
	
 --5 What is the total count of transactions for each platform
 SELECT 
 platform,
 sum(transactions) AS total_transactions_by_platform 
 FROM cleaned_weekly_sales
 GROUP BY platform 

--6 What is the percentage of sales for Retail vs Shopify for each month?
WITH sales_cte AS (
  SELECT 
  calender_year,  
    month_number, 
    platform, 
    SUM(sales) AS monthly_sales
  FROM cleaned_weekly_sales 
  GROUP BY calender_year, month_number, platform
)
SELECT 
sc.calender_year,
  sc.month_number, 
  ROUND(100 * MAX 
    (CASE WHEN platform = 'Retail' THEN monthly_sales ELSE NULL END) / 
      SUM(monthly_sales),2) AS retail_share,
  ROUND(100 * MAX 
    (CASE WHEN platform = 'Shopify' THEN monthly_sales ELSE NULL END) / 
      SUM(monthly_sales),2) AS shopify_share
  FROM sales_cte sc
  GROUP BY sc.calender_year,sc.month_number
  ORDER BY sc.calender_year, sc.month_number;

 
--7 What is the percentage of sales by demographic for each year in the dataset?
 WITH demographic_sales AS 
 (SELECT 
 calender_year,
 demographic, 
 sum(sales) AS  yearly_sales
 FROM cleaned_weekly_sales
 WHERE demographic != 'unknown'
 GROUP BY calender_year,demographic)
 SELECT
 calender_year AS calendar_year,
 ROUND(100 * MAX 
    (CASE WHEN demographic = 'Families' THEN yearly_sales  ELSE NULL END) / 
      SUM(yearly_sales),2) || '%' AS families_share,
  ROUND(100 * MAX 
    (CASE WHEN demographic= 'Couples' THEN yearly_sales ELSE NULL END) / 
      SUM(yearly_sales),2) || '%' AS couples_share
    FROM demographic_sales 
    GROUP BY calender_year
    ORDER BY calender_year 

 --8 Which age_band and demographic values contribute the most to Retail sales?
SELECT
	age_band,
	demographic,
	sum(sales) AS total_sales
FROM
	cleaned_weekly_sales
WHERE
	platform = 'Retail'
	AND demographic != 'unknown'
	AND age_band != 'unknown'
GROUP BY
	age_band,
	demographic
ORDER BY
	total_sales DESC

---9 Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? 
  --    If not - how would you calculate it instead?
SELECT
	calender_year,
	platform,
	sum(sales)/ sum(transactions)) AS avg_sales_per_transaction
FROM
	cleaned_weekly_sales
GROUP BY
	calender_year,
	platform
ORDER BY
	calender_year DESC;
