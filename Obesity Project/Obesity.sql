SELECT * FROM ObesityFinal..NumberDeaths

ALTER TABLE ObesityFinal..NumberDeaths
ALTER COLUMN Year float

--Removing Unneccessary records

SELECT DISTINCT Country
FROM ObesityFinal..NumberDeaths
WHERE  Country LIKE '%(%' OR
		Country LIKE '%High-income%' OR
		Country LIKE '%Lower-middle-income%' OR
		Country LIKE '%upper-middle-income%' OR
		Country LIKE '%Low-income%' OR
		Country ='Eastern Mediterranean' OR
		Country ='Americas' OR
		Country ='South-east Asia' OR
		Country='South Africa' OR
		Country='Western Pacific'

DELETE ObesityFinal..NumberDeaths
WHERE Country LIKE '%(%' OR
		Country LIKE '%High-income%' OR
		Country LIKE '%Lower-middle-income%' OR
		Country LIKE '%upper-middle-income%' OR
		Country LIKE '%Low-income%' OR
		Country ='Eastern Mediterranean' OR
		Country ='Americas' OR
		Country ='South-east Asia' OR
		Country='South Africa' OR
		Country='Western Pacific' OR
		Country IN('OECD Countries','G20')

----Creating a new table for Countries categorized into income status and the deaths caused by each factor per year. 
SELECT * INTO ObesityFinal..WorldIncomeDeaths 
FROM ObesityFinal..NumberDeaths
WHERE COUNTRY IN('World Bank Upper Middle Income','World Bank Lower Middle Income','World Bank Low Income','World Bank High Income')

DELETE ObesityFinal..NumberDeaths
WHERE COUNTRY IN('World Bank Upper Middle Income','World Bank Lower Middle Income','World Bank Low Income','World Bank High Income')


--Total # of Deaths(Of all risk factors) in Canada and US and World in 2006 and 2016.

SELECT Country, SUM([Risk: High systolic blood pressure]+ [Risk: Diet high in sodium]+ [Risk: Diet low in whole grains]+ [Risk: Alcohol use]+ [Risk: Diet low in fruits]+ [Risk: Unsafe water source]+ [Risk: Secondhand smoke]+ [Risk: Low birth weight]+ [Risk: Child wasting]+ [Risk: Unsafe sex]+ [Risk: Diet low in nuts and seeds]+ [Risk: Household air pollution from solid fuels]+ [Risk: Diet low in vegetables]+ [Risk: Low physical activity]+ [Risk: Smoking]+ [Risk: High fasting plasma glucose]+ [Risk: Air pollution]+ [Risk: High body-mass index]+ [Risk: Unsafe sanitation]+ [Risk: No access to handwashing facility]+ [Risk: Drug use]+ [Risk: Low bone mineral density]+ [Risk: Vitamin A deficiency]+ [Risk: Child stunting]+ [Risk: Non-exclusive breastfeeding]+ [Risk: Iron deficiency]+ [Risk: Ambient particulate matter pollution]) AS Total_Deaths
FROM ObesityFinal..NumberDeaths
WHERE Country IN ('Canada', 'United States') AND Year IN(2006, 2016)
GROUP BY Country

--Total # deaths in world due to all risk factors 
SELECT SUM([Risk: High systolic blood pressure]+ [Risk: Diet high in sodium]+ [Risk: Diet low in whole grains]+ [Risk: Alcohol use]+ [Risk: Diet low in fruits]+ [Risk: Unsafe water source]+ [Risk: Secondhand smoke]+ [Risk: Low birth weight]+ [Risk: Child wasting]+ [Risk: Unsafe sex]+ [Risk: Diet low in nuts and seeds]+ [Risk: Household air pollution from solid fuels]+ [Risk: Diet low in vegetables]+ [Risk: Low physical activity]+ [Risk: Smoking]+ [Risk: High fasting plasma glucose]+ [Risk: Air pollution]+ [Risk: High body-mass index]+ [Risk: Unsafe sanitation]+ [Risk: No access to handwashing facility]+ [Risk: Drug use]+ [Risk: Low bone mineral density]+ [Risk: Vitamin A deficiency]+ [Risk: Child stunting]+ [Risk: Non-exclusive breastfeeding]+ [Risk: Iron deficiency]+ [Risk: Ambient particulate matter pollution]) AS World_Total_Deaths
FROM ObesityFinal..NumberDeaths
WHERE Year IN (2006,2016)


