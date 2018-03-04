/* Name:Desiree Noela Dias Started:10/08/2017 Finished:11/08/2017 */
/* There is a Foreign Key Missing from the Product Table, write a script to add the required FK */

ALTER TABLE Product
ADD FOREIGN KEY (SupplierID) REFERENCES Supplier(ID);

/* Create a temporary table to store every day from 2012 to 2015 (inclusive), utilise a while loop to load this table. The Table should have a Primary Key
	and an Identity specification */

CREATE TABLE #FirstTable (ID int PRIMARY KEY IDENTITY, DAY datetime)
DECLARE @date1 datetime
SET @date1 = '20120101'
DECLARE @enddate datetime
SET @enddate = '20151231'

BEGIN
WHILE @date1<=@enddate
BEGIN
INSERT INTO #FirstTable (DAY)
VALUES(@date1 )
SET @date1=@date1+1;
END

SELECT ID, TRIM(CONVERT(VARCHAR, DAY, 103)) as DAY 
FROM #FirstTable
END

DROP TABLE #FirstTable

/* What are the differences between a temporary table and a table variable */
/*1. SYNTAX:
Below is the sample example of Creating a Temporary Table, Inserting records into it, retrieving the rows from it and then finally dropping the created Temporary Table.

-- Create Temporary Table
CREATE TABLE #Customer 
(Id INT, Name VARCHAR(50))
--Insert Two records
INSERT INTO #Customer
VALUES(1,'Basavaraj') 
INSERT INTO #Customer 
VALUES(2,'Kalpana')
--Reterive the records
SELECT * FROM #Customer
--DROP Temporary Table
DROP TABLE #Customer
GO
Below is the sample example of Declaring a Table Variable, Inserting records into it and retrieving the rows from it.

-- Create Table Variable
DECLARE @Customer TABLE
(
 Id INT,
 Name VARCHAR(50)   
)
--Insert Two records
INSERT INTO @Customer 
VALUES(1,'Basavaraj') 
INSERT INTO @Customer 
VALUES(2,'Kalpana')
--Reterive the records
SELECT * FROM @Customer
GO

2. MODIFYING STRUCTURE:
Temporary Table structure can be changed after it’s creation it implies we can use DDL statements ALTER, CREATE, DROP.
Below script creates a Temporary Table #Customer, adds Address column to it and finally the Temporary Table is dropped.

--Create Temporary Table
CREATE TABLE #Customer
(Id INT, Name VARCHAR(50))
GO
--Add Address Column
ALTER TABLE #Customer 
ADD Address VARCHAR(400)
GO
--DROP Temporary Table
DROP TABLE #Customer
GO

Table Variables doesn’t support DDL statements like ALTER, CREATE, DROP etc, implies we can’t modify the structure of Table variable nor we can drop it explicitly.

3. TRANSACTIONS:
Temporary Tables honor the explicit transactions defined by the user.
Table variables doesn’t participate in the explicit transactions defined by the user.

4. USER DEFINED FUNCTION:
Temporary Tables are not allowed in User Defined Functions.
Table Variables can be used in User Defined Functions.

5. INDEXES:
Temporary table supports adding Indexes explicitly after Temporary Table creation and it can also have the implicit Indexes which are the result of Primary and Unique Key constraint.
Table Variables doesn’t allow the explicit addition of Indexes after it’s declaration, the only means is the implicit indexes which are created as a result of the Primary Key or Unique Key constraint defined during Table Variable declaration.

6. SCOPE:
There are two types of Temporary Tables, one Local Temporary Tables whose name starts with single # sign and other one is Global Temporary Tables whose name starts with two # signs.Scope of the Local Temporary Table is the session in which it is created and they are dropped automatically once the session ends and we can also drop them explicitly. If a Temporary Table is created within a batch, then it can be accessed within the next batch of the same session. Whereas if a Local Temporary Table is created within a stored procedure then it can be accessed in it’s child stored procedures, but it can’t be accessed outside the stored procedure.Scope of Global Temporary Table is not only to the session which created, but they will visible to all other sessions. They can be dropped explicitly or they will get dropped automatically when the session which created it terminates and none of the other sessions are using it.
Scope of the Table variable is the Batch or Stored Procedure in which it is declared. And they can’t be dropped explicitly, they are dropped automatically when batch execution completes or the Stored Procedure execution completes.
*/

