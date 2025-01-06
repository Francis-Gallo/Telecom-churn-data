
CREATE TABLE CustomerDemographics (
    CustomerID VARCHAR(50) PRIMARY KEY,
    Gender TINYINT, -- 1 for male, 0 for female
    SeniorCitizen TINYINT, -- 1 if senior, 0 if not
    Partner_Yes TINYINT, -- 1 if has partner, 0 if not
    Dependents_Yes TINYINT -- 1 if has dependents, 0 if not
);

select * from CustomerDemographics;

CREATE TABLE ServiceUsage (
    CustomerID VARCHAR(50),
    PhoneService_Yes TINYINT,
    MultipleLines_NoPhoneService TINYINT,
    MultipleLines_Yes TINYINT,
    InternetService_FiberOptic TINYINT,
    InternetService_No TINYINT,
    OnlineSecurity_NoInternetService TINYINT,
    OnlineSecurity_Yes TINYINT,
    OnlineBackup_NoInternetService TINYINT,
    OnlineBackup_Yes TINYINT,
    DeviceProtection_NoInternetService TINYINT,
    DeviceProtection_Yes TINYINT,
    TechSupport_NoInternetService TINYINT,
    TechSupport_Yes TINYINT,
    StreamingTV_NoInternetService TINYINT,
    StreamingTV_Yes TINYINT,
    StreamingMovies_NoInternetService TINYINT,
    StreamingMovies_Yes TINYINT,
    PRIMARY KEY (CustomerID),
    FOREIGN KEY (CustomerID) REFERENCES CustomerDemographics(CustomerID)
);

select * from ServiceUsage;

CREATE TABLE ContractInformation (
    CustomerID VARCHAR(50),
    Contract_OneYear TINYINT,
    Contract_TwoYear TINYINT,
    PaperlessBilling_Yes TINYINT,
    PaymentMethod_CreditCard TINYINT,
    PaymentMethod_ElectronicCheck TINYINT,
    PaymentMethod_MailedCheck TINYINT,
    PRIMARY KEY (CustomerID),
    FOREIGN KEY (CustomerID) REFERENCES CustomerDemographics(CustomerID)
);

select * from ContractInformation;

CREATE TABLE CentralTable (
    CustomerID VARCHAR(50),
    MonthlyCharges DECIMAL(10, 2),
    TotalCharges DECIMAL(10, 2),
    Tenure INT,
    Churn TINYINT,
    PRIMARY KEY (CustomerID),
    FOREIGN KEY (CustomerID) REFERENCES CustomerDemographics(CustomerID)
);

select * from CentralTable;

SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customer demographics.csv'
INTO TABLE CustomerDemographics
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from customerdemographics;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/contract information.csv'
INTO TABLE contractinformation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from contractinformation;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/service usage.csv'
INTO TABLE serviceusage
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from serviceusage;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/central table.csv'
INTO TABLE centraltable
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from centraltable;


#TOTAL CUSTOMERS

SELECT COUNT(CustomerID) AS TotalCustomers 
FROM CustomerDemographics;

#chrun rate 
SELECT (COUNT(*) - SUM(Churn)) / COUNT(*) * 100 AS ChurnRatePercentage
FROM centraltable;

#Total monthly revenue 
SELECT SUM(MonthlyCharges) AS TotalMonthlyRevenue 
FROM centraltable;

#Average Monthly Revenue per Customer
SELECT AVG(MonthlyCharges) AS AvgRevenuePerCustomer 
FROM centraltable;

-- Average Tenure for Retained Customers
SELECT 
    AVG(Tenure) AS AvgTenureRetained
FROM centraltable
WHERE Churn = 0;

-- Average Tenure for Churned Customers
SELECT 
    AVG(Tenure) AS AvgTenureChurned
FROM centraltable
WHERE Churn = 1;


-- Customer Lifetime Value (CLV)
SELECT 
    CustomerID,
    (MonthlyCharges * Tenure) AS CLV
FROM centraltable;

-- Profit per Customer (Assuming 50% Profit Margin)
SELECT 
    CustomerID, 
    (MonthlyCharges * 0.5) AS ProfitPerCustomer 
FROM centraltable;

-- Churn Rate by Service Type (Fiber Optic)
SELECT 
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM centraltable)) AS ChurnRateForFiberOptic
FROM centraltable f
JOIN ServiceUsage s ON f.CustomerID = s.CustomerID
WHERE s.InternetService_FiberOptic = 1 AND f.Churn = 1;


--  Churn Rate by Contract Type
SELECT 
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM centraltable)) AS ChurnRateOneYear
FROM centraltable f
JOIN ContractInformation c ON f.CustomerID = c.CustomerID
WHERE c.Contract_OneYear = 1 AND f.Churn = 1;

-- Revenue Lost Due to Churn
SELECT 
    SUM(MonthlyCharges) AS RevenueLost
FROM centraltable
WHERE Churn = 1;


-- Churn Rate by Gender
SELECT 
    Gender, 
    (SUM(Churn) / COUNT(*)) * 100 AS ChurnRateByGender
FROM CustomerDemographics d
JOIN centraltable f ON d.CustomerID = f.CustomerID
GROUP BY Gender;


SELECT * FROM centraltable;





