--Total Deaths caused by Obesity in Canada, US and World in 2006 and 2016.


SELECT Country, SUM([Risk: High body-mass index]) AS Total_Deaths_Obesity
FROM ObesityFinal..NumberDeaths
WHERE Country IN ('Canada', 'United States') AND Year IN (2006,2016)
GROUP BY Country

--Total # deaths in world due to Obesity  
SELECT Year, SUM([Risk: High body-mass index]) AS World_Total_Deaths_Obesity
FROM ObesityFinal..NumberDeaths
WHERE Year IN (2006,2016)
GROUP BY Year

-- Total # of deaths(all risk factors) in Low-income, lower-middle income, high-middle income, and high income countries  in 2006 and 2016 
SELECT Country,Year, SUM([Risk: High systolic blood pressure]+ [Risk: Diet high in sodium]+ [Risk: Diet low in whole grains]+ [Risk: Alcohol use]+ [Risk: Diet low in fruits]+ [Risk: Unsafe water source]+ [Risk: Secondhand smoke]+ [Risk: Low birth weight]+ [Risk: Child wasting]+ [Risk: Unsafe sex]+ [Risk: Diet low in nuts and seeds]+ [Risk: Household air pollution from solid fuels]+ [Risk: Diet low in vegetables]+ [Risk: Low physical activity]+ [Risk: Smoking]+ [Risk: High fasting plasma glucose]+ [Risk: Air pollution]+ [Risk: High body-mass index]+ [Risk: Unsafe sanitation]+ [Risk: No access to handwashing facility]+ [Risk: Drug use]+ [Risk: Low bone mineral density]+ [Risk: Vitamin A deficiency]+ [Risk: Child stunting]+ [Risk: Non-exclusive breastfeeding]+ [Risk: Iron deficiency]+ [Risk: Ambient particulate matter pollution]) AS Total_Deaths
FROM ObesityFinal..WorldIncomeDeaths
WHERE COUNTRY IN('World Bank Upper Middle Income','World Bank Lower Middle Income','World Bank Low Income','World Bank High Income') AND YEAR IN (2006,2016)
GROUP BY Country, Year
ORDER BY Total_Deaths DESC

-- Total # of deaths(obesity) in Low-income, lower-middle income, high-middle income, and high income countries  in 2006 and 2016
SELECT Country,Year, SUM([Risk: High body-mass index]) AS Total_Deaths_Obesity
FROM ObesityFinal..WorldIncomeDeaths
WHERE COUNTRY IN('World Bank Upper Middle Income','World Bank Lower Middle Income','World Bank Low Income','World Bank High Income') AND YEAR IN (2006,2016)
GROUP BY Country, Year
ORDER BY Total_Deaths_Obesity DE																																			SC

-- % of death attributed to Obesity in 2006 and 2016 for Canada and US 