/* Delete all rows from the temporary table where the date is not the first of the month */

CREATE TABLE #FirstTable(ID int PRIMARY KEY IDENTITY, DAY datetime)
DECLARE @date1 datetime
SET @date1 = '20120101'
DECLARE @enddate datetime
SET @enddate = '20151231'

BEGIN
WHILE @date1<=@enddate
BEGIN
INSERT INTO #FirstTable (DAY)
VALUES(@date1 )
SET @date1=@date1+1;
END
DELETE FROM #FirstTable
WHERE DATEPART(dd,Day)='01'

SELECT ID, TRIM(CONVERT(VARCHAR, DAY, 103)) as DAY 
FROM #FirstTable
END

DROP TABLE #FirstTable

/* Given the following table details write the create table script to create this table, giving it an appropriate name

       COLUMN                                   DATATYPE                   OTHER ATTRIBUTES
       intSalesPersonID							int                        IDENTITY, PK (named)
       strName                                  nvarchar                   NULL NOT ALLOWED
       strPhone                                 nvarchar                   NULL ALLOWED
       YearsOfService                           int                        NULL NOT ALLOWED
       dtmCreated                               datetime                   NULL NOT ALLOWED, Default value should be now
       dtmUpdated                               datetime                   
       dtmDeleted                               datetime

*/

CREATE TABLE SalesPerson(
       intSalesPersonID							int                        IDENTITY, 
       strName                                  nvarchar(100)              NOT NULL, 
       strPhone                                 nvarchar(100)              NOT NULL, 
       YearsOfService                           int                        NOT NULL,
       dtmCreated                               datetime                   DEFAULT  GETDATE() NOT NULL,
       dtmUpdated                               datetime,                   
       dtmDeleted                               datetime);
ALTER TABLE SalesPerson ADD  CONSTRAINT PK_SALES_PERSON PRIMARY KEY
(intSalesPersonID ASC);

/* Add a column for sales person ID to the Order Table and create any necessary keys */

ALTER TABLE [Order] 
ADD SalesPersonId INT;
ALTER TABLE [Order]
ADD CONSTRAINT FK_SALES_PERSON_ID
FOREIGN KEY (SalesPersonId) REFERENCES SalesPerson(intSalesPersonID);


/* Insert James Fitz, Donna Smith and Roy Page into the Sales Person Table, phone numbers and length of service should be populated*/

INSERT INTO SalesPerson (strName, strPhone, YearsOfService)
VALUES ('James Fitz','07404567896',5);
INSERT INTO SalesPerson (strName, strPhone, YearsOfService)
VALUES ('Donna Smith','07404987006',7);
INSERT INTO SalesPerson (strName, strPhone, YearsOfService)
VALUES ('Roy Page','07404888006',10);

/* Given the following Query, create an appropriate index to improve performance 

			Select	SalesPerson                 =      sp.strName
				,	Product						=      p.ProductName
				,	SalesPersonYearsService		=      sp.YearsOfService
				,	LastSaleofProduct			=      Max(OrderDate)
			From	[Order] o
						Inner Join SalesPerson sp
							on	o.SalesPersonID = sp.intSalesPersonID
						Inner Join OrderItem oi
							on	o.Id = oi.OrderId
						Inner Join Product p
							on	oi.ProductId = p.Id
			Where	sp.dtmDeleted is Null
			Group By
					sp.strName
				,	p.ProductName
				,	sp.YearsOfService

*/

CREATE INDEX INDEX_ORDER_ID ON [ORDER] (ID);

