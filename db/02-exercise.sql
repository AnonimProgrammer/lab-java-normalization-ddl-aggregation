CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    status VARCHAR(50) NOT NULL
);

CREATE TABLE aircrafts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    total_seats INT NOT NULL CHECK (total_seats > 0)
);

CREATE TABLE flights (
    id INT AUTO_INCREMENT PRIMARY KEY,
    number VARCHAR(20) NOT NULL UNIQUE,
    mileage INT NOT NULL CHECK (mileage >= 0),
    aircraft_id INT NOT NULL,

    INDEX idx_flights_aircraft_id (aircraft_id),

    CONSTRAINT fk_flight_aircraft_id
        FOREIGN KEY (aircraft_id)
        REFERENCES aircrafts(id)
        ON DELETE RESTRICT
);

CREATE TABLE bookings (
    customer_id INT NOT NULL,
    flight_id INT NOT NULL,
    PRIMARY KEY (customer_id, flight_id),

    CONSTRAINT fk_booking_customer_id
        FOREIGN KEY (customer_id)
        REFERENCES customers(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_booking_flight_id
        FOREIGN KEY (flight_id)
        REFERENCES flights(id)
        ON DELETE CASCADE
);

INSERT INTO aircrafts (name, total_seats) VALUES
    ('Boeing 747', 400),
    ('Airbus A330', 236);

INSERT INTO customers (name, status) VALUES
    ('Agustine Riviera', 'Silver'),
    ('Alaina Sepulvida', 'None');

INSERT INTO flights (number, mileage, aircraft_id) VALUES
    ('DL143', 135,
    (SELECT id FROM aircrafts WHERE name = 'Boeing 747')),

    ('DL122', 4370,
    (SELECT id FROM aircrafts WHERE name = 'Airbus A330'));

INSERT INTO bookings (customer_id, flight_id) VALUES
(
    (SELECT id FROM customers WHERE name = 'Agustine Riviera'),
    (SELECT id FROM flights WHERE number = 'DL143')
),
(
    (SELECT id FROM customers WHERE name = 'Agustine Riviera'),
    (SELECT id FROM flights WHERE number = 'DL122')
),
(
    (SELECT id FROM customers WHERE name = 'Alaina Sepulvida'),
    (SELECT id FROM flights WHERE number = 'DL122')
);

SELECT c.name AS customer_name,
       c.status AS customer_status,
       f.number AS flight_number,
       a.name AS aircraft,
       a.total_seats AS total_aircraft_seats,
       f.mileage AS flight_mileage,
       SUM(f.mileage) OVER (PARTITION BY c.id) AS total_customer_mileage
FROM customers c
    LEFT JOIN bookings b ON c.id = b.customer_id
    JOIN flights f ON b.flight_id = f.id
    JOIN aircrafts a ON f.aircraft_id = a.id