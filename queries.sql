SELECT AirplaneName, AirplaneModel FROM Airplanes
WHERE AirplaneCapacity > 100;


SELECT * FROM Tickets
WHERE Price BETWEEN  100 AND 200;

SELECT name, surname, COUNT(*) AS NumberOfFlights
FROM Staff 
WHERE Gender = 'Female' AND Role = 'Pilot'
GROUP BY name, surname
HAVING COUNT(*) > 0; --imaju sve samo jedan let


SELECT *
FROM Staff
WHERE Role = 'Flight Attendant'
  AND Gender = 'Female'
  AND FlightID IN (SELECT FlightID FROM Airplanes WHERE LocationStatus = 'air');

SELECT COUNT(*) AS NumberOfFlights
FROM Flight
WHERE FinalAirportID IN (SELECT AirportID FROM Airport WHERE CityID = (SELECT CityID FROM Cities WHERE CityName = 'Split'))
  AND EXTRACT(YEAR FROM DepartureTime) = 2023;


SELECT *
FROM Flight
WHERE FinalAirportID IN (SELECT AirportID FROM Airport WHERE CityID = (SELECT CityID FROM Cities WHERE CityName = 'Vienna'))
  AND EXTRACT(MONTH FROM DepartureTime) = 12
  AND EXTRACT(YEAR FROM DepartureTime) = 2023;


SELECT COUNT(*) AS NumSoldEconomyFlights
FROM Tickets, Flight, FlightCompany
WHERE Tickets.FlightID = Flight.FlightID
      AND Flight.FlightCompanyID = FlightCompany.FlightCompanyID
      AND FlightCompany.FlightCompanyName = 'AirDUMP'
      AND Tickets.SeatClass = 'B'
      AND EXTRACT(YEAR FROM Tickets.DateOfFlight) = 2023;
 --not air dump added in db check

 SELECT a.AirportName, COUNT(ap.AirplaneID) AS NumberOfAirbusPlanes
FROM Airport a
LEFT JOIN Airplanes ap ON a.AirportID = ap.AirportID
WHERE a.CityID = (SELECT CityID FROM Cities WHERE CityName = 'London')
  AND ap.FlightCompanyID = (SELECT FlightCompanyID FROM FlightCompany WHERE FlightCompanyName = 'Airbus')
  AND ap.LocationStatus = 'runway'
GROUP BY a.AirportID, a.AirportName
HAVING COUNT(ap.AirplaneID) > 0
ORDER BY NumberOfAirbusPlanes DESC;


WITH SplitInfo AS (
    SELECT Latitude AS SplitLatitude, Longitude AS SplitLongitude
    FROM Cities
    WHERE CityName = 'Split'
)
SELECT
    a.AirportID,
    a.AirportName,
    a.RunwayCapacity,
    a.WarehouseCapacity,
    a.Latitude AS AirportLatitude,
    a.Longitude AS AirportLongitude,
    c.CityName AS CityName,
    c.Latitude AS CityLatitude,
    c.Longitude AS CityLongitude
FROM
    Airport a
JOIN
    Cities c ON a.CityID = c.CityID
CROSS JOIN
    SplitInfo
WHERE   
    6371000 * acos(
        sin(radians(cast(SplitInfo.SplitLatitude as float))) * sin(radians(cast(a.Latitude as float))) +
        cos(radians(cast(SplitInfo.SplitLatitude as float))) * cos(radians(cast(a.Latitude as float))) *
        cos(radians(cast(a.Longitude as float)) - radians(cast(SplitInfo.SplitLongitude as float)))
    ) < 1500000;


UPDATE Tickets
SET Price = Price * 0.8
WHERE FlightID IN (
    SELECT FlightID
    FROM Flight F
    WHERE (
        SELECT COUNT(TicketID)
        FROM Tickets
        WHERE Tickets.FlightID = F.FlightID
    ) < 20
);

UPDATE Staff
SET Salary = Salary + 100
WHERE Role = 'Pilot'
  AND StaffID IN (
    SELECT s.StaffID
    FROM Staff s
    JOIN Flight f ON s.FlightID = f.FlightID
    WHERE EXTRACT(YEAR FROM f.DepartureTime) = EXTRACT(YEAR FROM CURRENT_DATE)
      AND f.ArrivalTime - f.DepartureTime > INTERVAL '10 hours'
    GROUP BY s.StaffID
    HAVING COUNT(*) > 10
  );


UPDATE Airplanes
SET Status = 'disassembled', LocationStatus = 'warehouse'
WHERE DateOfProduction < CURRENT_DATE - INTERVAL '20 years'
AND AirplaneID NOT IN (
    SELECT DISTINCT AirplaneID
    FROM Flight
    WHERE DepartureTime > CURRENT_DATE
);

DELETE FROM Flight
WHERE FlightID NOT IN (
    SELECT DISTINCT t.FlightID
    FROM Tickets t
);

UPDATE Users
SET LoyaltyCardID = FALSE,
    ExpirationDate = NULL
WHERE
    Surname ILIKE '%ov' OR
    Surname ILIKE '%ova' OR
    Surname ILIKE '%in' OR
    Surname ILIKE '%ina';