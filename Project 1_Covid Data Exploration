/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

-- Select Data that We are going to use 

select 
	location, date, total_cases, new_cases, total_deaths, population
from 
	CovidDeaths
order by 
	1,2


-- Looking at Total Cases vs Total Deaths 
-- Shows likelihood of dying if you got covid in your country 

select 
	location, date, total_cases, total_deaths,
	concat(round(cast(total_deaths as float)/cast(total_cases as float) *100,3),'%') as percentage_of_death
FROM
    CovidDeaths
--where 
    --location ='United States'
order by 
	1,2



-- looking at Total Cases vs Population 
-- See what percentage of poplucation got covid 
select 
	location, date, total_cases, population,
	concat(round(cast(total_cases as float)/cast(population as float) *100,3),'%') as percentage_of_diagnosed_covid
from 
	CovidDeaths
--WHERE 
	--location = 'United States'
order by 
	1,2



-- looking at countries with highest infection rate compared to population 
select 
	location, population, max(total_cases) as highest_infection,
	round(max((total_cases/population)*100), 3 )as percentage_of_population_infected
from 
	CovidDeaths
group by location, population 
order by 
	4 desc



-- let's break it down to continets from here 

-- Showing the continent with the highest death count 

select 
	continent, max(cast(total_deaths as int)) as total_deaths
from 
	CovidDeaths
where continent is not NULL
group by continent
order by 2 desc



-- GLOBAL NUMBERS 

select 
	 date, sum(new_cases) as total_cases,
	 sum(cast(new_deaths as int)) as total_deaths,
	 round(sum(cast(new_deaths as float))/sum(cast(new_cases as float))*100, 3) as global_death_percentage
from 
	CovidDeaths
where 
	--location = 'United States'
continent IS not NULL 
group by date
order by 
	1,2



--Looking at total population vs vaccinations 
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select 
	covid_death.continent,covid_death.location, covid_death.date, covid_death.population,covid_vaccination.new_vaccinations,
	sum(cast(covid_vaccination.new_vaccinations as bigint)) 
	over (partition by covid_death.location order by covid_death.location,covid_death.date) as rolling_people_vac
from
	CovidDeaths as covid_death
join CovidVaccinations as covid_vaccination 
	on covid_death.location = covid_vaccination.location 
	and covid_death.date = covid_vaccination.date
where covid_death.continent is not NULL
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

with PopvsVac(Continent,location, date, population, new_vaccinations,rolling_people_vac)
as
(
select 
	covid_death.continent,covid_death.location, covid_death.date, covid_death.population,covid_vaccination.new_vaccinations,
	sum(cast(covid_vaccination.new_vaccinations as bigint)) 
	over (partition by covid_death.location order by covid_death.location,covid_death.date) as rolling_people_vac
from
	CovidDeaths as covid_death
join CovidVaccinations as covid_vaccination 
	on covid_death.location = covid_vaccination.location 
	and covid_death.date = covid_vaccination.date
where covid_death.continent is not NULL
--order by 2,3
)

select * , concat((rolling_people_vac/population)*100,'%') as vac_percet
from PopvsVac


-- Creating View to store data for later visualizations

Create VIEW PercentPopulationVaccinated as
Select 
	covid_death.continent,covid_death.location, covid_death.date, covid_death.population,covid_vaccination.new_vaccinations, 
    sum(cast(covid_vaccination.new_vaccinations as bigint)) 
	over (partition by covid_death.location order by covid_death.location,covid_death.date) as rolling_people_vac
    --, (RollingPeopleVaccinated/population)*100
from
	CovidDeaths as covid_death
join CovidVaccinations as covid_vaccination 
	on covid_death.location = covid_vaccination.location 
	and covid_death.date = covid_vaccination.date
where covid_death.continent is not null 