WITH ObesityDeathPCT_table AS 
(
SELECT Country, Year, SUM([Risk: High body-mass index]) AS Total_Deaths_Obesity, SUM([Risk: High systolic blood pressure]+ [Risk: Diet high in sodium]+ [Risk: Diet low in whole grains]+ [Risk: Alcohol use]+ [Risk: Diet low in fruits]+ [Risk: Unsafe water source]+ [Risk: Secondhand smoke]+ [Risk: Low birth weight]+ [Risk: Child wasting]+ [Risk: Unsafe sex]+ [Risk: Diet low in nuts and seeds]+ [Risk: Household air pollution from solid fuels]+ [Risk: Diet low in vegetables]+ [Risk: Low physical activity]+ [Risk: Smoking]+ [Risk: High fasting plasma glucose]+ [Risk: Air pollution]+ [Risk: High body-mass index]+ [Risk: Unsafe sanitation]+ [Risk: No access to handwashing facility]+ [Risk: Drug use]+ [Risk: Low bone mineral density]+ [Risk: Vitamin A deficiency]+ [Risk: Child stunting]+ [Risk: Non-exclusive breastfeeding]+ [Risk: Iron deficiency]+ [Risk: Ambient particulate matter pollution]) AS World_Total_Deaths
FROM ObesityFinal..NumberDeaths
WHERE Country IN ('Canada', 'United States') AND Year IN (2006,2016)
GROUP BY Country,Year
)
SELECT Country,Year, ROUND(Total_Deaths_Obesity/World_Total_Deaths*100,2) AS ObesityDeathPCT
FROM ObesityDeathPCT_table
ORDER BY Country 

-- % of death attributed to Obesity in 2006 and 2016 for World

SELECT Year, ROUND(SUM([Risk: High body-mass index])/SUM([Risk: High systolic blood pressure]+ [Risk: Diet high in sodium]+ [Risk: Diet low in whole grains]+ [Risk: Alcohol use]+ [Risk: Diet low in fruits]+ [Risk: Unsafe water source]+ [Risk: Secondhand smoke]+ [Risk: Low birth weight]+ [Risk: Child wasting]+ [Risk: Unsafe sex]+ [Risk: Diet low in nuts and seeds]+ [Risk: Household air pollution from solid fuels]+ [Risk: Diet low in vegetables]+ [Risk: Low physical activity]+ [Risk: Smoking]+ [Risk: High fasting plasma glucose]+ [Risk: Air pollution]+ [Risk: High body-mass index]+ [Risk: Unsafe sanitation]+ [Risk: No access to handwashing facility]+ [Risk: Drug use]+ [Risk: Low bone mineral density]+ [Risk: Vitamin A deficiency]+ [Risk: Child stunting]+ [Risk: Non-exclusive breastfeeding]+ [Risk: Iron deficiency]+ [Risk: Ambient particulate matter pollution])*100,2) AS WorldObesityDeathPCT
FROM ObesityFinal..NumberDeaths
WHERE Year IN (2006,2016)
GROUP BY Year

--% of death attributed to Obesity in 2006 and 2016 for Low-income, lower-middle income, high-middle income, and high income regions

SELECT Country, Year, ROUND(SUM([Risk: High body-mass index])/SUM([Risk: High systolic blood pressure]+ [Risk: Diet high in sodium]+ [Risk: Diet low in whole grains]+ [Risk: Alcohol use]+ [Risk: Diet low in fruits]+ [Risk: Unsafe water source]+ [Risk: Secondhand smoke]+ [Risk: Low birth weight]+ [Risk: Child wasting]+ [Risk: Unsafe sex]+ [Risk: Diet low in nuts and seeds]+ [Risk: Household air pollution from solid fuels]+ [Risk: Diet low in vegetables]+ [Risk: Low physical activity]+ [Risk: Smoking]+ [Risk: High fasting plasma glucose]+ [Risk: Air pollution]+ [Risk: High body-mass index]+ [Risk: Unsafe sanitation]+ [Risk: No access to handwashing facility]+ [Risk: Drug use]+ [Risk: Low bone mineral density]+ [Risk: Vitamin A deficiency]+ [Risk: Child stunting]+ [Risk: Non-exclusive breastfeeding]+ [Risk: Iron deficiency]+ [Risk: Ambient particulate matter pollution])*100,2) AS WorldObesityDeathPCT
FROM ObesityFinal..WorldIncomeDeaths
WHERE Year IN (2006,2016)
GROUP BY Country, Year
ORDER BY WorldObesityDeathPCT, Country 

