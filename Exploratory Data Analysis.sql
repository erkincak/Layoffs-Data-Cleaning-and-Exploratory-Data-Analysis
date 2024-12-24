-- Explaratory Data Analysis , EDA
 
 SELECT *
 FROM layoffs_staging2;
 
 
 
SELECT MAX(total_laid_off)
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

-- Looking for the total laid off in countries
SELECT country , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Layoffs by date
SELECT `date` , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC;

-- Layoffs by years
SELECT YEAR(`date`) , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Layoffs by stages
SELECT stage , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;

-- Total Layoffs by companies
SELECT company , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Layoffs by months
SELECT SUBSTRING(`date`,1,7) AS `MONTH` , SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- We can observe monthly layoffs and total layoffs on a monthly basis. 
WITH Rolling_Total AS (
SELECT SUBSTRING(`date`,1,7) AS `MONTH` , SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH` , total_laid ,SUM(total_laid) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- We can see how much total layoffs a company made in which year.
SELECT company ,YEAR( `date`), SUM(total_laid_off )
FROM layoffs_staging2
GROUP BY company ,YEAR( `date`)
ORDER BY 3 DESC ;

-- The 5 biggest layoffs every year
WITH company_year(company ,years ,total_laid_off ) AS(
SELECT company ,YEAR( `date`), SUM(total_laid_off )
FROM layoffs_staging2
GROUP BY company ,YEAR( `date`)
), Company_Year_Rank AS (
SELECT * , 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC ) AS Rankk
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Rankk <= 5
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC; 	;

-- Layoffs percentage by companies
SELECT company , ROUND(SUM(percentage_laid_off),2 )
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- Layoffs percentage by stage of the company
SELECT stage, ROUND(AVG(percentage_laid_off),2)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


