# Covid_Deaths_Data
# 🦠 COVID-19 Global Impact Analysis

## 📊 Overview

This project analyzes the global impact of COVID-19 using SQL for data exploration and Tableau for interactive visualizations. The data is sourced from [Our World in Data](https://ourworldindata.org/covid-deaths) and includes global figures on cases, deaths, population, and vaccinations. The project highlights infection rates, death percentages, and vaccination rollouts, enabling insight into how different regions were affected.

---

## 🛠️ Tools & Technologies

- **SQL (T-SQL in Microsoft SQL Server)** – data extraction, joins, CTEs, and temp tables  
- **Tableau** – visualization dashboard  
- **Our World in Data** – COVID-19 dataset

---

## 🔍 Key Analysis Queries & Insights

### 1. **Total Cases vs Total Deaths**
- Computed death percentage by country and date
- ✅ *Insight:* Countries like the U.S. and India had high total cases, but smaller death percentages relative to other nations.

### 2. **Total Cases vs Population**
- Measured infection rate per country
- ✅ *Insight:* Some smaller nations had high infection percentages (e.g., Gibraltar, Andorra), even if total case counts were lower.

### 3. **Highest Infection & Death Rates**
- Identified countries with the highest:
  - Total infections
  - Infection % relative to population
  - Death% relative to population
- ✅ *Insight:* Countries in Europe and South America had higher death rates; densely populated countries showed broader spread.

### 4. **Continent-level Death Totals**
- Aggregated total deaths by continent
- ✅ *Insight:* Europe and North America had the highest overall death counts.

### 5. **Global Trends Over Time**
- Tracked new cases, deaths, and calculated daily death percentages
- ✅ *Insight:* Peak death rates often lagged behind spikes in new cases, confirming expected epidemiological trends.

### 6. **Vaccination Rollout**
- Joined vaccination and death datasets
- Calculated rolling totals of people vaccinated
- ✅ *Insight:* Vaccination coverage varied greatly, with some countries nearing 100% population coverage while others remained below 10%.

---

## 📈 Tableau Dashboard Visuals - https://public.tableau.com/app/profile/sanika.keshav.shinde8472/viz/CovidDashboard_17463728376340/CovidDashboard

- **KPI Cards:** Total new cases, total new deaths, global death percentage  
- **Map:** Deaths by continent  
- **Bar Chart:** % population infected per country  
- **Line Chart with Forecast:** Infection percentage trends and projections  