--% of deaths attributed to Obesity in 2006 and 2016  for all Low-income, lower-middle income, high-middle income, and high income regions combined
SELECT Year, ROUND(SUM([Risk: High body-mass index])/SUM([Risk: High systolic blood pressure]+ [Risk: Diet high in sodium]+ [Risk: Diet low in whole grains]+ [Risk: Alcohol use]+ [Risk: Diet low in fruits]+ [Risk: Unsafe water source]+ [Risk: Secondhand smoke]+ [Risk: Low birth weight]+ [Risk: Child wasting]+ [Risk: Unsafe sex]+ [Risk: Diet low in nuts and seeds]+ [Risk: Household air pollution from solid fuels]+ [Risk: Diet low in vegetables]+ [Risk: Low physical activity]+ [Risk: Smoking]+ [Risk: High fasting plasma glucose]+ [Risk: Air pollution]+ [Risk: High body-mass index]+ [Risk: Unsafe sanitation]+ [Risk: No access to handwashing facility]+ [Risk: Drug use]+ [Risk: Low bone mineral density]+ [Risk: Vitamin A deficiency]+ [Risk: Child stunting]+ [Risk: Non-exclusive breastfeeding]+ [Risk: Iron deficiency]+ [Risk: Ambient particulate matter pollution])*100,2) AS TotalWorldDeathPCT
FROM ObesityFinal..WorldIncomeDeaths
WHERE Year IN (2006,2016)
GROUP BY Year

 
--Removing Unnecessary Columns from Prevalence of Adult Obesity Table

SELECT * FROM ObesityFinal..Prevalence_of_AdultObesity
WHERE Country IN('Asia','Africa', 'North America', 'South America','Antarctica','Europe', 'High-income countries','Europe (UN)','European Union (27)','Latin America and the Caribbean (UN)','Asia (UN)','Oceania (UN)','Low-income countries','Lower-middle-income countries','Upper-middle-income countries','Northern America (UN)','World')

DELETE ObesityFinal..Prevalence_of_AdultObesity
WHERE Country IN('Asia','Africa', 'North America', 'South America','Antarctica','Europe', 'High-income countries','Europe (UN)','European Union (27)','Latin America and the Caribbean (UN)','Asia (UN)','Oceania (UN)','Low-income countries','Lower-middle-income countries','Upper-middle-income countries','Northern America (UN)','World')

----Creating a new table for Countries categorized into income status and obesity prevelance per year before removing these categories.

SELECT * INTO ObesityFinal..Prevalene_of_AdultObesity_Income FROM ObesityFinal..Prevalence_of_AdultObesity
WHERE Country IN ('Upper-middle-income','Lower-middle-income','Low-income','High-income') 

SELECT * FROM ObesityFinal..Prevalene_of_AdultObesity_Income

SELECT*FROM  ObesityFinal..Prevalence_of_AdultObesity
WHERE Country LIKE '%(%' OR
		Country LIKE '%High-income%' OR
		Country LIKE '%Lower-middle-income%' OR
		Country LIKE '%upper-middle-income%' OR
		Country LIKE '%Low-income%' OR
		Country ='Eastern Mediterranean' OR
		Country ='Americas' OR
		Country ='South-east Asia' OR
		Country='South Africa' OR
		Country='Western Pacific'

DELETE ObesityFinal..Prevalence_of_AdultObesity	
WHERE Country LIKE '%(%' OR
		Country LIKE '%High-income%' OR
		Country LIKE '%Lower-middle-income%' OR
		Country LIKE '%upper-middle-income%' OR
		Country LIKE '%Low-income%' OR
		Country ='Eastern Mediterranean' OR
		Country ='Americas' OR
		Country ='South-east Asia' OR
		Country='South Africa' OR
		Country='Western Pacific'

SELECT DISTINCT Country FROM ObesityFinal..Prevalence_of_AdultObesity

-- Top 10 most obese and least obese countries based on prevalence of adult obesity in 2006 and 2016.

--Top 10 in 2006
SELECT TOP 10 Country, [Obesity Prevelance % (Adults)]
FROM ObesityFinal..Prevalence_of_AdultObesity
WHERE YEAR = 2006
ORDER BY [Obesity Prevelance % (Adults)] DESC 

