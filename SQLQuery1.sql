--Select all from the tables 
select * From EllaniDB..CovidDeaths

select * From EllaniDB..CovidVaccinations

--Select data by Location
Select Location, date, total_cases, new_cases, total_deaths, population 
From EllaniDB..CovidDeaths
order by Location

--Total Cases vs Total Deaths in Malaysia, show the percentage of death 
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From EllaniDB..CovidDeaths
Where location = 'Malaysia'
order by date

--Total Cases vs Population, show percentage of infected 
Select Location, date, total_cases,population,(total_cases/population)*100 as infected_Percentage
From EllaniDB..CovidDeaths
Where location = 'Malaysia'
order by date

-- Infection Rate by Countries 
Select Location, Population, MAX(total_cases) as infection_count,  Max((total_cases/population))*100 as percentage_population_infected
From EllaniDB..CovidDeaths
Group by Location, population
order by percentage_population_infected desc

--Death vs population by countries 
Select Location, MAX(total_deaths) as total_deaths, population
From EllaniDB..CovidDeaths 
Group By Location, population

--Total Death by Continent 
Select continent, MAX(Total_deaths) as total_death
From EllaniDB..CovidDeaths
Where continent is not null
Group by continent
order by total_death desc
--Total Death by Continent 
Select continent, MAX(Total_deaths) as total_death
From EllaniDB..CovidDeaths
Where continent is not null
Group by continent
order by total_death desc




--Cases globally 
--I used ‘cast’ for new_deaths because the column is a string so I need to convert it to integers in order to get the sum or aggregation. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From EllaniDB..CovidDeaths
where continent is not null
--Population vs Vaccinations
Select D.continent, D.location, D.date, D.population, V.new_vaccinations 
From EllaniDB..CovidDeaths D 
Join EllaniDB..CovidVaccinations V on D.location = V.location

--Query below, I applied Over Clause to specified column that needed to be aggregated while Partition By allows  aggregated columns with each record in the specified table. It turns the original row level unlike Group By clause where it provides summary data based on one or more groups. 
Select D.continent, D.location, D.date, D.population, V.new_vaccinations,
Sum(Convert(int,V.new_vaccinations)) OVER (Partition by D.Location Order by D.location, D.Date) as VacciantedCount
From EllaniDB..CovidDeaths D 
Join EllaniDB..CovidVaccinations V
	on D.location = V.location 
	and D.date = V.date
where D.continent is not null
