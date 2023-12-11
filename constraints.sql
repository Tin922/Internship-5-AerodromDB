
ALTER TABLE Tickets
    ADD CONSTRAINT CK_SeatClass CHECK (
        SeatClass IN ('A', 'B'));

ALTER TABLE FlightReview
ADD CONSTRAINT CK_Rating CHECK (Rating >= 1 AND Rating <= 5);  

ALTER TABLE Staff
ADD CONSTRAINT CheckPilotAge
CHECK (Role = 'Pilot' AND DateOfBirth <= CURRENT_DATE - INTERVAL '20 years' AND DateOfBirth >= CURRENT_DATE - INTERVAL '60 years');

ALTER TABLE Users
ADD CONSTRAINT CheckLoyaltyCard
CHECK (LoyaltyCardID IS NULL OR (LoyaltyCardID IS NOT NULL AND NumberOfPurchasedTickets >= 10));


CREATE OR REPLACE FUNCTION check_departure_arrival_times()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.DepartureTime >= NEW.ArrivalTime THEN
        RAISE EXCEPTION 'Departure time must be before arrival time';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_departure_arrival_times_trigger
BEFORE INSERT OR UPDATE
ON Flight
FOR EACH ROW
EXECUTE FUNCTION check_departure_arrival_times();



CREATE OR REPLACE FUNCTION check_flight_capacity()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.FlightCapacity > (SELECT AirplaneCapacity FROM Airplanes WHERE AirplaneID = NEW.AirplaneID) THEN
        RAISE EXCEPTION 'Flight capacity cannot exceed airplane capacity';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_flight_capacity_trigger
BEFORE INSERT OR UPDATE
ON Flight
FOR EACH ROW
EXECUTE FUNCTION check_flight_capacity();


ALTER TABLE Airplanes
    ADD CONSTRAINT CK_Status CHECK (
        Status IN ('active', 'for sale', 'under repair', 'disassembled')),
    ADD CONSTRAINT CK_Location CHECK (
        LocationStatus IN ('air', 'runway', 'warehouse'));