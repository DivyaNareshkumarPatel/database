create database company;
show databases;
drop database company;
CREATE DATABASE example;
use example;
CREATE TABLE persons(
	PersonID int PRIMARY KEY,
    FirstName varchar(255) NOT NULL,
    LastName varchar(255) NOT NULL,
    Address varchar(255),
    city varchar(255)
);
CREATE TABLE p SELECT PersonID, FirstName, LastName, Address, city from persons;
DROP TABLE p;

DROP TABLE IF EXISTS p;
TRUNCATE TABLE persons;

ALTER TABLE persons ADD COLUMN Age INTEGER;

ALTER TABLE persons DROP COLUMN Age;
ALTER TABLE persons RENAME COLUMN city TO City;

ALTER TABLE persons MODIFY PersonID bigint;
ALTER TABLE persons ADD COLUMN Age INTEGER;
ALTER TABLE persons ADD CONSTRAINT CHECK_AGE CHECK (Age>=18);

ALTER TABLE persons RENAME TO person;
ALTER TABLE person ADD DOB date;

ALTER TABLE person MODIFY COLUMN DOB YEAR;

ALTER TABLE person DROP COLUMN DOB;
ALTER TABLE person MODIFY City VARCHAR(255) NOT NULL;

ALTER TABLE person MODIFY City VARCHAR(255) NULL;

ALTER TABLE person ADD CONSTRAINT unique_id UNIQUE (PersonID);

ALTER TABLE person DROP CONSTRAINT unique_id;
ALTER TABLE person ADD PRIMARY KEY (PersonID);
ALTER TABLE person DROP PRIMARY KEY;

ALTER TABLE person ADD CONSTRAINT PK_KEY PRIMARY KEY (PersonID);
ALTER TABLE person DROP CONSTRAINT PK_KEY;

CREATE TABLE orders(OrderID int PRIMARY KEY, OrderNUMBER INTEGER, PersonID BIGINT,
CONSTRAINT fk_person FOREIGN KEY(personID) REFERENCES person(personID));

ALTER TABLE orders DROP FOREIGN KEY fk_person;

CREATE INDEX NAME_IDX ON person(FirstName, LastName);

ALTER TABLE person DROP INDEX NAME_IDX;

ALTER TABLE person AUTO_INCREMENT = 100;