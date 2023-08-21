SELECT * FROM PortfolioProject..CovidDeaths 
WHERE continent is not null 
order by 3,4;

--SELECT * FROM dbo.CovidVaccinations
--order by 3,4;

-- Select Data that we are going to use

Select location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths 
WHERE continent is not null 
order by 1,2



-- Looking at Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, ROUND(((total_deaths/total_cases))*100, 1) AS DeathPercentage
FROM PortfolioProject..CovidDeaths 
WHERE location like '%Canada%' and continent is not null
order by 1,2




-- Looking at Total Cases vs Population

Select location, date, total_cases, population, ROUND(((total_cases/population))*100, 2) AS Percent_Population_Infected
FROM PortfolioProject..CovidDeaths 
WHERE location like '%Canada%' and continent is not null
order by 1,2

-- Looking at Total Deaths vs Popluation 

Select location, date, total_deaths, population, ROUND(((total_deaths/population))*100, 2) AS Percent_Population_Dead
FROM PortfolioProject..CovidDeaths 
WHERE location like '%Canada%' and continent is not null
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) AS Highest_Infection_Count, ROUND(MAX((total_cases/population))*100, 2) AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths 
--WHERE location like '%Canada%' and continent is not null
GROUP BY location, population
order by 4 DESC



-- Showing Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as BIGINT)) AS HighestDeathCount
FROM PortfolioProject..CovidDeaths 
WHERE location NOT IN (Select DISTINCT location from PortfolioProject..CovidDeaths WHERE location IN ('Low income', 'HIgh income', 'Upper middle income', 'Lower middle income', 'European Union')) and continent is null
GROUP BY location
order by 2 desc


-- Let's Break things down by Continent

-- Showing continents with the highest death count per population 

Select continent, MAX(cast(total_deaths as BIGINT)) AS HighestDeathCountPerContinent
FROM PortfolioProject..CovidDeaths 
WHERE continent is not null 
GROUP BY continent
order by 2 desc




-- GLOBAL NUMBERS
-- Total Daily cases and deaths as well as death percentage per day in the world. 
Select date, SUM(new_cases) as DailyTotalCases, SUM(new_deaths) as DailyTotalDeaths, ROUND(SUM(new_deaths)/SUM(new_cases)*100,2) as DeathPercentageOfWorld
FROM PortfolioProject..CovidDeaths 
WHERE continent is not null and new_cases <> 0
GROUP BY date
order by 1,2


-- Global numbers
-- Total # of cases and deaths in the world as well as the death percentage
Select SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, ROUND(SUM(new_deaths)/SUM(new_cases)*100,2) as DeathPercentageOfWorld
FROM PortfolioProject..CovidDeaths 
WHERE continent is not null and new_cases <> 0
--GROUP BY date
order by 1,2






--Looking at Total Population vs Mew Vaccinations 

SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
and dea.date = vac.date 
WHERE dea.continent is not null
order by 2,3


-- CTE

WITH PopvsVac (Contient, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
( 
SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
and dea.date = vac.date 
WHERE dea.continent is not null
)
SELECT *, (RollingPeopleVaccinated/population)*100 as PercentageOfPopulationVaccinated
FROM PopvsVac


-- Using a Temp Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated  
Create Table #PercentPopulationVaccinated
(
Contient nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations bigint,
RollingPeopleVaccinated numeric
)
 Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
and dea.date = vac.date 
--WHERE dea.continent is not null
--order by 2,3
SELECT *, RollingPeopleVaccinated/population*100
FROM #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View NumberofPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
and dea.date = vac.date 
WHERE dea.continent is not null
--order by 2,3

