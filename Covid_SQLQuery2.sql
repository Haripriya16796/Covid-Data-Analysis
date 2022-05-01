
select * from PortfolioProject..CovidDeaths
order by 5,6

--select * from PortfolioProject..CovidVaccination
--order by 5,6

select Location, date, total_cases, new_cases, total_deaths, population 
From PortfolioProject..CovidDeaths
order by 1,2
--Total cases vs Total Deaths

--Likelihood of Death for the Covid Positive in India 
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like'%ndia%'
order by 1,2

-- What percentage of the population was Covid Positive
select Location, date, total_cases, total_cases,Population, (total_cases/population)*100 as CovidPositivePercentage
From PortfolioProject..CovidDeaths
where location like'%ndia%'

order by 1,2

--Country wise highest infected
select Location, Population, Max(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as CovidPositivePercentage 
from PortfolioProject..CovidDeaths
where continent is not null
group by Location, Population
order by CovidPositivePercentage desc

--Countries with the highest death cout per population
select Location,max(cast(total_deaths as int)) as TotalDeatCount
From PortfolioProject..CovidDeaths
--where location like'%ndia%'
where continent is not null
group by Location,Population
order by TotalDeatCount desc

--Studiying at Continent level

--Cntinent level deat cunt
select continent,max(cast(total_deaths as int)) as TotalDeatCount
From PortfolioProject..CovidDeaths
--where location like'%ndia%'
where continent is not null and location not like '%income%'
group by continent
order by TotalDeatCount desc

--GLOBAL NUMBERS
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like'%ndia%'
where continent is not null
--group by date
order by 1,2

--COVID VACCINATION DATASET

select * from PortfolioProject..CovidVaccination

--Total Population versus Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Temp Table

drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Loation nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(numeric,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated;


--Creating View to store data for vizualization

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(numeric,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from PercentPopulationVaccinated 





