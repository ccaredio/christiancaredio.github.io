-- Written by: Christian Caredio
-- Date 02/08/2022
-- Purpose: The purpose of these queries is to explore video game data downloaded from Kaggle. Using these queries, I was able to 
-- analyze the overall sales trend of video games by region and globally. I was also able to see which publishers have been the 
-- most successful, as well as which genres have been the most popular. The dashboard created with this data is available via my 
-- tableau public profile: https://public.tableau.com/app/profile/christian.caredio/viz/VideoGameDashboard_16444488111770/Dashboard1?publish=yes




SELECT
	*
FROM 
	PortfolioProject..vgsales


-- Global Sales by Gaming Platfrom

SELECT
	Platform, SUM(Global_Sales) as totalsales
FROM 
	PortfolioProject..vgsales
GROUP BY
	Platform
ORDER BY
	totalsales desc


-- GlobalSales by Gaming Publisher

SELECT
	Publisher, SUM(Global_Sales) as totalsales
FROM 
	PortfolioProject..vgsales
GROUP BY
	Publisher
ORDER BY
	totalsales desc

-- Comparing the different regions sales

SELECT
	ROUND(SUM(NA_Sales),2) as total_NA_sales, ROUND(SUM(EU_Sales),2) as total_EU_sales, ROUND(SUM(JP_Sales),2) as total_JP_sales, 
	ROUND(SUM(Other_Sales),2) as total_Other_sales, ROUND(SUM(global_sales),2) as total_Global_sales
FROM
	PortfolioProject..vgsales

-- Popularity of platform in each region

SELECT
	Platform, ROUND(SUM(NA_Sales),2) as total_NA_sales, ROUND(SUM(EU_Sales),2) as total_EU_sales, ROUND(SUM(JP_sales), 2) as total_JP_sales,
	ROUND(SUM(Other_Sales),2) as total_Other_sales,ROUND(SUM(global_sales), 2) as total_global_sales
FROM
	PortfolioProject..vgsales
GROUP BY
	Platform
ORDER BY
	total_global_sales desc


-- Top ten publishers in North America

SELECT
	TOP 10 Publisher, ROUND(SUM(NA_Sales),2) as total_NA_sales
FROM
	PortfolioProject..vgsales
GROUP BY
	Publisher
ORDER BY
	total_NA_sales desc

-- Top ten publishers in the European Union

SELECT
	TOP 10 Publisher, ROUND(SUM(EU_sales),2) as total_EU_sales
FROM
	PortfolioProject..vgsales
GROUP BY
	Publisher
ORDER BY
	total_EU_sales desc

-- Top ten publishers in Japan

SELECT
	TOP 10 Publisher, ROUND(SUM(JP_Sales),2) as total_JP_sales
FROM
	PortfolioProject..vgsales
GROUP BY
	Publisher
ORDER BY
	total_JP_sales desc

-- Top 10 publishers worldwide

SELECT
	TOP 10 Publisher, ROUND(SUM(Global_Sales),2) as total_Global_sales
FROM
	PortfolioProject..vgsales
GROUP BY
	Publisher
ORDER BY
	total_Global_sales desc


-- Top ten platforms worldwide

SELECT
	Top 10 Platform, SUM(Global_Sales) as totalsales
FROM 
	PortfolioProject..vgsales
GROUP BY
	Platform
ORDER BY
	totalsales desc

-- How have video game sales changed over the years?

SELECT
	Year, ROUND(SUM(NA_sales),2) as total_NA_sales, ROUND(SUM(EU_Sales),2) as total_EU_sales, ROUND(SUM(JP_Sales),2) as total_JP_sales, 
	ROUND(SUM(Other_Sales),2) as total_Other_sales, ROUND(SUM(global_sales),2) as total_global_sales
FROM 
	PortfolioProject..vgsales
GROUP BY
	Year
ORDER BY
	Year asc

-- Genre popularity

SELECT
	Genre, ROUND(SUM(global_sales),2) as total_global_sales
FROM 
	PortfolioProject..vgsales
GROUP BY
	Genre
ORDER BY
	total_global_sales desc

-- Genre popularity by region and global

SELECT
	Genre, ROUND(SUM(NA_Sales),2) as total_NA_sales, ROUND(SUM(EU_Sales),2) as total_EU_sales, ROUND(SUM(JP_Sales),2) as total_JP_sales, 
	ROUND(SUM(Other_Sales),2) as total_Other_sales, ROUND(SUM(Global_sales),2) as total_Global_sales
FROM
	PortfolioProject..vgsales
GROUP BY 
	Genre
ORDER BY 
	Genre

-- Most popular genres over the years

SELECT
	Year, Genre, ROUND(SUM(global_sales),2) as total_global_sales
FROM 
	PortfolioProject..vgsales
GROUP BY
	Year, Genre
ORDER BY
	Year 