/*     The database schema is not currently Normalised. Identify where the schema requires normalising 
       and script the required change(s)
*/

ALTER TABLE OrderItem DROP CONSTRAINT DF__OrderItem__UnitP__164452B1;
ALTER TABLE OrderItem DROP COLUMN ProductName;
ALTER TABLE OrderItem DROP COLUMN UnitPrice;

/* Write a query giving details of all of suppliers and the total number of units they have sold */

SELECT S.CompanyName AS 'Supplier Name', COALESCE(SUM(P.QuantityPerUnit),0) AS 'Total Number of Units'
FROM SUPPLIER S, PRODUCT P
WHERE S.Id=P.SupplierId
GROUP BY S.CompanyName
ORDER BY S.CompanyName;

/* Write a select statement that returns all supliers that are Limited companies */

SELECT CompanyName
FROM Supplier
WHERE CHARINDEX(' Ltd.',CompanyName)!=0;

/* Write a Query that returns the data on the total Sales Value by Supplier with a column for each year. Hint PIVOT */

DECLARE @query  AS NVARCHAR(MAX)
DECLARE @Columns as VARCHAR(MAX)
SELECT @Columns =
COALESCE(@Columns + ', ','') + QUOTENAME([YEAR])
FROM
   (SELECT DISTINCT DATEPART(yyyy,OrderDate) AS [YEAR]
    FROM  [Order]
   ) AS B
ORDER BY B.[YEAR]

