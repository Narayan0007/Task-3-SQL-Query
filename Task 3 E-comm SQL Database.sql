USE df;
SELECT * FROM ecom_data;
-- Selecting top 5 rows
Select * from ecom_data Limit 5;

-- selecting req column
SELECT CustomerName, City, Amount 
FROM ecom_data;
-- Total Sales by Category
Select 
    Category, 
    SUM(Amount) as TotalSales
From ecom_data
Group by Category;
-- Average Profit by State
Select 
    State, 
    AVG(Profit) as AverageProfit
From ecom_data
Group by State;
-- Total Quantity Sold by Sub-Category
Select 
    `Sub-Category`, 
    SUM(Quantity) as TotalQuantity
From ecom_data
Group by `Sub-Category`;

-- Customers in Gujarat with orders above ₹1,000
Select CustomerName, City, Amount 
From ecom_data 
Where State = 'Gujarat' AND Amount > 1000 
order by Amount desc;

-- Total Sales and Profit by City
Select 
    City, 
    SUM(Amount) as TotalSales, 
    SUM(Profit) as TotalProfit
From ecom_data
Group by City;

-- Number of Orders by Customer
Select 
    CustomerName, 
    COUNT(DISTINCT `Order ID`) AS NumberOfOrders
From ecom_data
Group by CustomerName;

-- Monthly Sales Trend
Select 
    DATE_FORMAT(`Order Date`, '%Y-%m') AS Month, 
    SUM(Amount) AS TotalSales
from ecom_data
Group by month
order by month;

-- Average Quantity by Category and Sub-Category
Select 
    Category, 
    `Sub-Category`, 
    AVG(Quantity) as AverageQuantity
From ecom_data
Group by Category, `Sub-Category`;

-- Total Profit by State and Category
Select 
    State, 
    Category, 
    SUM(Profit) as TotalProfit
From ecom_data
Group by State, Category;

-- Customers with Multiple Orders
Select 
    CustomerName, 
    COUNT(DISTINCT `Order ID`) AS NumberOfOrders
From ecom_data
Group by CustomerName
Having COUNT(DISTINCT `Order ID`) > 1;

-- Total Sales for Each Day of the Week
Select 
    DAYNAME(`Order Date`) as DayOfWeek, 
    SUM(Amount) as TotalSales
From ecom_data
Group by DayOfWeek;

-- Joins
-- Orders with Furniture and Electronics
Select DISTINCT
    e1.`Order ID`
From
    ecom_data e1
Join
    ecom_data e2 ON e1.`Order ID` = e2.`Order ID`
Where
    e1.Category = 'Furniture' AND e2.Category = 'Electronics';
    
-- Customers Who Ordered Multiple Categories
Select DISTINCT
    e1.CustomerName
from
    ecom_data e1
Join
    ecom_data e2 on e1.CustomerName = e2.CustomerName and e1.Category != e2.Category;
-- subqueries
-- Customers with Above-Average Order Amounts
Select
    CustomerName,
    AVG(Amount) as AverageOrderAmount
From
    ecom_data
Group by
    CustomerName
Having
    AVG(Amount) > (Select AVG(Amount) from ecom_data);
    
-- States with Total Sales Greater Than Average
Select
    State,
    SUM(Amount) AS TotalSales
From
    ecom_data
Group by
    State
Having
    SUM(Amount) > (Select AVG(TotalSales) From (SELECT State, 
    SUM(Amount) as TotalSales From ecom_data Group by State) as StateSales);
    
-- views for analysis
-- Category Sales View
Create View CategorySales as
Select 
    Category,
    SUM(Amount) as TotalSales,
    SUM(Profit) as TotalProfit
From
    ecom_data
Group by
    Category;
Select * from CategorySales;

-- State-wise Sales Performance View
Create View StateSalesPerformance AS
Select 
    State,
    SUM(Amount) as TotalSales,
    SUM(Profit) as TotalProfit
From
    ecom_data
Group by
    State;

Select * from StateSalesPerformance;

-- Optimize queries with indexes
CREATE INDEX idx_customer_name ON ecom_data (CustomerName(255));
CREATE INDEX idx_state ON ecom_data (State(255));
CREATE INDEX idx_city ON ecom_data (City(255));
CREATE INDEX idx_category ON ecom_data (Category(255));
CREATE INDEX idx_subcategory ON ecom_data (`Sub-Category`(255));

-- Analyze query performance
Explain Select * From ecom_data WHERE CustomerName = 'Bharat';

-- Query using CustomerName index
SELECT * FROM ecom_data WHERE CustomerName = 'Bharat';

-- Query using State index
SELECT * FROM ecom_data WHERE State = 'Gujarat';

-- Query using Category index
SELECT * FROM ecom_data WHERE Category = 'Furniture';

-- Query using OrderDate index
SELECT * FROM ecom_data WHERE `Order Date` BETWEEN '2018-01-01' AND '2018-01-31';

















