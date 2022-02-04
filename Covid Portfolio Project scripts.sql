-- Welcome to my very first Data Analyst Portfolio Project using SQL doing data exploratin 
-- In this first exploration project, I will be digging into the covid deaths and covid vaccination and looking at the vacciation percentage, global death rate and etc. 


select * 
from 
	--[Portfolio 1].[dbo].[CovidDeaths$]
order 3,4 


--select * 
--from 
--	dbo.CovidVaccinations
--order by 3,4

-- Select Data that We are going to use 

select 
	location, date, total_cases, new_cases, total_deaths, population
from 
	[Portfolio 1].[dbo].[CovidDeaths$]
order by 
	1,2


-- Looking at Total Cases vs Total Deaths 
-- Shows likelihood of dying if you got covid in your country 
select 
	location, date, total_cases, total_deaths,
	Format((Total_deaths/total_cases),'P') as percentage_of_death
from 
	[Portfolio 1].[dbo].[CovidDeaths$]
where 
	location = 'United States'
order by 
	1,2

-- looking at Total Cases vs Population 
-- See what percentage of poplucation got covid 
select 
	location, date, total_cases, population,
	Format((total_cases/population),'P1') as percentage_of_diagnosed_covid
from 
	[Portfolio 1].[dbo].[CovidDeaths$]
where 
	location = 'United States'
order by 
	1,2


-- looking at countries with highest infection rate compared to population 
select 
	location, population, max(total_cases) as highest_infection,
	max((total_cases/population)*100) as percentage_of_population_infected
from 
	[Portfolio 1].[dbo].[CovidDeaths$]
group by location, population 
order by 
	4 desc


-- let's break it down to continets from here 

-- Showing the continent with the highest death count 

select 
	continent, max(cast(total_deaths as int)) as total_deaths
from 
	[Portfolio 1].[dbo].[CovidDeaths$]
where continent is not NULL
group by continent
order by 2 desc


-- GLOBAL NUMBERS 

select 
	 date, sum(new_cases) as total_cases,
	 sum(cast(new_deaths as int)) as total_deaths,
	 format(sum(cast(new_deaths as int))/sum(new_cases),'P2') as global_death_percentage
from 
	[Portfolio 1].[dbo].[CovidDeaths$]
where 
	--location = 'United States'
continent is not NULL 
group by date
order by 
	1,2


--Looking at total population vs vaccinations 

select 
	covid_death.continent,covid_death.location, covid_death.date, covid_death.population,covid_vaccination.new_vaccinations,
	sum(cast(covid_vaccination.new_vaccinations as bigint)) 
	over (partition by covid_death.location order by covid_death.location,covid_death.date) as rolling_people_vac
	, max(rolling_people_vac)
from
	[Portfolio 1].[dbo].[CovidDeaths$] as covid_death
join [Portfolio 1].[dbo].[CovidVaccinations] as covid_vaccination 
	on covid_death.location = covid_vaccination.location 
	and covid_death.date = covid_vaccination.date
where covid_death.continent is not NULL
order by 2,3


-- CTE

with PopvsVac(Continent,location, date, population, new_vaccinations,rolling_people_vac)
as
(
select 
	covid_death.continent,covid_death.location, covid_death.date, covid_death.population,covid_vaccination.new_vaccinations,
	sum(cast(covid_vaccination.new_vaccinations as bigint)) 
	over (partition by covid_death.location order by covid_death.location,covid_death.date) as rolling_people_vac
from
	[Portfolio 1].[dbo].[CovidDeaths$] as covid_death
join [Portfolio 1].[dbo].[CovidVaccinations] as covid_vaccination 
	on covid_death.location = covid_vaccination.location 
	and covid_death.date = covid_vaccination.date
where covid_death.continent is not NULL
--order by 2,3
)

select * , format((rolling_people_vac/population), 'P2')as vac_percet
from PopvsVac
