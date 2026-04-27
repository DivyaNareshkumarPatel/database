create table persons(id integer primary key, name varchar(255) not null, age integer not null);

select id as person_id from persons;

INSERT INTO persons (id, name, age) VALUES (1, 'divya', 22);
INSERT INTO persons (id, name, age) VALUES (2, 'patel', 22);

select * from persons order by id offset 1 fetch first row only;

CREATE TABLE orders ( order_id INTEGER PRIMARY KEY, product_name VARCHAR(255), price INTEGER, person_id INTEGER, FOREIGN KEY (person_id) REFERENCES persons(id));

INSERT INTO orders (order_id, product_name, price, person_id) VALUES (101, 'Laptop', 1200, 1);
INSERT INTO orders (order_id, product_name, price, person_id) VALUES (102, 'Mouse', 25, 1);
INSERT INTO orders (order_id, product_name, price, person_id) VALUES (103, 'Keyboard', 75, NULL);

SELECT persons.name, orders.product_name
FROM persons
INNER JOIN orders ON persons.id = orders.person_id;

SELECT persons.name, orders.product_name
FROM persons
LEFT JOIN orders ON persons.id = orders.person_id;

SELECT persons.name, orders.product_name
FROM persons
LEFT JOIN orders ON persons.id = orders.person_id;

CREATE INDEX idx_person_name ON persons(name);
CREATE VIEW person_order_summary AS
SELECT p.name, o.product_name, o.price FROM persons p INNER JOIN orders o ON p.id = o.person_id;

CREATE TABLE logs ( log_id SERIAL PRIMARY KEY, message TEXT, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

CREATE OR REPLACE FUNCTION log_new_person() 
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO logs(message) 
    VALUES ('New person added: ' || NEW.name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_after_insert_person
AFTER INSERT ON persons
FOR EACH ROW
EXECUTE FUNCTION log_new_person();