SELECT TOP 10 Country, [Obesity Prevelance % (Adults)]
FROM ObesityFinal..Prevalence_of_AdultObesity
WHERE YEAR = 2016
ORDER BY [Obesity Prevelance % (Adults)] DESC 

--Bottom 10 in 2016
SELECT TOP 10 Country, [Obesity Prevelance % (Adults)]
FROM ObesityFinal..Prevalence_of_AdultObesity
WHERE YEAR = 2006
ORDER BY [Obesity Prevelance % (Adults)] ASC 


SELECT TOP 10 Country, [Obesity Prevelance % (Adults)]
FROM ObesityFinal..Prevalence_of_AdultObesity
WHERE YEAR = 2016
ORDER BY [Obesity Prevelance % (Adults)] ASC 

---IncomeStatus Regions in 2006 and 2016
SELECT Country,Year, [Obesity Prevelance % (Adults)]
FROM ObesityFinal..Prevalene_of_AdultObesity_Income 
WHERE YEAR IN(2006,2016)
ORDER BY country,[Obesity Prevelance % (Adults)] ASC 


--Clean Obesity vs GDP Table

SELECT*FROM ObesityFinal..Obesity_VS_GDP
WHERE Country IN('Asia','Africa', 'North America', 'South America','Antarctica','Europe', 'High-income countries','Europe (UN)','European Union (27)','Latin America and the Caribbean (UN)','Asia (UN)','Oceania (UN)','Low-income countries','Lower-middle-income countries','Upper-middle-income countries','Northern America (UN)','World')

DELETE ObesityFinal..Obesity_VS_GDP
WHERE Country IN('Asia','Africa', 'North America', 'South America','Antarctica','Europe', 'High-income countries','Europe (UN)','European Union (27)','Latin America and the Caribbean (UN)','Asia (UN)','Oceania (UN)','Low-income countries','Lower-middle-income countries','Upper-middle-income countries','Northern America (UN)','World')

ALTER TABLE obesityFinal..Obesity_VS_GDP
DROP COLUMN Continent

UPDATE ObesityFinal..Obesity_VS_GDP
SET [GDP per capita] = 0
WHERE [GDP per capita] is null

ALTER TABLE obesityFinal..Obesity_VS_GDP
ALTER COLUMN [GDP per capita] float

----Creating a new table for Countries categorized into income status and GDPvObesity per year before removing these categories.

SELECT * INTO ObesityFinal..WorldIncomeVsGDP FROM ObesityFinal..Obesity_VS_GDP
WHERE Country IN ('High-income countries','Lower-middle-income countries','Upper-middle-income countries','Low-income countries')

SELECT * FROM ObesityFinal..WorldIncomeVsGDP



SELECT * FROM obesityFinal..Obesity_VS_GDP
WHERE  Country LIKE '%(%' OR
		Country LIKE '%High-income%' OR
		Country LIKE '%Lower-middle-income%' OR
		Country LIKE '%upper-middle-income%' OR
		Country LIKE '%Low-income%' OR
		Country ='Eastern Mediterranean' OR
		Country ='Americas' OR
		Country ='South-east Asia' OR
		Country='South Africa' OR
		Country='Western Pacific'
DELETE ObesityFinal..Obesity_VS_GDP
WHERE  Country LIKE '%(%' OR
		Country LIKE '%High-income%' OR
		Country LIKE '%Lower-middle-income%' OR
		Country LIKE '%upper-middle-income%' OR
		Country LIKE '%Low-income%' OR
		Country ='Eastern Mediterranean' OR
		Country ='Americas' OR
		Country ='South-east Asia' OR
		Country='South Africa' OR
		Country='Western Pacific'

---Top 10 most obese countries based on GDP in 2006 and 2016


