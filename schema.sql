-- SQL Fraud Detection Project
-- Database: PostgreSQL

DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
    tx_id SERIAL PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10, 2),
    tx_time TIMESTAMP,
    city VARCHAR(50)
);

INSERT INTO transactions (user_id, amount, tx_time, city) VALUES
-- User 101: Velocity Fraud
(101, 10.00, '2023-10-01 10:00:00', 'New York'),
(101, 15.00, '2023-10-01 10:00:30', 'New York'),
(101, 12.00, '2023-10-01 10:01:00', 'New York'),
(101, 5.00,  '2023-10-01 10:01:45', 'New York'),

-- User 102: Impossible Travel
(102, 100.00, '2023-10-01 12:00:00', 'Los Angeles'),
(102, 500.00, '2023-10-01 12:10:00', 'London'),

-- User 103: Structuring Near 10k
(103, 9900.00, '2023-10-01 14:00:00', 'Miami'),
(103, 9850.00, '2023-10-01 15:00:00', 'Miami'),

-- User 104: Normal User
(104, 50.00, '2023-10-01 16:00:00', 'Dallas');
