USE DATABASE IMT577_DW_KASHYAP_JAGWANI;

CREATE 
OR REPLACE TABLE Fact_SALESACTUAL (
  DimProductID NUMBER(9) FOREIGN KEY REFERENCES Dim_Product(DimProductID) NOT NULL, 
  DimStoreID NUMBER(9) FOREIGN KEY REFERENCES Dim_Store(DimStoreID) NOT NULL, 
  DimResellerID VARCHAR(255) FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID) NOT NULL, 
  DimCustomerID VARCHAR(255) FOREIGN KEY REFERENCES Dim_Customer(DimCustomerID) NOT NULL, 
  DimChannelID NUMBER(9) FOREIGN KEY REFERENCES Dim_Channel(DimChannelID) NOT NULL, 
  DimSaleDateID NUMBER(9) FOREIGN KEY REFERENCES Dim_Date(DATE_PKEY) NOT NULL, 
  DimLocationID NUMBER(38) FOREIGN KEY REFERENCES Dim_Location(DimLocationID) NOT NULL, 
  SourceSalesHeaderID INTEGER NOT NULL, 
  SourceSalesDetailID INTEGER NOT NULL, 
  SaleAmount FLOAT NOT NULL, 
  SaleQuantity INTEGER NOT NULL, 
  SaleUnitPrice FLOAT NOT NULL, 
  SaleExtendedCost FLOAT NOT NULL, 
  SaleTotalProfit FLOAT NOT NULL
);

CREATE 
OR REPLACE TABLE FACT_PRODUCTSALESTARGET (
  DimProductID number(9) FOREIGN KEY REFERENCES Dim_Product(DimProductID), 
  DimTargetDateID number(9) FOREIGN KEY REFERENCES Dim_Date(DATE_PKEY), 
  ProductTargetSalesQuantity INT NOT NULL
);

CREATE 
OR REPLACE TABLE Fact_SRCSALESTARGET (
  DimStoreID NUMBER(9) FOREIGN KEY REFERENCES Dim_Store(DimStoreID), 
  DimResellerID VARCHAR(255) FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID), 
  DimChannelID NUMBER(9) FOREIGN KEY REFERENCES Dim_Channel(DimChannelID), 
  DimTargetDateID NUMBER(9) FOREIGN KEY REFERENCES Dim_Date(DATE_PKEY), 
  SalesTargetAmount INT
);

INSERT INTO Fact_SALESACTUAL (
  DimProductID, DimStoreID, DimResellerID, 
  DimCustomerID, DimChannelID, DimSaleDateID, 
  DimLocationID, SourceSalesHeaderID, 
  SourceSalesDetailID, SaleAmount, 
  SaleQuantity, SaleUnitPrice, SaleExtendedCost, 
  SaleTotalProfit
) 
SELECT 
  DISTINCT DP.DimProductID, 
  COALESCE(DS.DimStoreID, -1), 
  COALESCE(DR.DimResellerid, -1), 
  COALESCE(DCU.DimCustomerID, '-1'), 
  DC.DimChannelID, 
  D.Date_PKEY, 
  DL.DimLocationID, 
  SH.SalesHeaderID, 
  SD.SalesDetailID, 
  SD.SalesAmount, 
  SD.SalesQuantity, 
  DP.ProductRetailPrice as SaleUnitPrice, 
  DP.ProductCost as SaleExtendedCost, 
  (
    (SaleUnitPrice - SaleExtendedCost) * SD.SalesQuantity
  ) as SaleTotalProfit 
FROM 
  STAGE_SALES_HEADER_NEW SH 
  INNER JOIN Dim_Date D ON SH.Date = CONCAT(
    D.MONTH_NUM_IN_YEAR, 
    '/', 
    D.Day_Num_In_Month, 
    '/', 
    SUBSTRING(D.Year, 3, 2)
  ) 
  INNER JOIN STAGE_SALES_DETAIL SD ON SD.SalesHeaderID = SH.SalesHeaderID 
  INNER JOIN Dim_Product DP ON SD.ProductID = DP.DimProductID 
  INNER JOIN Dim_Channel DC ON SH.ChannelID = DC.DimChannelID 
  INNER JOIN Dim_Customer DCU ON SH.CustomerID = DCU.CustomerID 
  LEFT JOIN Dim_Store DS ON SH.StoreID = DS.DimStoreID 
  LEFT JOIN Dim_Reseller DR ON SH.ResellerID = DR.ResellerID 
  INNER JOIN Dim_Location DL On DL.DimLocationID = DS.DimLocationID 
  OR DL.DimLocationID = DCU.DimLocationID 
  OR DL.DimLocationID = DR.DimLocationID;
  
INSERT INTO FACT_PRODUCTSALESTARGET (
  DimProductID, DimTargetDateID, ProductTargetSalesQuantity
) 
SELECT 
  distinct p.productid, 
  d.date_pkey, 
  dp.salesquantitytarget 
FROM 
  STAGE_TARGET_DATA_PRODUCT dp 
  inner join dim_product p on p.productid = dp.productid 
  inner join dim_date d on d.year = dp.year;
  
INSERT INTO Fact_SRCSALESTARGET (
  DimStoreID, DimResellerID, DimChannelID, 
  DimTargetDateID, SalesTargetAmount
) 
SELECT 
  DISTINCT COALESCE(S.DimStoreID, -1), 
  COALESCE(R.DimResellerid, -1), 
  C.DimChannelID, 
  D.Date_Pkey, 
  TD.TargetSalesAmount 
FROM 
  STAGE_TARGET_DATA_CHANNEL_RESELLER_STORE TD 
  INNER JOIN Dim_Date D ON TD.Year = D.Year 
  INNER JOIN Dim_Channel C ON C.ChannelName = CASE WHEN TD.ChannelName = 'Online' THEN 'On-line' ELSE TD.ChannelName END 
  LEFT JOIN Dim_Store S ON S.StoreNumber = CASE WHEN TD.TargetName = 'Store Number 5' THEN 5 WHEN TD.TargetName = 'Store Number 8' THEN 8 WHEN TD.TargetName = 'Store Number 10' THEN 10 WHEN TD.TargetName = 'Store Number 21' THEN 21 WHEN TD.TargetName = 'Store Number 34' THEN 34 WHEN TD.TargetName = 'Store Number 39' THEN 39 END 
  LEFT JOIN Dim_Reseller R ON C.ChannelName = R.ResellerName;