-- Written By: Christian Caredio
-- Date: 02/02/2022
-- Purpose: The purpose of this project was to take Covid-19 data from ourworldindata.org and explore it. I will then take the data 
-- and create a dashboard in Tableau to visualize it. The dashboard created for this project is available via my tableau public 
-- profile: https://public.tableau.com/app/profile/christian.caredio/viz/CovidDashboard_16440050798360/Dashboard1



SELECT 
	*
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	continent is not null
ORDER BY 3,4

SELECT 
	*
FROM 
	PortfolioProject..CovidVaccinations
ORDER BY 3,4

-- First, we will select the data we will use. 

SELECT 
	Location, date, total_cases, new_cases, total_deaths, population
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	continent is not null
ORDER BY 
	1,2

-- Comparing Total Cases vs Total Deaths of the United States
-- This will show the likelihood of dying to Covid if contracted within your country

SELECT 
	Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM 
	PortfolioProject..CovidDeaths
-- WHERE location like '%states%' (This would filter to only show the United States)
ORDER BY 
	1,2


-- Total Cases vs Population of the United States
-- This will show the percentage of the population that has contracted Covid

SELECT 
	Location, date, Population, total_cases, (total_cases/Population)*100 as ContractedPercentage
FROM 
	PortfolioProject..CovidDeaths
-- WHERE location like '%states%'
ORDER BY 
	1,2

-- Highest Infection Rate compared to Population

Create View HighestInfectionRate as 
SELECT 
	Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as ContractedPercentage
FROM 
	PortfolioProject..CovidDeaths
-- WHERE location like '%states%'
WHERE 
	continent is not null
GROUP BY
	Location, Population

SELECT *
FROM HighestInfectionRate
ORDER BY ContractedPercentage desc

-- Countries with the Highest Death Count per Population

Create View TotalDeathCount as
SELECT 
	Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM 
	PortfolioProject..CovidDeaths
-- WHERE location like '%states%'
WHERE 
	continent is not null
GROUP BY
	Location

SELECT *
FROM TotalDeathCount
ORDER BY 
	TotalDeathCount desc


-- Continents with highest death count per population

SELECT 
	location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM 
	PortfolioProject..CovidDeaths
-- WHERE location like '%states%'
WHERE 
	continent is null
GROUP BY
	location
ORDER BY 
	TotalDeathCount desc

-- Global numbers

SELECT 
	date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	continent is not null
GROUP BY 
	date
ORDER BY 
	1,2

SELECT 
	SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	continent is not null
ORDER BY 
	1,2

-- Refresh our memory on the vaccinations table

SELECT 
	*
FROM
	PortfolioProject..CovidVaccinations


-- Total population vs vaccinations

SELECT 
	death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
	SUM(CONVERT(bigint, vacc.new_vaccinations)) OVER (Partition by death.location Order BY death.location, death.date) 
	as RollingPeopleVaccinated

FROM 
	PortfolioProject..CovidDeaths as death
JOIN 
	PortfolioProject..CovidVaccinations as vacc
	ON death.location = vacc.location and
	death.date = vacc.date
WHERE 
	death.continent is not null
ORDER BY
	2,3

-- Use a CTE

With PopvsVac(Continent, Location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
SELECT 
	death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
	SUM(CONVERT(bigint, vacc.new_vaccinations)) OVER (Partition by death.location Order BY death.location, death.date) 
	as RollingPeopleVaccinated
FROM 
	PortfolioProject..CovidDeaths as death
JOIN 
	PortfolioProject..CovidVaccinations as vacc
	ON death.location = vacc.location and
	death.date = vacc.date
WHERE 
	death.continent is not null
-- ORDER BY 2,3
	)
SELECT 
	*, (RollingPeopleVaccinated/Population)*100 as RollingPercent
FROM 
	PopvsVac

-- Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT 
	death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
	SUM(CONVERT(bigint, vacc.new_vaccinations)) OVER (Partition by death.location Order BY death.location, death.date) 
	as RollingPeopleVaccinated
FROM 
	PortfolioProject..CovidDeaths as death
JOIN 
	PortfolioProject..CovidVaccinations as vacc
	ON death.location = vacc.location and
	death.date = vacc.date
WHERE 
	death.continent is not null
-- ORDER BY 2,3

SELECT 
	*, (RollingPeopleVaccinated/Population)*100 as RollingPercent
FROM 
	#PercentPopulationVaccinated


-- Creating a view to store data for later visualizations

Create View PercentPopulationVaccinated as 
SELECT 
	death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
	SUM(CONVERT(bigint, vacc.new_vaccinations)) OVER (Partition by death.location Order BY death.location, death.date) 
	as RollingPeopleVaccinated
FROM 
	PortfolioProject..CovidDeaths as death
JOIN 
	PortfolioProject..CovidVaccinations as vacc
	ON death.location = vacc.location and
	death.date = vacc.date
WHERE 
	death.continent is not null
-- Order By 2,3

SELECT 
	*
FROM 
	PercentPopulationVaccinated
