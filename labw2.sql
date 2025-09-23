create table airline_info(
	airline_id int primary key,
	airline_code varchar(30) not null,
	airline_name varchar(50) not null,
	airline_country varchar(50) not null,
	created_at timestamp not null,
	updated_at timestamp not null,
	info varchar(50) not null
);
create table airport (
    airport_id int primary key,
    airport_name varchar(50) not null,
    country varchar(50) not null,
    state varchar(50) not null,
    city varchar(50) not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
create table baggage_check (
    baggage_check_id int primary key,
    check_result varchar(50) not null,
    created_at timestamp not null,
    updated_at timestamp not null,
    booking_id int not null,
    passenger_id int not null
);
create table baggage (
    baggage_id int primary key,
    weight_in_kg decimal(4,2) not null,
    created_at timestamp not null,
    updated_at timestamp not null,
    booking_id int not null
);
create table boarding_pass (
    boarding_pass_id int primary key,
    booking_id int not null,
    seat varchar(50) not null,
    boarding_time timestamp not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
create table booking_flight (
    booking_flight_id int primary key,
    booking_id int not null,
    flight_id int not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
create table booking (
    booking_id int primary key,
    flight_id int not null,
    passenger_id int not null,
    booking_platform varchar(50) not null,
    created_at timestamp not null,
    updated_at timestamp not null,
    status varchar(50) not null,
    price decimal(7,2) not null
);
create table flights (
    flight_id int primary key,
    sch_departure_time timestamp not null,
    sch_arrival_time timestamp not null,
    departing_airport_id int not null,
    arriving_airport_id int not null,
    departing_gate varchar(50) not null,
    arriving_gate varchar(50) not null,
    airline_id int not null,
    act_departure_time timestamp not null,
    act_arrival_time timestamp not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
create table passengers (
    passenger_id int primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    date_of_birth date not null,
    gender varchar(50) not null,
    country_of_citizenship varchar(50) not null,
    country_of_residence varchar(50) not null,
    passport_number varchar(20) not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
create table security_check (
    security_check_id int primary key,
    check_result varchar(20) not null,
    created_at timestamp not null,
    updated_at timestamp not null,
    passenger_id int not null
);
--5
alter table airline_info rename to airline;
--6
alter table booking rename column price to ticket_price;
--7
alter table flights alter column departing_gate type text;
--8
alter table airline drop column info;
--9
alter table security_check add foreign key (passenger_id) references passengers(passenger_id);
alter table booking add foreign key (passenger_id) references passengers(passenger_id);
alter table baggage_check add foreign key (passenger_id) references passengers(passenger_id);
alter table baggage_check add foreign key (booking_id) references booking(booking_id);
alter table baggage add foreign key (booking_id) references booking(booking_id);
alter table boarding_pass add foreign key (booking_id) references booking(booking_id);
alter table booking_flight add foreign key (booking_id) references booking(booking_id);
alter table booking_flight add foreign key (flight_id) references flights(flight_id);
alter table flights add foreign key (departing_airport_id) references airport(airport_id);
alter table flights add foreign key (arriving_airport_id) references airport(airport_id);
alter table flights add foreign key (airline_id) references airline(airline_id);
--1 dml
--airport
insert into airport(airport_id,airport_name,country,state,city,created_at,updated_at)select g,'Airport_' || g,'Kazakhstan','StateB','Almaty',NOW(),NOW() from generate_series(1,200) as g;
--airline
INSERT INTO airline(airline_id,airline_code, airline_name, airline_country, created_at, updated_at)
SELECT g,
       'AC' || g,
       'Airline_' || g,
       'Kazakhstan',
       NOW(),
       NOW()
FROM generate_series(1,200) AS g;
--baggage_check
INSERT INTO baggage_check(baggage_check_id, check_result,
                          created_at, updated_at, booking_id, passenger_id)
SELECT g,
       'OK',
       NOW(),
       NOW(),
       1,   -- booking id = 1
       1    -- passenger id = 1
FROM generate_series(1,200) AS g;
--baggage
INSERT INTO baggage(baggage_id, weight_in_kg, created_at, updated_at, booking_id)
SELECT g,
       20.5,
       NOW(),
       NOW(),
       1   -- all linked to booking 1
FROM generate_series(1,200) AS g;
--boarding_pass
INSERT INTO boarding_pass(boarding_pass_id, booking_id, seat,
                          boarding_time, created_at, updated_at)
SELECT g,
       1,   -- booking id = 1
       'Seat_' || g,
       NOW(),
       NOW(),
       NOW()
FROM generate_series(1,200) AS g;
--booking_flight
INSERT INTO booking_flight(booking_flight_id, booking_id, flight_id,
                           created_at, updated_at)
SELECT g,
       1,   -- booking id = 1
       1,   -- flight id = 1
       NOW(),
       NOW()
FROM generate_series(1,200) AS g;
--booking
INSERT INTO booking(booking_id, flight_id, passenger_id,
                    booking_platform, created_at, updated_at,
                    status, ticket_price)
SELECT g,
       1,   -- all bookings linked to flight 1
       1,   -- all bookings linked to passenger 1
       'Website',
       NOW(),
       NOW(),
       'Confirmed',
       10000.00 + g
FROM generate_series(1,200) AS g;
--flights
INSERT INTO flights(flight_id, sch_departure_time, sch_arrival_time,
                    departing_airport_id, arriving_airport_id,
                    departing_gate, arriving_gate,
                    airline_id, act_departure_time, act_arrival_time,
                    created_at, updated_at)
SELECT g,
       NOW(),
       NOW() + interval '2 hours',
       1,   -- always from airport 1
       2,   -- always to airport 2
       'Gate_' || g,
       'Gate_' || (g+1),
       1,   -- airline id = 1
       NOW(),
       NOW() + interval '2 hours',
       NOW(),
       NOW()
FROM generate_series(1,200) AS g;
--passengers
INSERT INTO passengers(passenger_id, first_name, last_name, date_of_birth, gender,
                       country_of_citizenship, country_of_residence, passport_number,
                       created_at, updated_at)
SELECT g,
       'Name_' || g,
       'Surname_' || g,
       DATE '1980-01-01',
       'Male',
       'Kazakhstan',
       'Kazakhstan',
       'P' || g,
       NOW(),
       NOW()
FROM generate_series(1,200) AS g;
--security_check
INSERT INTO security_check(security_check_id, check_result,
                           created_at, updated_at, passenger_id)
SELECT g,
       'Clear',
       NOW(),
       NOW(),
       1   -- passenger id = 1
FROM generate_series(1,200) AS g;

--2
insert into airline(airline_id,airline_code,airline_name,airline_country,created_at,updated_at)values(1,'KZR','KazAir','Kazakhstan',NOW(),NOW());
--3
update airline set airline_country='Turkey' , updated_at=NOW() where airline_name='KazAir';
--4
insert into  airline (airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
values
(2, 'EZY', 'AirEasy', 'France', NOW(), NOW()),
(3, 'FLH', 'FlyHigh', 'Brazil', NOW(), NOW()),
(4, 'FLY', 'FlyFly', 'Poland', NOW(), NOW());
--5
delete from flights where extract(year from sch_arrival_time)=2024 or extract (year from act_arrival_time)=2024;
--6
update booking set ticket_price=ticket_price*1.15,updated_at=NOW();
--7
delete from booking where ticket_price<10000;
TRUNCATE TABLE airline RESTART IDENTITY CASCADE;

