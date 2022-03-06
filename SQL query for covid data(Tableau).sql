/*  

Queries I am going to be using for the tableau project


*/

--1 This query contains the sum of total_cases, sum of total deaths and also the death percentage which i calculated as sum of totaldeaths/newcases 
--multiplied by 100 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
where continent is not null 
--Group By date
order by 1,2


--2
-- This query shows the sum of deathcount  based on locations


Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
Where continent is null 
and location not in ('World', 'European Union', 'International','Upper middle income', 'High income', 'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc


--3
-- LOcations with their higest infection counts recorded 

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
Group by Location, Population, date
order by PercentPopulationInfected desc




