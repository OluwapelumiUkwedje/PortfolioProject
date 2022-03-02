
Select * 
From PortfolioProject ..CovidDeaths
Where continent is not null
order by 3,4


--Select * 
--From PortfolioProject ..CovidVaccinations
--order by 3,4

--Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population 
From PortfolioProject ..CovidDeaths
Where continent is not null
order by 1,2

--Looking at Total cases vs Total Deaths
--Shows the liklyhood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject ..CovidDeaths
Where Location like '%Nigeria%'
Where continent is not null
order by 1,2

--Looking at the Total cases vs the Population
--Shows what percentage of population got covid

Select Location, date,Population, total_cases, (total_cases/population)*100 as PopulationPercentage
From PortfolioProject ..CovidDeaths
Where Location like '%Nigeria%'
Where continent is not null
order by 1,2

--Looking at countries with Highest  infection rate compared to population



Select Location, Population, MAX(total_cases) as HigestInfectionCount, MAX((total_cases/population))*100 as PopulationPercentageInfected
From PortfolioProject ..CovidDeaths
--Where Location like '%Nigeria%'
Where continent is not null
Group by location, Population
order by  PopulationPercentageInfected desc



--Showing Countries With Highest DEath count per Population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject ..CovidDeaths
--Where Location like '%Nigeria%'
Where continent is not null
Group by location
order by  TotalDeathCount desc

--Let's Break things down by continent


--Showing the continent with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject ..CovidDeaths
--Where Location like '%Nigeria%'
Where continent is not null
Group by continent
order by  TotalDeathCount desc


-- GLOBAL LOCATION

Select   SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_Deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject ..CovidDeaths
--Where Location like '%Nigeria%'
Where continent is not null
--Group By date
order by 1,2



  --Looking at Total Population vs Vaccinations

Select *
From PortfolioProject ..CovidDeaths dea
Join PortfolioProject ..CovidVaccinations vac
       On dea.location = vac.location
	   and dea.date = vac.date

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations )) OVER (Partition by dea.Location Order by dea.location, dea.date)
as RollingPeopleVaccinated
From PortfolioProject ..CovidDeaths dea
Join PortfolioProject ..CovidVaccinations vac
       On dea.location = vac.location
	   and dea.date = vac.date
	   Where dea.continent is not null
	   Order by 2,3

	   -- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations )) OVER (Partition by dea.Location Order by dea.location, dea.date)
as RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*
From PortfolioProject ..CovidDeaths dea
Join PortfolioProject ..CovidVaccinations vac
       On dea.location = vac.location
	   and dea.date = vac.date
	   Where dea.continent is not null
	 --  Order by 2,3
	   )

	   Select * 
	   From PopvsVac


 -- TEMP TABLE

 DROP Table if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )

 Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations )) OVER (Partition by dea.Location Order by dea.location, dea.date)
as RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*
From PortfolioProject ..CovidDeaths dea
Join PortfolioProject ..CovidVaccinations vac
       On dea.location = vac.location
	   and dea.date = vac.date
	   --Where dea.continent is not null
	 --  Order by 2,3
	  

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




--Creating view to store for visualizations 


Create View PercentPopulationVaccinated as

 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations )) OVER (Partition by dea.Location Order by dea.location, dea.date)
as RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*
From PortfolioProject ..CovidDeaths dea
Join PortfolioProject ..CovidVaccinations vac
       On dea.location = vac.location
	   and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

Select *
From PercentPopulationVaccinated