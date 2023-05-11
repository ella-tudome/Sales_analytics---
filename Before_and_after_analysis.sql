-- This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.
-- Taking the week_date value of 2020-06-15 as the baseline week where the Data Mart sustainable packaging changes came into effect.
-- We would include all week_date values for 2020-06-15 as the start of the period after the change and the previous week_date values would be before.
-- Using this analysis approach - answer the following questions:

-- What is the total sales for the 4 weeks before and after 2020-06-15? 
-- What is the growth or reduction rate in actual values and percentage of sales? 
WITH after_change AS (
  SELECT
    SUM(sales) AS sales_after
  FROM
    cleaned_weekly_sales
  WHERE
    week_date > DATE '2020-06-15'
    AND week_date <= DATE '2020-06-15' + INTERVAL '4 weeks'
), 
before_change AS (
  SELECT
    SUM(sales) AS sales_before
  FROM
    cleaned_weekly_sales
  WHERE
    week_date < DATE '2020-06-15'
    AND week_date >= DATE '2020-06-15' - INTERVAL '4 weeks'
)
SELECT
  ac.sales_after,
  bc.sales_before,
  ac.sales_after - bc.sales_before AS difference,
  ROUND((CAST(sales_after AS NUMERIC) - CAST(sales_before AS NUMERIC)) / sales_before * 100, 2) AS percent_change
FROM
  after_change AS ac
JOIN 
  before_change AS bc ON 1 = 1;

-- What about the entire 12 weeks before and after?
WITH after_change AS (
  SELECT
    SUM(sales) AS sales_after
  FROM
    cleaned_weekly_sales
  WHERE
    week_date >= DATE '2020-06-15'
    AND week_date <= DATE '2020-06-15' + INTERVAL '12 weeks'
),
before_change AS (
  SELECT
    SUM(sales) AS sales_before
  FROM
    cleaned_weekly_sales
  WHERE
    week_date < DATE '2020-06-15'
    AND week_date >= DATE '2020-06-15' - INTERVAL '12 weeks'
)
SELECT
  ac.sales_after,
  bc.sales_before,
  ac.sales_after - bc.sales_before AS difference,
  ROUND((CAST(sales_after AS NUMERIC) - CAST(sales_before AS NUMERIC)) / sales_before * 100, 2) AS percent_change
FROM
  after_change AS ac
JOIN 
  before_change AS bc ON 1 = 1;

-- How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
-- 2018, 2019, 2020.

-- Find the week number for 2020-06-15.
SELECT
  DISTINCT week_number
FROM
  cleaned_weekly_sales
WHERE
  week_date = '2020-06-15';

