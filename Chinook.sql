--1.non_usa_customers.sql: Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
--
SELECT FirstName, LastName, CustomerId, Country 
FROM Customer
WHERE Country <> "USA";

--2. brazil_customers.sql: Provide a query only showing the Customers from Brazil.
SELECT FirstName, LastName, CustomerId, Country 
FROM Customer
WHERE Country = "Brazil";
--
--3. brazil_customers_invoices.sql: Provide a query showing the Invoices of customers who are from Brazil. The resultant table 
--should show the customer's full name, Invoice ID, Date of the invoice and billing country.
SELECT FirstName, LastName, InvoiceId, InvoiceDate, BillingCountry
FROM Customer c
JOIN Invoice i
ON c.CustomerId = i.CustomerId
WHERE Country = "Brazil";

--4. sales_agents.sql: Provide a query showing only the Employees who are Sales Agents.
SELECT FirstName, LastName, Title
FROM Employee
WHERE Title = "Sales Support Agent";
--
--5. unique_invoice_countries.sql: Provide a query showing a unique/distinct list of billing countries from the Invoice table.
--
SELECT DISTINCT (BillingCountry)
FROM Invoice;

--6. sales_agent_invoices.sql: Provide a query that shows the invoices associated with each sales agent. The resultant table should 
--include the Sales Agent's full name.
SELECT i.InvoiceId, e.FirstName || " " || e.LastName AS [FULL NAME] 
FROM Employee e
JOIN Customer c
ON c.SupportRepId = e.EmployeeId
JOIN Invoice i 
ON i.CustomerId = c.CustomerId


--7. invoice_totals.sql: Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices 
--and customers.
SELECT i.Total, c.FirstName, c.LastName, c.Country, e.FirstName, e.LastName
FROM Invoice i
JOIN Customer c
ON c.CustomerId = i.CustomerId
JOIN Employee e 
ON e.EmployeeId = c.CustomerId;
--8. total_invoices_{year}.sql: How many Invoices were there in 2009 and 2011?
--
SELECT SUBSTR(InvoiceDate, 0,5), COUNT (*)
FROM Invoice
WHERE SUBSTR(InvoiceDate, 0,5) LIKE ("2009%") OR SUBSTR(InvoiceDate, 0,5) LIKE ("2011%")
GROUP BY SUBSTR(InvoiceDate, 0,5); 	

--9. total_sales_{year}.sql: What are the respective total sales for each of those years?
--
SELECT SUBSTR(InvoiceDate, 0,5) Year,"$" || Round(SUM(Total), 2) AS [Total Sales]
FROM Invoice 
WHERE SUBSTR(InvoiceDate, 0,5) LIKE ("2009%") OR SUBSTR(InvoiceDate, 0,5) LIKE ("2011%")
GROUP BY SUBSTR(InvoiceDate, 0,5);

--10. invoice_37_line_item_count.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
--
SELECT InvoiceId, Count(InvoiceId)
FROM InvoiceLine
WHERE InvoiceId = 37;

--11. line_items_per_invoice.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
--* makes it count every column and row which is a lot of work on the machine. Try not to use * instead COUNT(InvoiceId)
SELECT InvoiceId, COUNT(*) AS "Items Sold"
FROM InvoiceLine
GROUP BY InvoiceId;

--12. line_item_track.sql: Provide a query that includes the purchased track name with each invoice line item.
--
SELECT t.Name, i.InvoiceLineId
FROM InvoiceLine i 
JOIN Track t  
ON i.TrackId = t.TrackId;

--13. line_item_track_artist.sql: Provide a query that includes the purchased track name AND artist name with each invoice line item.
--
SELECT t.Name, a.Name, i.InvoiceLineId
FROM InvoiceLine i
JOIN Track t
ON i.TrackId = t.TrackId
JOIN Album al 
ON t.AlbumId = al.AlbumId
JOIN Artist a  
ON a.ArtistId = al.ArtistId;

--14. country_invoices.sql: Provide a query that shows the # of invoices per country. HINT: GROUP BY
--
SELECT i.InvoiceId, COUNT(*), i.BillingCountry
FROM Invoice i
GROUP BY i.BillingCountry;

--15. playlists_track_count.sql: Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resulant table.
--
SELECT p.PlaylistId, t.TrackId, COUNT(*), t.Name AS "Track Name"
FROM PlaylistTrack p
JOIN Track t
ON t.TrackId = p.TrackId
GROUP BY p.PlaylistId;

--16. tracks_no_id.sql: Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.
--
SELECT t.Name AS [Track Name], a.Title AS [Album Name], m.Name AS [Media Type], g.Name AS Genre
FROM Track t 
JOIN MediaType m
ON t.MediaTypeId = m.MediaTypeId
JOIN Album a 
ON a.AlbumId = t.AlbumId
JOIN Genre g
ON g.GenreId = t.GenreId;

