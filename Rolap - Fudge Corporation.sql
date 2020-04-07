/****** Object:  Database ist722_hhkhan_oc2_dw    Script Date: 4/25/2019 7:49:51 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE ist722_hhkhan_oc2_dw
GO
CREATE DATABASE ist722_hhkhan_oc2_dw
GO
ALTER DATABASE ist722_hhkhan_oc2_dw
SET RECOVERY SIMPLE
GO
*/
USE ist722_hhkhan_oc2_dw
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;




-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
--GO
--CREATE SCHEMA fudgecorp
--GO

drop table fudgecorp.ReviewFact
drop table fudgecorp.SalesFact
drop table fudgecorp.DimDate
drop table fudgecorp.DimCustomer
drop table fudgecorp.DimProduct




/* Drop table fudgecorp.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgecorp.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgecorp.DimCustomer 
;

/* Create table fudgecorp.DimCustomer */
CREATE TABLE fudgecorp.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  int   NULL
,  [CustomerName]  nvarchar(50)   NOT NULL
,  [CustomerEmail]  nvarchar(50)   NULL
,  [CustomerZip]  nvarchar(10)   NOT NULL
,  [CustomerCity]  nvarchar(40)   NULL
,  [CustomerState]  nvarchar(40)   NULL
,  [CustomerReview]  nvarchar(200)   NULL
,  [CustomerTweetId]  nvarchar(50)   NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_fudgecorp.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT fudgecorp.DimCustomer ON
;
INSERT INTO fudgecorp.DimCustomer (CustomerKey, CustomerID, CustomerName, CustomerEmail, CustomerZip, CustomerCity, CustomerState, CustomerReview, CustomerTweetId, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, NULL, '', '', '', '', '', '', '', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgecorp.DimCustomer OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgecorp].[Customer]'))
DROP VIEW [fudgecorp].[Customer]
GO
CREATE VIEW [fudgecorp].[Customer] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [CustomerID] AS [CustomerID]
, [CustomerName] AS [CustomerName]
, [CustomerEmail] AS [CustomerEmail]
, [CustomerZip] AS [CustomerZip]
, [CustomerCity] AS [CustomerCity]
, [CustomerState] AS [CustomerState]
, [CustomerReview] AS [CustomerReview]
, [CustomerTweetId] AS [CustomerTweetId]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgecorp.DimCustomer
GO





/* Drop table fudgecorp.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgecorp.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgecorp.DimDate 
;

/* Create table fudgecorp.DimDate */
CREATE TABLE fudgecorp.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  date   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  smallint   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  smallint   NOT NULL
,  [IsWeekday]  bit  DEFAULT 0 NOT NULL
, CONSTRAINT [PK_fudgecorp.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;


INSERT INTO fudgecorp.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgecorp].[Date]'))
DROP VIEW [fudgecorp].[Date]
GO
CREATE VIEW [fudgecorp].[Date] AS 
SELECT [DateKey] AS [DateKey]
, [Date] AS [Date]
, [FullDateUSA] AS [FullDateUSA]
, [DayOfWeek] AS [DayOfWeek]
, [DayName] AS [DayName]
, [DayOfMonth] AS [DayOfMonth]
, [DayOfYear] AS [DayOfYear]
, [WeekOfYear] AS [WeekOfYear]
, [MonthName] AS [MonthName]
, [MonthOfYear] AS [MonthOfYear]
, [Quarter] AS [Quarter]
, [QuarterName] AS [QuarterName]
, [Year] AS [Year]
, [IsWeekday] AS [IsWeekday]
FROM fudgecorp.DimDate
GO

/* Drop table fudgecorp.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgecorp.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgecorp.DimProduct 
;

/* Create table fudgecorp.DimProduct */
CREATE TABLE fudgecorp.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int   NOT NULL
,  [ProductName]  nvarchar(50)   NOT NULL
,  [ProductVendorName]  nvarchar(50)  DEFAULT 'N' NOT NULL
,  [ProductCategory]  nvarchar(40)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_fudgecorp.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT fudgecorp.DimProduct ON
;
INSERT INTO fudgecorp.DimProduct (ProductKey, ProductID, ProductName, ProductVendorName, ProductCategory, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, '', '-1', '', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgecorp.DimProduct OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgecorp].[Product]'))
DROP VIEW [fudgecorp].[Product]
GO
CREATE VIEW [fudgecorp].[Product] AS 
SELECT [ProductKey] AS [ProductKey]
, [ProductID] AS [ProductID]
, [ProductName] AS [ProductName]
, [ProductVendorName] AS [ProductVendorName]
, [ProductCategory] AS [ProductCategory]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgecorp.DimProduct
GO