SELECT @query='SELECT S AS ''Supplier Name'','+@Columns+'FROM
(SELECT S.CompanyName AS S, OI.UnitQuantity * P.UnitPrice AS X, DATEPART(yyyy,O.OrderDate) AS Y
FROM SUPPLIER S, PRODUCT P, OrderItem OI, [Order] O
WHERE S.Id=P.SupplierId AND P.Id=OI.ProductId and O.Id=OI.OrderId
) AS SourceTable
PIVOT(
SUM(X) 
FOR Y IN ('+@Columns+') )AS PIVOTTABLE
ORDER BY''Supplier Name'''
EXEC(@query)

/* Write a query to return the 3rd most recently ordered Product */

WITH QUERY1 AS  
( 
SELECT ROW_NUMBER() OVER(ORDER BY C  ASC) AS RowNumber, X
FROM
(SELECT COUNT(OI.ProductId) C, P.ProductName AS X
FROM OrderItem OI, Product P
WHERE P.Id=OI.ProductId
GROUP BY P.ProductName) AS Q2
)
SELECT  X AS Product
FROM  QUERY1
WHERE RowNumber=3

/* Return all orders that occured on the first of any month in 2013 without using Between or >= <= Operators */

SELECT *
  FROM [Order]
  WHERE DATEPART(dd,OrderDate) IN ('01') AND DATEPART(yyyy,OrderDate) IN ('2013')
  ORDER BY OrderDate

/* Return all of the orders placed between 2013-06-05 and 2013-07-24 */

SELECT *
  FROM [Order]
  WHERE CONVERT(DATE,OrderDate) BETWEEN CONVERT(DATE,'06/05/2013',103) AND CONVERT(DATE,'24/07/2013',103)
  ORDER BY OrderDate
  
/* Write a query to identify the Customer with the order that has the highest total quantity of items */
 
WITH Q1 AS (
SELECT C.FirstName +' '+C.LastName as X, SUM(OI.UnitQuantity) AS Y
FROM Customer C, [Order] O, OrderItem OI
WHERE C.Id=O.CustomerId AND O.Id=OI.OrderId
GROUP BY C.FirstName +' '+C.LastName)
SELECT   X AS 'Customer Name'
FROM Q1
WHERE Y=(
SELECT MAX(Y)
FROM Q1
)

/* Identify the City with the highest single order value in 2013 */

SELECT MAX( [Order Value]) AS [Order Value]
FROM(
SELECT [Order Value]
FROM(
SELECT C.City AS City, MAX(O.TotalAmount) AS [Order Value]
FROM CUSTOMER C, [ORDER] O
WHERE C.Id=O.CustomerId AND DATENAME(yyyy, O.OrderDate)='2013'
GROUP BY C.City
) AS Q1
) AS Q2

/*  Using the data set below, write a MERGE statement that updates details of our suppliers where the company name matches and some data is different.
	Where the supplier doesn't exist in the data below then that row should be updated with the current date in the dtmDeleted column.
	Where the supplier exists below but not in the database then this should be added.

       COMPANYNAME, CONTACTNAME, CONTACTTITLE, CITY, COUNTRY, PHONE, FAX
       Exotic Liquids, Ben Jones, NULL, London, UK, (171) 555-2222, NULL
       New Orleans Cajun Delights, Shelley Burke, NULL, New Orleans, USA, (100) 555-4822, NULL
       Grandma Kelly's Homestead, Regina Murphy, NULL, Ann Arbor, USA, (313) 555-5735, (313) 555-3349
       Tokyo Traders, Yoshi Nagase, NULL, Tokyo, Japan, (03) 3555-5011, NULL
       Cooperativa de Quesos 'Las Cabras', Antonio del Valle Saavedra, NULL, Oviedo, Spain, (98) 598 76 54, NULL
       Mayumi's, Mayumi Ohno, NULL, Osaka, Japan, (06) 431-7877, NULL
       Pavlova Ltd., Ian Devling, NULL, Melbourne, Australia, (03) 444-2343, (03) 444-6588
       Specialty Biscuits Ltd., Peter Wilson, NULL, Manchester, UK, (161) 555-4448, NULL
       PB Knäckebröd AB, Lars Peterson, NULL, Göteborg, Sweden, 031-987 65 43, 031-987 65 91
       Refrescos Americanas LTDA, Carlos Diaz, NULL, Sao Paulo, Brazil, (11) 555 4640, NULL
       Heli Süßwaren GmbH & Co. KG, Petra Winkler, NULL, Berlin, Germany, (010) 9984510, NULL
       Plutzer Lebensmittelgroßmärkte AG, Martin Bein, NULL, Frankfurt, Germany, (069) 992755, NULL
       Nord-Ost-Fisch Handelsgesellschaft mbH,Sven Petersen,NULL,Cuxhaven,Germany,(04721) 8713,(04721) 8714
       Formaggi Fortini s.r.l.,Elio Rossi,NULL,Ravenna,Italy,(0544) 60323,(0544) 60603
       Norske Meierier,Beate Vileid,NULL,Sandvika,Norway,(0)2-953010,NULL
       Aux joyeux ecclésiastiques,Guylène Nodier,NULL,Paris,France,(1) 03.83.00.68,(1) 03.83.00.62
       New England Seafood Cannery,Robb Merchant,NULL,Boston,USA,(617) 555-3267,(617) 555-3389
       Leka Trading,Chandra Leka,NULL,Singapore,Singapore,555-8787,NULL
       Lyngbysild,Niels Petersen,NULL,Lyngby,Denmark,43844108,43844115
       Zaanse Snoepfabriek,Dirk Luchte,NULL,LA,USA,,
       Karkki Oy,Anne Heikkonen,NULL,Lappeenranta,Finland,(953) 10956,NULL
       G'day Mate,Wendy Mackenzie,NULL,Sydney,Australia,(02) 555-5914,(02) 555-4873
       Ma Maison,Jean-Guy Lauzon,NULL,Montréal,Canada,(514) 555-9022,NULL
       Pasta Buttini s.r.l.,Giovanni Giudici,NULL,Salerno,Italy,(089) 6547665,(089) 6547667
       Escargots Nouveaux,Marie Delamare,NULL,Montceau,France,85.57.00.07,NULL
       Gai pâturage,Eliane Noz,NULL,Annecy,France,38.76.98.06,38.76.98.58
       Forêts d'érables,Chantal Goulet,NULL,Ste-Hyacinthe,Canada,(514) 555-2955,(514) 555-2921
	   Icebox, James Smith, Null, London, UK, 0207 840 9998, Null
*/

DECLARE @FirstTable TABLE (	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](50) NULL,
	[ContactTitle] [nvarchar](40) NULL,
	[City] [nvarchar](40) NULL,
	[Country] [nvarchar](40) NULL,
	[Phone] [nvarchar](30) NULL,
	[Fax] [nvarchar](30) NULL)

BEGIN

INSERT INTO @FirstTable VALUES ('Exotic Liquids','Ben Jones', NULL,'London','UK','(171) 555-2222', NULL)
INSERT INTO @FirstTable VALUES ('New Orleans Cajun Delights','Shelley Burke', NULL,'New Orleans','USA','(100) 555-4822', NULL)
INSERT INTO @FirstTable VALUES ('Grandma Kelly''s Homestead','Regina Murphy', NULL,'Ann Arbor','USA','(313) 555-5735','(313) 555-3349')
INSERT INTO @FirstTable VALUES ('Tokyo Traders','Yoshi Nagase', NULL,'Tokyo','Japan','(03) 3555-5011', NULL)
INSERT INTO @FirstTable VALUES ('Cooperativa de Quesos''Las Cabras''','Antonio del Valle Saavedra', NULL,'Oviedo','Spain','(98) 598 76 54', NULL)
INSERT INTO @FirstTable VALUES ('Mayumi''s','Mayumi Ohno', NULL,'Osaka','Japan','(06) 431-7877', NULL)
INSERT INTO @FirstTable VALUES ('Pavlova Ltd.','Ian Devling', NULL,'Melbourne','Australia','(03) 444-2343','(03) 444-6588')
INSERT INTO @FirstTable VALUES ('Specialty Biscuits Ltd.','Peter Wilson', NULL,'Manchester','UK','(161) 555-4448', NULL)
INSERT INTO @FirstTable VALUES ('PB Knäckebröd AB','Lars Peterson', NULL,'Göteborg','Sweden','031-987 65 43','031-987 65 91')
INSERT INTO @FirstTable VALUES ('Refrescos Americanas LTDA','Carlos Diaz', NULL,'Sao Paulo','Brazil','(11) 555 4640', NULL)
INSERT INTO @FirstTable VALUES ('Heli Süßwaren GmbH & Co. KG','Petra Winkler', NULL,'Berlin','Germany','(010) 9984510', NULL)
INSERT INTO @FirstTable VALUES ('Plutzer Lebensmittelgroßmärkte AG','Martin Bein', NULL,'Frankfurt','Germany','(069) 992755', NULL)
INSERT INTO @FirstTable VALUES ('Nord-Ost-Fisch Handelsgesellschaft mbH','Sven Petersen',NULL,'Cuxhaven','Germany','(04721) 8713','(04721) 8714')
INSERT INTO @FirstTable VALUES ('Formaggi Fortini s.r.l.','Elio Rossi',NULL,'Ravenna','Italy','(0544) 60323','(0544) 60603')
INSERT INTO @FirstTable VALUES ('Norske Meierier','Beate Vileid',NULL,'Sandvika','Norway','(0)2-953010',NULL)
INSERT INTO @FirstTable VALUES ('Aux joyeux ecclésiastiques','Guylène Nodier',NULL,'Paris','France','(1) 03.83.00.68','(1) 03.83.00.62')
INSERT INTO @FirstTable VALUES ('New England Seafood Cannery','Robb Merchant',NULL,'Boston','USA','(617) 555-3267','(617) 555-3389')
INSERT INTO @FirstTable VALUES ('Leka Trading','Chandra Leka',NULL,'Singapore','Singapore','555-8787',NULL)
INSERT INTO @FirstTable VALUES ('Lyngbysild','Niels Petersen',NULL,'Lyngby','Denmark','43844108','43844115')
INSERT INTO @FirstTable VALUES ('Zaanse Snoepfabriek','Dirk Luchte',NULL,'LA','USA',NULL,NULL)
INSERT INTO @FirstTable VALUES ('Karkki Oy','Anne Heikkonen',NULL,'Lappeenranta','Finland','(953) 10956',NULL)
INSERT INTO @FirstTable VALUES ('G''day Mate','Wendy Mackenzie',NULL,'Sydney','Australia','(02) 555-5914','(02) 555-4873')
INSERT INTO @FirstTable VALUES ('Ma Maison','Jean-Guy Lauzon',NULL,'Montréal','Canada','(514) 555-9022',NULL)
INSERT INTO @FirstTable VALUES ('Pasta Buttini s.r.l.','Giovanni Giudici',NULL,'Salerno','Italy','(089) 6547665','(089) 6547667')
INSERT INTO @FirstTable VALUES ('Escargots Nouveaux','Marie Delamare',NULL,'Montceau','France','85.57.00.07',NULL)
INSERT INTO @FirstTable VALUES ('Gai pâturage','Eliane Noz',NULL,'Annecy','France','38.76.98.06','38.76.98.58')
INSERT INTO @FirstTable VALUES ('Forêts d''érables','Chantal Goulet',NULL,'Ste-Hyacinthe','Canada','(514) 555-2955','(514) 555-2921')
INSERT INTO @FirstTable VALUES ('Icebox','James Smith', Null,'London','UK','0207 840 9998', Null)

