use sample_data;

-- SALES WHERE AMOUNTS ARE > 2,000 AND BOXES ARE <100

SELECT *
FROM sample_data.sales
WHERE Amount > 2000
AND Boxes < 100;

-- HOW MANY SALES  DID EACH SALES PERSONS DID IN JANUARY 2022

SELECT SUM(s.Amount) AS TotalAmount, p.Salesperson
FROM sales s
	right join people p 
    on s.SPID = p.SPID
WHERE YEAR(s.SaleDate) = 2022 
AND MONTH(s.Saledate) = 01
GROUP BY p.Salesperson ;

-- WHICH PRODUCT SOLD MORE BOXES

SELECT SUM(s.Boxes) AS TotalBoxes, p.Product
FROM sales s
	inner join products p 
    ON s.PID = p.PID
GROUP BY p.Product 
ORDER BY SUM(s.Boxes) desc;

-- WHICH PRODUCT SOLD MORE BOXES IN THE FIRST 7 DAYS OF FEBRUARY 2022

SELECT SUM(s.Boxes) AS TotalBoxes, p.Product
FROM sales s 
	RIGHT JOIN products p
    ON s.PID = p.PID
WHERE YEAR(s.SaleDate) = 2022
AND MONTH(s.SaleDate) = 02
AND day(s.SaleDate) BETWEEN 01 AND 07
GROUP BY p.Product
ORDER BY SUM(s.Boxes) desc;

-- WHICH SALE HAS < 100 CUSTOMERS AND < 100 BOXES. DID ANY OF THEM OCCUR ON WEDNESDAY

SELECT *,
	CASE WHEN Customers < 100
		AND Boxes < 100 
        AND weekday(SaleDate) = 2
        THEN 'OK'
        ELSE 'NOT OK'
        END AS 'RESULTS'
FROM sales ;









