Select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


--Select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

--Select data we will be using 

Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

--Looking at total cases vs total deaths
--Shows likelihood of dying if you contract covid in your country


Select Location, date, total_cases, total_deaths, (CONVERT(float,total_deaths)/NULLIF(CONVERT(float,total_cases),0)) * 100 AS DeathPercentage
from PortfolioProject..CovidDeaths
where Location like '%states%' --Country name wise
order by 1,2


--Looking at total cases vs population
-- Shows what population got Covid
Select Location, date, Population, total_cases,  (CONVERT(float,total_cases)/NULLIF(Population,0)) * 100 AS CovidPercentage
from PortfolioProject..CovidDeaths
--where Location like '%states%' --Country name wise
order by 1,2

--Highest infection rate vs Population in which country
Select Location, Population, MAX(cast(total_cases as bigint)) AS HighestInfectionCount,  MAX((CONVERT(float,total_cases)/NULLIF(CONVERT(float,Population),0))) * 100 AS PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where Location like '%states%' --Country name wise
group by Location, population
order by PercentPopulationInfected desc


--Countries with highest cases count per population
Select Location, Population, MAX(cast(total_cases as bigint)) AS HighestInfectionCount,  MAX((CONVERT(float,total_cases)/NULLIF(CONVERT(float,Population),0))) * 100 AS PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where Location like '%states%' --Country name wise
where continent is not null
group by Location, population
order by PercentPopulationInfected desc

--Countries with highest death count
Select Location, Population, MAX(cast(total_deaths as bigint)) AS TotalDeathCount
from PortfolioProject..CovidDeaths
where continent != ''
group by Location, population
order by TotalDeathCount desc

--Countries with highest death count per population
Select Location, Population, MAX(cast(total_deaths as bigint)) AS TotalDeathCount,  MAX((CONVERT(float,total_deaths)/NULLIF(CONVERT(float,Population),0))) * 100 AS HighestDeathPercent
from PortfolioProject..CovidDeaths
where continent != ''
group by Location, population
order by HighestDeathPercent desc



--Let's break things by continent

--Showing the continents with highest death counts
Select continent, MAX(cast(total_deaths as bigint)) AS TotalDeathCount
from PortfolioProject..CovidDeaths
Where continent !=''
group by continent
order by TotalDeathCount desc

-- Global Numbers
Select date, 
SUM(cast(new_cases as bigint)) AS TotalNewCases , 
SUM(cast(new_deaths as bigint)) AS TotalNewDeaths, 
CONVERT(float, SUM(cast(new_deaths as bigint)))/NULLIF (SUM(cast(new_cases as bigint)),0) * 100 AS DeathPercent
from PortfolioProject..CovidDeaths
Where continent !=''
group by date
order by 1,2

--All the data

Select 
SUM(cast(new_cases as bigint)) AS TotalNewCases , 
SUM(cast(new_deaths as bigint)) AS TotalNewDeaths, 
CONVERT(float, SUM(cast(new_deaths as bigint)))/NULLIF (SUM(cast(new_cases as bigint)),0) * 100 AS DeathPercent
from PortfolioProject..CovidDeaths
Where continent !=''
--group by date
order by 1,2

-- Covid Vaccinations

Select * 
From PortfolioProject..CovidVaccinations


-- Joins from vaccinations and deaths

Select * 
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date


--Looking at total pop vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.Location, dea.date) AS RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent !=''
order by 2,3



-- WITH CTE (CAST AS FLOAT AND ALSO ADDED NULLIF)

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccination, RollingPeopleVaccinated) AS (
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.date) AS RollingPeopleVaccinated
    FROM 
        PortfolioProject..CovidDeaths dea
    JOIN 
        PortfolioProject..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
    WHERE 
        dea.continent != ''
)
SELECT 
    *, 
    CAST(RollingPeopleVaccinated AS FLOAT) / NULLIF(CAST(Population AS FLOAT), 0) * 100 AS VaccinatedPeoplePercent
FROM 
    PopvsVac;

-- WITH TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date nvarchar(255),
Population nvarchar(255),
New_vaccinations nvarchar(255),
RollingPeopleVaccinated nvarchar(255)
)
Insert into #PercentPopulationVaccinated
SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.date) AS RollingPeopleVaccinated
    FROM 
        PortfolioProject..CovidDeaths dea
    JOIN 
        PortfolioProject..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
    WHERE 
        dea.continent != ''


SELECT 
    *, 
    CAST(RollingPeopleVaccinated AS FLOAT) / NULLIF(CAST(Population AS FLOAT), 0) * 100 AS VaccinatedPeoplePercent
FROM 
    #PercentPopulationVaccinated;



--Creating View to store data for later visaulizations

Create View PercentPopulationVaccinatedView as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.Location, dea.date) AS RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent !=''
--order by 2,3

Select * 
from PercentPopulationVaccinatedView
























