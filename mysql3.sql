CREATE DATABASE practice;
USE practice;
CREATE TABLE sales(
	prductLine VARCHAR(255),
    year DATE,
    sum int
);
INSERT INTO sales
values
	('1', '25-4-25', 20),
    ('2', '25-4-25', 20),
    ('3', '25-4-25', 20);

SELECT * FROM sales;
SELECT prductLine, SUM(sum) FROM sales GROUP BY prductLine;

SELECT prductLine, SUM(sum) FROM sales GROUP BY prductLine, year WITH ROLLUP;

CREATE TABLE items (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);
INSERT INTO items(id, name, price) 
VALUES (1, 'Item', 50.00);

CREATE TABLE item_changes (
    change_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT,
    change_type VARCHAR(10),
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES items(id)
);

DELIMITER //

CREATE TRIGGER update_items_trigger
AFTER UPDATE
ON items
FOR EACH ROW
BEGIN
    INSERT INTO item_changes (item_id, change_type)
    VALUES (NEW.id, 'UPDATE');
END;
//

DELIMITER ;

CREATE VIEW sales_summary AS
SELECT 
    prductLine, 
    year, 
    SUM(sum) AS total_sales
FROM sales
GROUP BY prductLine, year;


SELECT * FROM sales_summary WHERE total_sales > 10;

CREATE INDEX idx_product_line ON sales(prductLine);

CREATE INDEX idx_item_price ON items(price);

UPDATE items SET price = 55.00 WHERE id = 1;