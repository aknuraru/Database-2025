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
insert into airport(airport_id,airport_name,country,state,city,created_at,updated_at)select g,'Airport_' || g,'Kazakhstan','StateB','Almaty',NOW(),NOW() from generate_series(1,200) as g;
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

