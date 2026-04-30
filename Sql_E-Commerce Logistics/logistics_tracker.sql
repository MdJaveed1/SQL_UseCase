CREATE TABLE Partners (
    PartnerID INT PRIMARY KEY,
    PartnerName VARCHAR(100)
);

CREATE TABLE Shipments (
    ShipmentID INT PRIMARY KEY,
    PartnerID INT,
    DestinationCity VARCHAR(100),
    OrderDate DATE,
    PromisedDate DATE,
    ActualDeliveryDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (PartnerID) REFERENCES Partners(PartnerID)
);

CREATE TABLE DeliveryLogs (
    LogID INT PRIMARY KEY,
    ShipmentID INT,
    LogDate DATE,
    LogDetails VARCHAR(255),
    FOREIGN KEY (ShipmentID) REFERENCES Shipments(ShipmentID)
);

--mock data
INSERT INTO Partners VALUES 
(1, 'SpeedyTrans'),
(2, 'GlobalExpress'),
(3, 'CityCouriers');

INSERT INTO Shipments VALUES
(101, 1, 'New York', '2023-10-01', '2023-10-05', '2023-10-04', 'Successful'),
(102, 1, 'Los Angeles', '2023-10-02', '2023-10-06', '2023-10-08', 'Successful'),
(103, 2, 'Chicago', '2023-10-05', '2023-10-08', '2023-10-08', 'Successful'),
(104, 2, 'New York', '2023-10-06', '2023-10-10', NULL, 'Returned'),
(105, 3, 'Chicago', '2023-10-08', '2023-10-12', '2023-10-14', 'Successful'),
(106, 1, 'Houston', '2023-10-10', '2023-10-15', '2023-10-15', 'Successful'),
(107, 2, 'New York', '2023-10-12', '2023-10-16', '2023-10-16', 'Successful'),
(108, 3, 'Los Angeles', '2023-10-15', '2023-10-20', NULL, 'Returned');

--delayed shipments query
SELECT 
    ShipmentID, 
    PartnerID, 
    PromisedDate, 
    ActualDeliveryDate
FROM Shipments
WHERE ActualDeliveryDate > PromisedDate;

--performance ranking
SELECT 
    p.PartnerName,
    s.Status,
    COUNT(s.ShipmentID) as TotalDeliveries
FROM Partners p
JOIN Shipments s ON p.PartnerID = s.PartnerID
WHERE s.Status IN ('Successful', 'Returned')
GROUP BY p.PartnerName, s.Status;

--most popular zone in the last 30 days
SELECT 
    DestinationCity, 
    COUNT(ShipmentID) as OrderCount
FROM Shipments
WHERE OrderDate >= DATE('now', '-30 days')
GROUP BY DestinationCity
ORDER BY OrderCount DESC
LIMIT 1;

-- partner scorecard 
SELECT 
    p.PartnerName,
    COUNT(s.ShipmentID) as Delays
FROM Partners p
JOIN Shipments s ON p.PartnerID = s.PartnerID
WHERE s.ActualDeliveryDate > s.PromisedDate
GROUP BY p.PartnerName
ORDER BY Delays ASC;