WITH yearly_change AS (
  SELECT
    calendar_year,
    sum(CASE WHEN week_number < 25 THEN sales END) AS sales_before,
    sum(CASE WHEN week_number >= 25 THEN sales END) AS sales_after
  FROM
    cleaned_weekly_sales
  GROUP BY
    calendar_year
  ORDER BY
    calendar_year 
) 
SELECT
  *,
  (sales_after - sales_before) AS difference,
  ROUND((CAST(sales_after AS NUMERIC) - CAST(sales_before AS NUMERIC)) / sales_before * 100,

--Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12 week before and after period?
--Region

WITH after_change AS (
  SELECT
    region,
    SUM(sales) AS sales_after
  FROM cleaned_weekly_sales
  WHERE week_date >= DATE '2020-06-15'
    AND week_date <= DATE '2020-06-15' + INTERVAL '12 weeks'
  GROUP BY region
), 
before_change AS (
  SELECT 
    region,
    SUM(sales) AS sales_before
  FROM cleaned_weekly_sales
  WHERE week_date < DATE '2020-06-15'
    AND week_date >= DATE '2020-06-15' - INTERVAL '12 weeks'
  GROUP BY region
) 
SELECT 
  after_change.region,
  after_change.sales_after,
  before_change.sales_before,
  round((cast(sales_after as numeric) - cast(sales_before  as numeric))/sales_before* 100,2) as pct_change
FROM after_change
JOIN before_change
ON after_change.region = before_change.region;

---platform 
WITH after_change AS (
  SELECT
    platform,
    SUM(sales) AS sales_after
  FROM cleaned_weekly_sales
  WHERE week_date >= DATE '2020-06-15'
    AND week_date <= DATE '2020-06-15' + INTERVAL '12 weeks'
  GROUP BY platform
), 
before_change AS (
  SELECT 
    platform,
    SUM(sales) AS sales_before
  FROM cleaned_weekly_sales
  WHERE week_date < DATE '2020-06-15'
    AND week_date >= DATE '2020-06-15' - INTERVAL '12 weeks'
  GROUP BY platform
) 
SELECT 
  after_change.platform,
  after_change.sales_after,
  before_change.sales_before,
  round((cast(sales_after as numeric) - cast(sales_before  as numeric))/sales_before* 100,2) as pct_change
FROM after_change
JOIN before_change
ON after_change.platform = before_change.platform;

--ageband

WITH after_change AS (
  SELECT
    age_band,
    SUM(sales) AS sales_after
  FROM cleaned_weekly_sales
  WHERE week_date >= DATE '2020-06-15'
    AND week_date <= DATE '2020-06-15' + INTERVAL '12 weeks'
  GROUP BY age_band
), 
before_change AS (
  SELECT 
    age_band,
    SUM(sales) AS sales_before
  FROM cleaned_weekly_sales
  WHERE week_date < DATE '2020-06-15'
    AND week_date >= DATE '2020-06-15' - INTERVAL '12 weeks'
  GROUP BY age_band
) 
SELECT 
  after_change.age_band,
  after_change.sales_after,
  before_change.sales_before,
  round((cast(sales_after as numeric) - cast(sales_before  as numeric))/sales_before* 100,2) as pct_change
FROM after_change
JOIN before_change
ON after_change.age_band= before_change.age_band
WHERE after_change.age_band != 'unknown';

---Demographic
WITH after_change AS (
  SELECT
    demographic,
    SUM(sales) AS sales_after
  FROM cleaned_weekly_sales
  WHERE week_date >= DATE '2020-06-15'
    AND week_date <= DATE '2020-06-15' + INTERVAL '12 weeks'
  GROUP BY demographic 
), 
before_change AS (
  SELECT 
    demographic,
    SUM(sales) AS sales_before
  FROM cleaned_weekly_sales
  WHERE week_date < DATE '2020-06-15'
    AND week_date >= DATE '2020-06-15' - INTERVAL '12 weeks'
  GROUP BY demographic 
) 
SELECT 
  after_change.demographic,
  after_change.sales_after,
  before_change.sales_before,
  round((cast(sales_after as numeric) - cast(sales_before  as numeric))/sales_before* 100,2) as pct_change
FROM after_change
JOIN before_change
ON after_change.demographic = before_change.demographic
;

--- Customer_type
WITH after_change AS (
  SELECT
    customer_type ,
    SUM(sales) AS sales_after
  FROM cleaned_weekly_sales
  WHERE week_date >= DATE '2020-06-15'
    AND week_date <= DATE '2020-06-15' + INTERVAL '12 weeks'
  GROUP BY customer_type 
), 
before_change AS (
  SELECT 
    customer_type,
    SUM(sales) AS sales_before
  FROM cleaned_weekly_sales
  WHERE week_date < DATE '2020-06-15'
    AND week_date >= DATE '2020-06-15' - INTERVAL '12 weeks'
  GROUP BY customer_type 
) 
SELECT 
  after_change.customer_type,
  after_change.sales_after,
  before_change.sales_before,
  round((cast(sales_after as numeric) - cast(sales_before  as numeric))/sales_before* 100,2) as pct_change
FROM after_change
JOIN before_change
ON after_change.customer_type  = before_change.customer_type;
