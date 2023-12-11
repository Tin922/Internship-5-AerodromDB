create table Cities (
	CityID SERIAL PRIMARY KEY,
	CityName VARCHAR(50) NOT NULL,
	Latitude VARCHAR(50) NOT NULL,
	Longitude VARCHAR(50) NOT NULL
);
create table FlightCompany (
	FlightCompanyID SERIAL PRIMARY KEY,
	FlightCompanyName VARCHAR(50) NOT NULL
);
create table Airport (
	AirportID SERIAL PRIMARY KEY,
	AirportName VARCHAR(100) NOT NULL,
	RunwayCapacity INT NOT NULL,
	WarehouseCapacity INT NOT NULL,	
	Latitude VARCHAR(50) NOT NULL,
	Longitude VARCHAR(50) NOT NULL,
	CityID INT REFERENCES Cities(CityID)
);
create table Airplanes (
	AirplaneID SERIAL PRIMARY KEY,
	AirplaneName VARCHAR(50) NOT NULL,
	AirplaneModel VARCHAR(50) NOT NULL,
	Status VARCHAR(12) NOT NULL,
	LocationStatus VARCHAR(9) NOT NULL,
	DateOfProduction DATE NOT NULL,
	AirplaneCapacity INT NOT NULL,
	FlightCompanyID INT REFERENCES FlightCompany(FlightCompanyID),
	AirportID INT REFERENCES Airport (AirportID)
);
create table Users (
	UserID SERIAL PRIMARY KEY,
    NumberOfPurchasedTickets INT,
    Name VARCHAR(30) NOT NULL,
    Surname VARCHAR(30) NOT NULL,
    LoyaltyCardID boolean NULL,
    ExpirationDate DATE NULL
);
create table Flight (
	FlightID SERIAL PRIMARY KEY,
	FlightCapacity INT NOT NULL,
	DepartureTime DATE NOT NULL,
	ArrivalTime DATE NOT NULL,
	FlightCompanyID INT REFERENCES FlightCompany(FlightCompanyID), 
	AirplaneID INT REFERENCES Airplanes(AirplaneID),
	FinalAirportID INT REFERENCES Airport(AirportID)
);
create table Tickets (
	TicketID SERIAL PRIMARY KEY,
	SeatClass VARCHAR (1) NOT NULL,
	SeatNumber INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Surname VARCHAR(50) NOT NULL ,
	Price DECIMAL(4,1) NOT NULL,
	DateOfFlight DATE NOT NULL,
	FlightID INT REFERENCES Flight(FlightID),
    UserID INT REFERENCES Users(UserID),
	AirplaneID INT REFERENCES Airplanes (AirplaneID),
	FlightCompanyID INT REFERENCES FlightCompany(FlightCompanyID)  
);
create table FlightReview(
	ReviewID SERIAL PRIMARY KEY,
	Comment TEXT,
	Rating INT,	
	FlightID INT REFERENCES Flight(FlightID),
    UserID INT REFERENCES Users(UserID)
);
create table Staff (
	StaffID SERIAL PRIMARY KEY,
	Role VARCHAR(16) NOT NULL,
	DateOfBirth DATE NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Surname VARCHAR(50) NOT NULL,
	Salary INT NOT NULL,
	Gender VARCHAR(50) NOT NULL,
	FlightID INT REFERENCES Flight(FlightID)
);

UPDATE Users
SET ExpirationDate = NULL
WHERE LoyaltyCardID = FALSE;