MERGE SUPPLIER AS A  
    USING (SELECT * from @FirstTable)  as B
    ON (A.CompanyName = B.CompanyName)  
    WHEN MATCHED THEN   
        UPDATE SET A.[ContactName]=B.[ContactName],
	               A.[ContactTitle]=B.[ContactTitle],
	               A.[City]=B.[City],
	               A.[Country]=B.[Country],
	               A.[Phone]=B.[Phone],
	               A.[Fax]=B.[Fax]
	WHEN NOT MATCHED  THEN 
	INSERT ([CompanyName], [ContactName], [ContactTitle],	[City],	[Country], [Phone], [Fax])  
    VALUES (B.[CompanyName], B.[ContactName], B.[ContactTitle],	B.[City],	B.[Country], B.[Phone], B.[Fax])
	WHEN NOT MATCHED BY SOURCE AND SOUNDEX(A.[CompanyName]) NOT IN
	(SELECT SOUNDEX(Y.[CompanyName]) 
	 FROM  @FirstTable Y)
	 THEN 
		UPDATE SET [dtmDeleted]=GETDATE();
END;

/* Identify All Suppliers that we have not sold any products from using NOT EXIST */

SELECT DISTINCT S1.CompanyName
FROM  Supplier S1
WHERE  S1.Id  NOT IN(
SELECT DISTINCT S1.Id
FROM Product P1, OrderItem OI, Supplier S1
WHERE P1.Id=OI.ProductId AND S1.Id=P1.SupplierId
) AND NOT EXISTS (
SELECT DISTINCT P1.Id
FROM Product P1,  OrderItem OI
WHERE  P1.Id=OI.ProductId
AND P1.SupplierId  NOT IN(
SELECT DISTINCT S1.Id
FROM Supplier S1
));

