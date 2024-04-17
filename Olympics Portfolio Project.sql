SELECT *
FROM PortfolioProject.dbo.OlympicEvent

-- EVENTS IN WHICH INDIA HAS WON MEDALS

SELECT Event, count(Medal) as NumOfMedals
FROM PortfolioProject.dbo.OlympicEvent
WHERE Team = 'India'
AND Medal <> 'NA'
GROUP BY Event
ORDER BY COUNT(Medal) desc

--EVENT PLAYED CONSECUTIVELY IN SUMMER OLYMPICS

SELECT Event, count(Event) AS TotalEvents
FROM PortfolioProject.dbo.OlympicEvent
WHERE Season = 'Summer'
GROUP BY Event

--COUNTRIES WHICH WON MOST NUMBER OF SILVER AND BRONZE MEDALS AND LEAST GOLD MEDALS

SELECT team, SUM(Silver)AS Silver, 
			SUM(Bronze)AS Bronze,
			SUM(Gold) AS Gold
FROM(
	SELECT *,
			CASE Medal WHEN 'Silver' THEN 1 ELSE 0 END AS Silver,
			CASE Medal WHEN 'Bronze' THEN 1 ELSE 0 END AS Bronze,
			CASE Medal WHEN 'Gold' THEN 1 ELSE 0 END AS Gold
	FROM PortfolioProject.dbo.OlympicEvent
	) innerT
GROUP BY Team
HAVING SUM(Gold) > 0
ORDER BY SUM(Silver) desc;

--WHICH PLAYER HAS WON MAXIMUM GOLD MEALS

SELECT Name, SUM(Gold) AS TotalGold
FROM (
	SELECT *,
		CASE Medal WHEN 'Gold' THEN 1 ELSE 0 END AS Gold
	FROM PortfolioProject.dbo.OlympicEvent
	) innerT
GROUP BY Name
ORDER BY SUM(Gold) desc;

--WHICH SPORT HAS MAXIMUM EVENTS 

SELECT Sport, COUNT(*)
FROM PortfolioProject.dbo.OlympicEvent
GROUP BY Sport
ORDER BY COUNT(*) desc

--WHICH YEAR HAS MAXIMUM EVENTS

SELECT Year ,COUNT(Event) AS TotalEvent
FROM PortfolioProject.dbo.OlympicEvent
GROUP BY Year
ORDER BY COUNT(Event) desc