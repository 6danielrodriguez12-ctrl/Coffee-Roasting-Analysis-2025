/* STEP 1: DATA CONSOLIDATION
Creating a Unified View to merge all monthly roasting tables from May to December.
This allows us to analyze the entire year in a single dataset.
*/

CREATE OR REPLACE VIEW Roast_Annual_Total AS
SELECT beans, id_product, weight_green_beans, weight_roasted_beans, price_euro, 'May' AS month FROM Roast_may
UNION ALL
SELECT beans, id_product, weight_green_beans, weight_roasted_beans, price_euro, 'June' AS month FROM Roast_june
UNION ALL
SELECT beans, id_product, weight_green_beans, weight_roasted_beans, price_euro, 'July' AS month FROM Roast_july
UNION ALL
SELECT beans, id_product, weight_green_beans, weight_roasted_beans, price_euro, 'August' AS month FROM Roast_august
UNION ALL
SELECT beans, id_product, weight_green_beans, weight_roasted_beans, price_euro, 'September' AS month FROM Roast_september
UNION ALL
SELECT beans, id_product, weight_green_beans, weight_roasted_beans, price_euro, 'October' AS month FROM Roast_october
UNION ALL
SELECT beans, id_product, weight_green_beans, weight_roasted_beans, price_euro, 'November' AS month FROM Roast_november
UNION ALL
SELECT beans, id_product, weight_green_beans, weight_roasted_beans, price_euro, 'December' AS month FROM Roast_december;

-- Verify the consolidated data
SELECT * FROM `roast_annual_total`;

/* STEP 2: EFFICIENCY ANALYSIS BY COFFEE BEAN TYPE
Calculating the average weight loss percentage and total financial impact 
per bean type to identify which products are less efficient during the roasting process.
*/

SELECT 
    beans,
    AVG((weight_green_beans - weight_roasted_beans) / weight_green_beans) * 100 AS avg_loss_pct,
    SUM((weight_green_beans - weight_roasted_beans) * price_euro) AS total_money_lost
FROM roast_annual_total
GROUP BY beans
ORDER BY total_money_lost DESC;

/* STEP 3: MONTHLY PRODUCTION TRENDS
Aggregating total green vs. roasted weight per month.
The 'monthly_loss_pct' metric is used to track roasting performance over time 
and visualize trends in Tableau.
*/

SELECT 
    month, 
    SUM(weight_green_beans) AS total_green,
    SUM(weight_roasted_beans) AS total_roasted,
    (SUM(weight_green_beans - weight_roasted_beans) / SUM(weight_green_beans)) * 100 AS monthly_loss_pct
FROM roast_annual_total
GROUP BY month;