SELECT TOP 10 PO.Country, PO.Year, PO.[Obesity Prevelance % (Adults)], OG.[GDP per capita] FROM ObesityFinal..Obesity_VS_GDP OG
JOIN ObesityFinal..Prevalence_of_AdultObesity PO
ON PO.Country = OG.Country AND PO.Year = OG.Year
WHERE [GDP per capita] <> 0 AND PO.YEAR = 2006
ORDER BY [GDP per capita] DESC, [Obesity Prevelance % (Adults)] DESC   
 
SELECT TOP 10 PO.Country, PO.Year, PO.[Obesity Prevelance % (Adults)], OG.[GDP per capita] FROM ObesityFinal..Obesity_VS_GDP OG
JOIN ObesityFinal..Prevalence_of_AdultObesity PO
ON PO.Country = OG.Country AND PO.Year = OG.Year
WHERE [GDP per capita] <> 0 AND PO.YEAR = 2016
ORDER BY [GDP per capita] DESC, [Obesity Prevelance % (Adults)] DESC   


--- Bottom 10 Countries based on lowest GDP in 2006 and 2016 

SELECT TOP 10 PO.Country, PO.Year, PO.[Obesity Prevelance % (Adults)], OG.[GDP per capita] FROM ObesityFinal..Obesity_VS_GDP OG
JOIN ObesityFinal..Prevalence_of_AdultObesity PO
ON PO.Country = OG.Country AND PO.Year = OG.Year
WHERE [GDP per capita] <> 0 AND PO.YEAR = 2006
ORDER BY [GDP per capita] ASC, [Obesity Prevelance % (Adults)] ASC   

SELECT TOP 10 PO.Country, PO.Year, PO.[Obesity Prevelance % (Adults)], OG.[GDP per capita] FROM ObesityFinal..Obesity_VS_GDP OG
JOIN ObesityFinal..Prevalence_of_AdultObesity PO
ON PO.Country = OG.Country AND PO.Year = OG.Year
WHERE [GDP per capita] <> 0 AND PO.YEAR = 2016
ORDER BY [GDP per capita] ASC, [Obesity Prevelance % (Adults)] ASC   

---IncomeStatus Regions in 2006 and 2016
-- Updating of values in column country before joining and finding top/bottom 10 regions.
SELECT*
FROM ObesityFinal..WorldIncomeVsGDP 

SELECT *
FROM ObesityFinal..Prevalene_of_AdultObesity_Income


UPDATE ObesityFinal..WorldIncomeVsGDP
SET Country = 'Low-income'
WHERE Country ='Low-income countries'

UPDATE ObesityFinal..WorldIncomeVsGDP
SET Country = 'Lower-middle-income'
WHERE Country ='Lower-middle-income countries'

UPDATE ObesityFinal..WorldIncomeVsGDP
SET Country = 'Upper-middle-income'
WHERE Country ='Upper-middle-income countries'

UPDATE ObesityFinal..WorldIncomeVsGDP
SET Country = 'High-income'
WHERE Country ='High-income countries'

SELECT WG.Country, WG.Year, PI.[Obesity Prevelance % (Adults)], WG.[GDP per capita]
FROM ObesityFinal..WorldIncomeVsGDP WG
JOIN ObesityFinal..Prevalene_of_AdultObesity_Income PI
ON WG.Country = PI.Country AND WG.year =PI.Year
WHERE WG.YEAR IN (2006,2016)



-- Trend between prevalence and deaths (obesity)

SELECT PO.Country, PO.Year, PO.[Obesity Prevelance % (Adults)], ND.[Risk: High body-mass index] AS ObesityDeaths FROM ObesityFinal..Prevalence_of_AdultObesity PO
JOIN ObesityFinal..NumberDeaths ND
ON PO.Country = ND.Country AND PO.Year=ND.Year
WHERE PO.Year IN (2006, 2016)


-----Table for Total # Deaths across all risk factors for the Year 2016
SELECT * INTO ObesityFinal..Deaths2016
FROM ObesityFinal..NumberDeaths

SELECT * 
FROM ObesityFinal..Deaths2016

DELETE ObesityFinal..Deaths2016
WHERE Year <> 2016 