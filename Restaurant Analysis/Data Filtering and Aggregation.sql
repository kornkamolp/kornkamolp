/*
Restaurant Data Analysis with SQL

This project explores a restaurant's data using SQL queries.  
The database includes tables for staff, menu items, and transactions, allowing us to analyze sales, staff performance, and popular dishes.
This is a basic EDA (Exploratory Data Analysis) using SQL, providing initial insights into the restaurant's operations.

Tables:
- staff: Information about restaurant staff (staff_id, Firstname, Lastname).
- menu: Details about menu items (menu_id, staff_id, menu, course, price).
- transactions: Records of customer transactions (transactions_id, transactions_date, menu_id, quantity, staff_id).

Queries demonstrate the use of:
- WITH clause (Common Table Expressions - CTEs)
- Subqueries
- Aggregate functions (SUM) & GROUP BY
- WHERE clause
- JOINs (INNER JOIN)
*/

-- Create staff table
CREATE TABLE staff (
    staff_id int,
    Firstname text,
    Lastname text
);

INSERT INTO staff values
    (1, 'John ', 'Smith'),
    (2, 'Zara', 'Jane'),
    (3, 'Anne', 'Marie Dumont'),
    (4, 'Mike', 'Jackson');

-- Create menu table
CREATE TABLE menu (
    menu_id INT,
    staff_id INT,
    menu TEXT,
    course TEXT,
    price REAL
);

INSERT INTO menu values
    (1, 2, 'Aglio e olio angel hair', 'Main Dish', 260),
    (2, 1, 'Fresh Fettuccine creamy truffle sauce', 'Main Dish', 330),
    (3, 4, 'Spaghetti glass fed beef bolognese','Main Dish', 310),
    (4, 3, 'Fish n chips','Main Dish', 330),
    (5, 1, 'Chicken Alfredo','Main Dish', 280),
    (6, 2, 'Tofu Scramble','Main Dish', 250),
    (7, 4, 'Strawberry Cheesecake', 'Dessert', 150),
    (8, 3, 'Apple Crumble', 'Dessert', 180),
    (9, 4, 'Tiramisu', 'Dessert', 180);

-- Create transactions table
CREATE TABLE transactions (
    transactions_id INT,
    transactions_date DATE,
    menu_id INT,
    quantity INT,
    staff_id INT,
    FOREIGN KEY (menu_id) REFERENCES menu(menu_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

INSERT INTO transactions (transactions_id, transactions_date, menu_id, quantity, staff_id)
VALUES (1, '2024-07-04', 1, 2, 2),
       (2, '2024-07-04', 2, 1, 1),
       (3, '2024-07-04', 7, 3, 4),
       (4, '2024-07-01', 3, 1, 4),
       (5, '2024-07-02', 6, 3, 2),
       (6, '2024-07-03', 8, 3, 3),
       (7, '2024-07-05', 6, 3, 2);


-- Query 1: View transactions with details (using JOINs)
SELECT
    transactions_id AS 'No.',
    transactions_date AS Date,
    menu,
    quantity AS qty,
    quantity * price AS 'total price',
    Firstname || ' ' || Lastname AS 'cooked by'
FROM transactions
INNER JOIN staff ON transactions.staff_id = staff.staff_id
INNER JOIN menu ON transactions.menu_id = menu.menu_id;


-- Query 2: Find the most expensive Main Dish (using subquery and ORDER BY/LIMIT)
SELECT menu, price
FROM menu
WHERE course = 'Main Dish'
ORDER BY price DESC
LIMIT 1;


-- Query 3: Calculate total revenue per staff member for July 2024 (using CTE, aggregate function, and GROUP BY)
WITH revenue_per_transaction AS (
    SELECT 
        transactions.transactions_id,
        transactions.staff_id,
        transactions.quantity,
        menu.price * transactions.quantity AS transaction_revenue
    FROM transactions
    INNER JOIN menu ON transactions.menu_id = menu.menu_id
    WHERE transactions_date BETWEEN '2024-07-01' AND '2024-07-31'  -- Filter for July 2024
)

SELECT staff.Firstname || ' ' || staff.Lastname AS Chef,
    SUM(transaction_revenue) AS total_revenue
FROM revenue_per_transaction
INNER JOIN staff ON revenue_per_transaction.staff_id = staff.staff_id
GROUP BY staff.staff_id, staff.Firstname, staff.Lastname;