/* Drop table fudgecorp.ReviewFact */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgecorp.ReviewFact') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgecorp.ReviewFact 
;

/* Create table fudgecorp.ReviewFact */
CREATE TABLE fudgecorp.ReviewFact (
   [ProductKey]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [ReviewDateKey]  int   NOT NULL
,  [ProductReviewRating]  int   NULL
,  [InsertAuditKey]  int    NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_fudgecorp.ReviewFact] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [CustomerKey], [ReviewDateKey] )
) ON [PRIMARY]
;


-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgecorp].[Review Fact]'))
DROP VIEW [fudgecorp].[Review Fact]
GO
CREATE VIEW [fudgecorp].[Review Fact] AS 
SELECT [ProductKey] AS [ProductKey]
, [CustomerKey] AS [CustomerKey]
, [ReviewDateKey] AS [ReviewDateKey]
, [ProductReviewRating] AS [ProductReviewRating]
--, [InsertAuditKey] AS [Insert Audit Key]
--, [UpdateAuditKey] AS [Update Audit Key]
FROM fudgecorp.ReviewFact
GO


/* Drop table fudgecorp.SalesFact */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgecorp.SalesFact') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgecorp.SalesFact 
;

/* Create table fudgecorp.SalesFact */
CREATE TABLE fudgecorp.SalesFact (
   [ProductKey]  int    NOT NULL
,  [CustomerKey]  int    NOT NULL
,  [DateKey]  int    NOT NULL
,  [Order_Qty]  int   NOT NULL
,  [product_price]  money   NOT NULL
,  [Sold_Amount]  float   NOT NULL
,  [order_id] int NOT NULL
--,  [InsertAuditKey]  int   NOT NULL
--,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_fudgecorp.SalesFact] PRIMARY KEY NONCLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;


-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgecorp].[Sales Fact]'))
DROP VIEW [fudgecorp].[Sales Fact]
GO
CREATE VIEW [fudgecorp].[Sales Fact] AS 
SELECT [ProductKey] AS [ProductKey]
, [CustomerKey] AS [CustomerKey]
, [DateKey] AS [DateKey]
, [Order_Qty] AS [Order_Qty]
, [product_price] AS [product_price]
, [Sold_Amount] AS [Sales_Amount]
--, [InsertAuditKey] AS [Insert Audit Key]
--, [UpdateAuditKey] AS [Update Audit Key]
FROM fudgecorp.SalesFact
GO


ALTER TABLE fudgecorp.ReviewFact ADD CONSTRAINT
   FK_fudgecorp_ReviewFact_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES fudgecorp.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgecorp.ReviewFact ADD CONSTRAINT
   FK_fudgecorp_ReviewFact_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES fudgecorp.DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgecorp.ReviewFact ADD CONSTRAINT
   FK_fudgecorp_ReviewFact_ReviewDateKey FOREIGN KEY
   (
   ReviewDateKey
   ) REFERENCES fudgecorp.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
/*ALTER TABLE fudgecorp.ReviewFact ADD CONSTRAINT
   --FK_fudgecorp_ReviewFact_InsertAuditKey FOREIGN KEY
   --(
   --InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgecorp.ReviewFact ADD CONSTRAINT
   FK_fudgecorp_ReviewFact_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 */

ALTER TABLE fudgecorp.SalesFact ADD CONSTRAINT
   FK_fudgecorp_SalesFact_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES fudgecorp.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgecorp.SalesFact ADD CONSTRAINT
   FK_fudgecorp_SalesFact_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES fudgecorp.DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgecorp.SalesFact ADD CONSTRAINT
   FK_fudgecorp_SalesFact_DateKey FOREIGN KEY
   (
   DateKey
   ) REFERENCES fudgecorp.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
/*ALTER TABLE fudgecorp.SalesFact ADD CONSTRAINT
   FK_fudgecorp_SalesFact_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgecorp.SalesFact ADD CONSTRAINT
   FK_fudgecorp_SalesFact_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;*/
 