/*     Write a query that gives a list of all Suppliers and their customers. The query should also return customers that have no related suppliers and 
       suppliers that have no related customers.
*/

WITH Q1 AS(SELECT C.FirstName+' '+C.LastName AS [Name], O.Id AS OID
FROM Customer C
FULL OUTER JOIN [Order] O
ON C.Id=O.CustomerId
)
, Q2 AS(SELECT S.CompanyName AS CName, P.Id AS PID
FROM Supplier S
FULL OUTER JOIN Product P
ON S.Id=P.SupplierId
)
,Q3 AS (SELECT OI.OrderId AS OID, OI.ProductId AS PID
FROM OrderItem OI
FULL OUTER JOIN Product P
ON P.Id=OI.ProductId
)
,Q4 AS( SELECT Q2.CName, Q3.OID
FROM Q2
FULL OUTER JOIN Q3
ON Q2.PID=Q3.PID
)
SELECT DISTINCT Q4.CName AS 'Company Name', Q1.[Name] AS 'Customer Name'
FROM Q1
FULL OUTER JOIN Q4 ON Q1.OID=Q4.OID
ORDER BY Q4.CName, Q1.[Name];

/*     Write a query using the temporary table you created earlier to show rows for every customer for every month 
       since the month they first purchased from us. The table should detail the customer ID, customer name, month,
       Date of first Purchase, Units Purchased that month, Value Purchased that month, Cumulative Units Purchased,
       Cumulative Value Purchased and the Days since last purchase and the last day of the month.
*/

