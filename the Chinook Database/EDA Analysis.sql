-- Select and aggregate functions
SELECT
    firstname,
    country,
    company,
    COALESCE(company, 'B2C') AS clean_company,  -- Use AS for aliases
    SUBSTR(country, 2, 1)
FROM 
  customers;

SELECT 
	name,
   ROUND(milliseconds/60000.0,2) as minutes,
   ROUND(bytes/(1024*1024.0),2) as megabytes
FROM 
  tracks;

SELECT
 	count (*),
    AVG(bytes),
    SUM(bytes) as sum_bytes,
    MIN(milliseconds) as min_mil,
    MAX(milliseconds) as max_mil
FROM 
  tracks;

SELECT 
 	count (*),
    COUNT (firstname),
    COUNT (company)
FROM 
  customers;

-- Filtering Invoices by Date
select invoiceid, invoicedate, billingcountry 
from invoices
where invoicedate <= '2009-02-01';

select invoiceid, invoicedate, billingcountry 
from invoices
where invoicedate <= '2009-02-01 00:00:00';

-- Filtering Invoices within a Date Range
SELECT invoiced, invoicedate 
FROM invoices
WHERE invoicedate BETWEEN '2009-01-01 00:00:00' AND '2009-01-03 00:00:00';

-- Extracting Date Parts and Filtering
WITH InvoiceDates AS (
    SELECT invoicedate,
           STRFTIME('%Y', invoicedate) AS 'year',
           STRFTIME('%m', invoicedate) AS 'month',
           STRFTIME('%d', invoicedate) AS 'day',
           STRFTIME('%Y-%m', invoicedate) AS 'monthid'
    FROM invoices
)
SELECT *
FROM InvoiceDates
WHERE monthid = '2009-09';

-- Combining more concepts in a single query
WITH customer_invoices AS (
    SELECT
        c.CustomerId,
        c.FirstName || ' ' || c.LastName AS CustomerName,
        i.InvoiceDate,
        i.Total
    FROM
        Customers c
    JOIN
        Invoices i ON c.CustomerId = i.CustomerId
),
monthly_revenue AS (
    SELECT
        STRFTIME('%Y-%m', InvoiceDate) AS InvoiceMonth,
        SUM(Total) AS MonthlyTotal
    FROM
        customer_invoices
    GROUP BY
        InvoiceMonth
)
SELECT
    InvoiceMonth,
    MonthlyTotal
FROM
    monthly_revenue
ORDER BY
    InvoiceMonth;


-- Example Analytical Questions and Queries
-- What are the top 3 most popular genres based on the number of tracks sold?
SELECT
    g.Name AS GenreName,
    COUNT(t.TrackId) AS NumberOfTracksSold
FROM
    Genres g
JOIN
    Tracks t ON g.GenreId = t.GenreId
JOIN
    Invoice_Items ii ON t.TrackId = ii.TrackId
GROUP BY
    GenreName
ORDER BY
    NumberOfTracksSold DESC
LIMIT 3;

-- What is the total revenue generated by each employee?
SELECT
    e.FirstName || ' ' || e.LastName AS EmployeeName,
    SUM(i.Total) AS TotalRevenue
FROM
    Employees e
JOIN
    Customers c ON e.EmployeeId = c.SupportRepId
JOIN
    Invoices i ON c.CustomerId = i.CustomerId
GROUP BY
    EmployeeName
ORDER BY
    TotalRevenue DESC;
