SELECT *
FROM portfolioproject.coviddeaths
order by 3,4;

SELECT * 
FROM portfolioproject.covidvaccinations
ORDER BY 3,4;

##Selecting the data that we're going to use

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM portfolioproject.coviddeaths
WHERE continent is not null
ORDER BY 1,2;

## Closer look at Total cases vs Total deaths
## Shows death percentage in india

SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS DeathPercent
FROM portfolioproject.coviddeaths
WHERE location like '%India%'
and continent is not null
ORDER BY 1,2;

## Closer look at total cases vs population
## Show the percentage of population who got affected

SELECT location, date, total_cases, population,(total_cases/population)*100 AS CovidPercent
FROM portfolioproject.coviddeaths
WHERE location like '%India%'
ORDER BY 1,2;

## Looking at countries with higher infection rate

SELECT location, MAX(total_cases) AS HighestInfection, population, MAX((total_cases/population))*100 AS CovidPercent
FROM portfolioproject.coviddeaths
GROUP BY location, population
ORDER BY CovidPercent desc;

## Showing countries with highest death counts per population

 ## Showing countries with highest death counts per population
 
SELECT location, MAX(total_deaths)as TotalDeathCount
FROM portfolioproject.coviddeaths
WHERE continent is not null
GROUP BY location 
ORDER BY TotalDeathCount desc;

## Highest death count by continent
## howing continents with the highest death count per population

SELECT continent, MAX(total_deaths)as TotalDeathCount
FROM portfolioproject.coviddeaths
WHERE continent is not null
GROUP BY continent 
ORDER BY TotalDeathCount desc;

## GLOBAL NUMBERS

SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/ SUM(new_cases)*100 AS DeathPercentage
FROM portfolioproject.coviddeaths
WHERE continent is not null
GROUP BY date 
ORDER BY 1,2;

## LOOKING AT TOTAL POPULATION vs VACCINATION

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as PeopleVaccinated
FROM portfolioproject.coviddeaths dea
JOIN portfolioproject.covidvaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date 
WHERE dea.continent is not null
ORDER BY 2,3;

## USING CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as 
  (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations ) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as PeopleVaccinated 
FROM portfolioproject.coviddeaths dea
JOIN portfolioproject.covidvaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date 
WHERE dea.continent is not null
  )
SELECT *, (PeopleVaccinated/ population)*100
FROM PopvsVac;

## TEMP TABLE

DROP Table if exists PercentPopulationVaccinated;
CREATE TABLE PercentPopulationVaccinated
(
  continent varchar(255),
  location varchar(255),
  date datetime,
  population numeric,
  new_vaccinations numeric,
  PeopleVaccinated numeric
);

INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as PeopleVaccinated 
FROM portfolioproject.coviddeaths dea
JOIN portfolioproject.covidvaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date;

SELECT *, (PeopleVaccinated/ population)*100
FROM PercentPopulationVaccinated;

## Creating view to store data for later visualisaton

CREATE VIEW PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as PeopleVaccinated 
FROM portfolioproject.coviddeaths dea
JOIN portfolioproject.covidvaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date 
WHERE dea.continent is not null
