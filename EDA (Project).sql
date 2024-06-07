-- Exploratory Data analysis

select *
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;


select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;


select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 DESC;


select min(`date`), max(`date`)
from layoffs_staging2;


select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 DESC;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 DESC;

select company, avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 DESC;


select SUBSTRING(`date`,1,7) `MONTH`, sum(total_laid_off)
from layoffs_staging2
where  SUBSTRING(`date`,1,7) IS NOT NULL
group by `MONTH`
order by 1 ASC
;


with Rolling_Total as
(
select SUBSTRING(`date`,1,7) `MONTH`, sum(total_laid_off) total_off
from layoffs_staging2
where  SUBSTRING(`date`,1,7) IS NOT NULL
group by `MONTH`
order by 1 ASC
)
select `MONTH`, total_off,
SUM(total_off) over(order by `MONTH`) as rolling_total
from Rolling_Total;


select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;


select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by company asc;

select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;


with company_year (company, years, total_laid_off) AS
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), company_year_rank as 
(
SELECT *, 
dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years IS NOT NULL
)
select *
from company_year_rank
where ranking <= 5
;