CREATE TABLE #FirstTable(ID int PRIMARY KEY IDENTITY, DAY datetime)
DECLARE @date1 datetime
SET @date1 = '20120101'
DECLARE @enddate datetime
SET @enddate = '20151231'

BEGIN
WHILE @date1<=@enddate
BEGIN
INSERT INTO #FirstTable (DAY)
VALUES(@date1 )
SET @date1=@date1+1;
END;

WITH Q1 AS(
SELECT convert(char(3), F.[DAY], 0)+' '+DATENAME(yyyy, F.[DAY]) AS [Month],C.FirstName+' '+ C.LastName AS [Name],C.Id AS CId, MIN(CONVERT(DATE,O.OrderDate,103)) AS [Date]
FROM Customer C, [Order] O, #FirstTable F
WHERE C.Id=O.CustomerId AND O.OrderDate=F.[DAY]
GROUP BY  convert(char(3), F.[DAY], 0)+' '+DATENAME(yyyy, F.[DAY]), C.FirstName+' '+ C.LastName, C.Id
)
,Q2 AS(
SELECT ROW_NUMBER() OVER(ORDER BY  MAX(F.ID)) AS [Serial No], C.Id AS [Customer ID], C.FirstName + ' '+C.LastName AS [Customer Name], convert(char(3), F.[DAY], 0)+' '+DATENAME(yyyy, F.[DAY]) AS [Month],MIN(CONVERT(DATE,Q1.[Date],103)) AS [Date of First Purchase],SUM(OI.UnitQuantity) as Units,SUM(O.TotalAmount) as Value,DATEDIFF(DAY, MAX(O.OrderDate), EOMONTH(MAX(O.OrderDate))) AS [No. of Days between Last Purchase and the End of the Month]
FROM CUSTOMER C, #FirstTable F, OrderItem OI,[Order] O, Q1--, Q2
WHERE C.Id=O.CustomerId AND O.Id=OI.OrderId AND O.OrderDate=F.[DAY] AND C.Id=Q1.CId AND O.OrderDate=Q1.Date 
GROUP BY C.Id, C.FirstName + ' '+C.LastName, convert(char(3), F.[DAY], 0)+' '+DATENAME(yyyy, F.[DAY]) )
,Q3 AS(
SELECT MAX(Q2.[Serial No])+1 AS [Serial No],NULL AS [Customer ID], NULL AS [Customer Name], NULL AS [Month],NULL AS [Date of First Purchase],SUM(Q2.Units) AS Units,SUM(Q2.[Value]) AS [Value],NULL AS [No. of Days between Last Purchase and the End of the Month]
FROM Q2)
SELECT * FROM(
SELECT ROW_NUMBER() OVER(ORDER BY  Q2.[Date of First Purchase]) AS [Serial No], Q2.[Customer ID], Q2.[Customer Name], Q2.[Month],Q2.[Date of First Purchase],Q2.Units,Q2.[Value], Q2.[No. of Days between Last Purchase and the End of the Month] 
FROM Q2
UNION ALL
SELECT * FROM Q3) AS Q4
ORDER BY  Q4.[Serial No]
DROP TABLE #FirstTable
END