SET datestyle = 'ISO, DMY';

CREATE TABLE cc_detail (
    Client_Num INT,
    Card_Category VARCHAR(20),
    Annual_Fees INT,
    Activation_30_Days INT,
    Customer_Acq_Cost INT,
    Week_Start_Date DATE,
    Week_Num VARCHAR(20),
    Qtr VARCHAR(10),
    current_year INT,
    Credit_Limit DECIMAL(10,2),
    Total_Revolving_Bal INT,
    Total_Trans_Amt INT,
    Total_Trans_Ct INT,
    Avg_Utilization_Ratio DECIMAL(10,3),
    Use_Chip VARCHAR(10),
    Exp_Type VARCHAR(50),
    Interest_Earned DECIMAL(10,3),
    Delinquent_Acc VARCHAR(5)
);

SELECT * FROM cc_detail;
COPY cc_detail
FROM 'C:\csv.data\credit_card.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE cust_detail (
    Client_Num INT,
    Customer_Age INT,
    Gender VARCHAR(5),
    Dependent_Count INT,
    Education_Level VARCHAR(50),
    Marital_Status VARCHAR(20),
    State_cd VARCHAR(50),
    Zipcode VARCHAR(20),
    Car_Owner VARCHAR(5),
    House_Owner VARCHAR(5),
    Personal_Loan VARCHAR(5),
    Contact VARCHAR(50),
    Customer_Job VARCHAR(50),
    Income INT,
    Cust_Satisfaction_Score INT
);

SELECT * FROM cust_detail;

COPY cust_detail
FROM 'C:\csv.data\customer.csv'
DELIMITER ','
CSV HEADER;



-- 1. Total Customers by Card Category
SELECT Card_Category, 
COUNT(Client_Num) AS Total_Customers
FROM cc_detail
GROUP BY Card_Category
ORDER BY Total_Customers DESC;


-- 2. Total Transaction Amount by Gender
SELECT c.Gender, 
SUM(cr.Total_Trans_Amt) AS Total_Transaction_Amount
FROM cust_detail c
JOIN cc_detail cr ON c.Client_Num = cr.Client_Num
GROUP BY c.Gender
ORDER BY Total_Transaction_Amount DESC;


-- 3. Top 5 States with Most Customers
SELECT State_cd, 
COUNT(Client_Num) AS Total_Customers
FROM cust_detail
GROUP BY State_cd
ORDER BY Total_Customers DESC
LIMIT 5;

-- 4. Total Revenue by Education Level
SELECT c.Education_Level,
SUM(cr.Annual_Fees + cr.Total_Trans_Amt + cr.Interest_Earned) AS Total_Revenue
FROM cust_detail c
JOIN cc_detail cr ON c.Client_Num = cr.Client_Num
GROUP BY c.Education_Level
ORDER BY Total_Revenue DESC;

-- 5. Average Income by Card Category
SELECT cr.Card_Category, 
ROUND(AVG(c.Income), 2) AS Average_Income
FROM cc_detail cr
JOIN cust_detail c ON c.Client_Num = cr.Client_Num
GROUP BY cr.Card_Category
ORDER BY Average_Income DESC;