--17. invoices_line_item_count.sql: Provide a query that shows all Invoices but includes the # of invoice line items.
--
SELECT (i.InvoiceId) AS [Invoices], (il.InvoiceLineId) AS [Invoice Line Items]
FROM  InvoiceLine il
JOIN Invoice i
ON i.InvoiceId = il.InvoiceId;

--18. sales_agent_total_sales.sql: Provide a query that shows total sales made by each sales agent.
--
SELECT c.SupportRepId,e.FirstName || ' ' || e.LastName AS [Employee Name], "$" || ROUND(SUM(i.Total),2) AS "Total Sales"
FROM Customer c
JOIN Invoice i
ON c.CustomerId = i.CustomerId
JOIN Employee e 
ON e.EmployeeId = c.SupportRepId
GROUP BY c.SupportRepId;

--19. top_2009_agent.sql: Which sales agent made the most in sales in 2009?
--What is the core info you are trying to gather and the supporting info to get the core info. 
--Hint: Use the MAX function on a subquery.
SELECT 
	MAX(TotalSales), EmployeeName
FROM
	(
	SELECT
		"$" || printf("%.2f", SUM(i.Total)) AS TotalSales,
		e.FirstName || ' ' || e.LastName AS EmployeeName,
		strftime('%Y',
		i.InvoiceDate) AS InvoiceYear
	FROM
		Invoice i,
		Employee e,
		Customer c 
	WHERE
	i.CustomerId = c.CustomerId
		AND c.SupportRepId = e.EmployeeId
		AND InvoiceYear = '2009'
	GROUP BY 
		e.FirstName || ' ' || e.LastName,
		InvoiceYear ) AS Sales;

--
--20. top_agent.sql: Which sales agent made the most in sales over all?
SELECT c.SupportRepId,e.FirstName || ' ' || e.LastName AS [Employee Name], "$" || ROUND(SUM(i.Total),2) AS "Total Sales"
FROM Customer c
JOIN Invoice i
ON c.CustomerId = i.CustomerId
JOIN Employee e 
ON e.EmployeeId = c.SupportRepId
GROUP BY [Employee Name];
--
--21. sales_agent_customer_count.sql: Provide a query that shows the count of customers assigned to each sales agent.
--
SELECT 
 	e.FirstName || ' ' || e.LastName AS EmployeeName,
 	Count(c.CustomerId) 'Number of Customers'
 From 
 	Employee e 
 Left Join Customer c ON 
 	e.EmployeeId = c.SupportRepId
 WHERE
 	e.Title = 'Sales Support Agent'
 GROUP BY 
 	[EmployeeName];

--22. sales_per_country.sql: Provide a query that shows the total sales per country.
SELECT i.BillingCountry, "$" || ROUND(SUM(i.Total),2) AS [Total Sales]
FROM Invoice i
GROUP BY i.BillingCountry;

--
--23. top_country.sql: Which country's customers spent the most?
--NEED ANSWER
SELECT i.BillingCountry, c.FirstName || ' '|| c.LastName AS [Customer Name], ROUND(SUM(i.Total),2)
FROM Invoice i 
JOIN Customer c
ON c.CustomerId = i.CustomerId
GROUP BY i.Total
ORDER BY [Customer Name];

--24. top_2013_track.sql: Provide a query that shows the most purchased track of 2013.
--NEED ANSWER
SELECT t.TrackId, t.Name, il.Quantity, SUBSTR(i.InvoiceDate,0,5)
FROM InvoiceLine il 
JOIN Track t
ON t.TrackId = il.TrackId
JOIN Invoice i 
ON i.InvoiceId = il.InvoiceId
WHERE SUBSTR(i.InvoiceDate,0,5) = "2013"
GROUP BY t.Name;

SELECT il.Quantity, t.Name
FROM InvoiceLine il 
JOIN Track t
ON t.TrackId = il.TrackId
JOIN Invoice i 
ON i.InvoiceId = il.InvoiceId
ORDER BY t.Name;


--25. top_5_tracks.sql: Provide a query that shows the top 5 most purchased tracks over all.
--
SELECT 
	t.Name, 
	SUM(il.Quantity) NumberPurchased
FROM 
	Track t
JOIN InvoiceLine il ON 
	il.TrackId = t.TrackId 
GROUP BY 
	t.Name 
Order BY 
	NumberPurchased DESC 
LIMIT 5;

--26. top_3_artists.sql: Provide a query that shows the top 3 best selling artists.
--

--27. top_media_type.sql: Provide a query that shows the most purchased Media Type.