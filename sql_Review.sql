--SQL REVIEW 

--)ROUND 1

--1)What are the first and last names of the actors that were in the film 'African Egg'


SELECT f.title , fa.actor_id, a.first_name, a.last_name 
FROM film f 
JOIN film_actor fa 
ON f.film_id = fa.film_id 
JOIN actor a 
ON a.actor_id = fa.actor_id 
WHERE f.title = 'African Egg'

--2)What are the first and last names of the employees and the cities they live in



SELECT  C.country, c2.city, s.first_name , s.last_name  
FROM country c 
JOIN city c2 
ON c.country_id = c2.country_id 
JOIN address a 
ON a.city_id = c2.city_id 
JOIN staff s 
ON s.address_id = a.address_id 



--3)List all film titles with their category names


SELECT f.title, fc.category_id, c."name"  
FROM film f 
JOIN film_category fc 
ON f.film_id = fc.film_id 
JOIN category c 
ON c.category_id =fc.category_id 



--4)List the first and last names of all customers and the first and last names of the employees who assisted them 

SELECT c.first_name AS customer_first_name , c.last_name AS customer_last_name, p.staff_id , s.first_name AS staff_first_name, s.last_name AS staff_last_name 
FROM customer c 
JOIN payment p 
ON c.customer_id = p.customer_id 
JOIN staff s 
ON s.staff_id = p.staff_id 







--5)List the film titles that are located in Store 1

SELECT f.title, i.store_id 
FROM film f 
JOIN inventory i 
ON f.film_id = i.film_id 
WHERE i.store_id = '1'


--)ROUND 2

--List the last names of the staff and the number of customers they assisted 



SELECT s.last_name,  
count(p.customer_id) as NumOfCusstomers
FROM staff s 
JOIN payment p 
ON p.staff_id = s.staff_id 
GROUP BY s.last_name 



select s.last_name, count(r.customer_id) as NumOfCusstomers
from staff s 
join rental r on s.staff_id = r.staff_id 
group by s.last_name 



--List the names of the film categories and the number of films in each



SELECT c."name" , count(fc.film_id) AS numberoffilms
FROM category c 
JOIN film_category fc  
ON fc.category_id = c.category_id 
GROUP BY c."name" 
ORDER BY  numberoffilms DESC 





--List the total sales from each employee, showing the employees last name


SELECT s.last_name, sum(p.amount) 
FROM staff s 
JOIN payment p 
ON s.staff_id = p.staff_id 
GROUP BY s.last_name 
ORDER BY  sum(p.amount) DESC 







--What is the average film length of films featuring the actor Zero Cage


SELECT avg(f.length), a.first_name, a.last_name  
FROM film f 
JOIN film_actor fa 
ON f.film_id = fa.film_id 
JOIN actor a 
ON a.actor_id = fa.actor_id
WHERE a.first_name = 'Zero' AND a.last_name = 'Cage'
GROUP BY a.first_name, a.last_name 



--Show the number of films (including duplicates) each store has which have a rental rate of more than $2.99







--*EVERYONE* Show all the film titles that are not in our inventory. 

SELECT F.film_id, F.title, I.inventory_id  FROM film f  
RIGHT JOIN inventory i 
ON i.film_id = f.film_id 
WHERE I.inventory_id IS NU 


--Show all film titles and the category of their length. If a film is more than 120 minutes long its Epic.
-- If a film is longer or equal to 90 minutes, its Normal. If a film is less than 90 minutes, its Short 


SELECT F.title, F.length, 
CASE
	WHEN F.length >= 120 THEN 'Epic'
	WHEN f.length >= 90 THEN 'Normal'
	ELSE 'Short'
END
FROM film f 





--Show all the film titles and how expensive they are to replace. If a film cost more than $16, its Expensive. 
--If a film costs $16 or less, its Inexpensive 

SELECT f.title, f.replacement_cost, 
CASE
	WHEN f.replacement_cost > 16 THEN 'Expensive'
	ELSE 'Inexpensive'
END
FROM film f 





--Show all the film titles and whether they are appropriate for children. 
--If a film is rated NC-17, R, or PG-13, it’s not appropriate for children. If a film is rated G or PG, 
--then its appropriate for children 

SELECT f.title, f.rating,
CASE 
	WHEN f.rating IN ('NC-17', 'R', 'PG-13') THEN 'Not_appropriate'
	ELSE 'appropriate'
END
FROM film f 




--Show all the titles of the films and whether they are English or Foreign. 
--The languages are labeled as: 1. English 2. Italian 3. Japanese 4. Mandarin 5. French 6. German 

SELECT f.title , f.language_id , l."name" , 
CASE 
	WHEN l.name = 'English' THEN 'English'
	ELSE 'Foreign'
END
FROM film f 
JOIN "language" l 
ON f.language_id = l.language_id 

--Which DVDRENTAL employee handled the smallest amount of transactions? (agregate another agregated table )

WITH amount_of_transactions AS 
(SELECT s.first_name, s.last_name, count(p.payment_id) 
FROM staff s 
JOIN payment p 
ON p.staff_id = s.staff_id 
GROUP BY s.first_name, s.last_name
)
SELECT first_name, last_name, min(count) FROM  amount_of_transactions
GROUP BY  first_name, last_name




--Get the customer ID's of ALL customers who have spent more money than- the average of all customers in the database. 
--AVG(Sum(ammount))


WITH all_customers AS 
(SELECT c.customer_id, sum(p.amount) 
FROM customer c 
JOIN payment p 
ON p.customer_id = c.customer_id 
GROUP BY c.customer_id 
)
SELECT customer_id, avg(sum) FROM all_customers
GROUP BY customer_id 
HAVING avg(sum) > (SELECT avg(sum) FROM all_customers) 






--Show the paymentId, its amount, and the average payment amount 









--**Challenge** Show the film title, its category name, its rental rate, and the average rental rate for that category. 
--compare new output created to output u already have 


SELECT f.title, c."name", f.rental_rate,
avg(f.rental_rate) OVER (PARTITION BY c."name")
FROM film f 
JOIN film_category fc 
ON f.film_id = fc.film_id 
JOIN category c 
ON c.category_id = fc.category_id 






--find avg of number of rentals for all customers , (agregate another agregated table )

WITH count_of_rentals AS 
(SELECT c.customer_id, count( r.rental_id ) 
FROM customer c 
JOIN rental r 
ON c.customer_id = r.customer_id 
GROUP BY c.customer_id 
)
SELECT avg(count) FROM  count_of_rentals






