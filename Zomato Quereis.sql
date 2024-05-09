-- Zomato Case Study 
-- Questions ->
-- Q.1 Find Those customers name who never ordered .
USE zomato;

SELECT name 
FROM users
WHERE user_id NOT IN (SELECT user_id FROM orders);

-- Q.2 Average Price /Dish
SELECT t1.f_name,
AVG(price) AS "Avg_price"
FROM food t1
JOIN menu t2
ON t1.f_id=t2.f_id
GROUP BY t1.f_id,t1.f_name;

-- Q.3 Find top restaurants in terms of the number of orders for a given month-->>"June"
SELECT t2.r_name,COUNT(*) AS "total_order"
FROM orders t1
JOIN restaurants t2
ON t1.r_id=t2.r_id
WHERE MONTHNAME(date) LIKE "June"
GROUP BY t1.r_id,t2.r_name
ORDER BY total_order DESC LIMIT 1;

-- Q.4 Find top restaurants in terms of the number of orders for a given month-->>"July"
SELECT t2.r_name,COUNT(*) AS "total_order"
FROM orders t1
JOIN restaurants t2
ON t1.r_id=t2.r_id
WHERE MONTHNAME(date) LIKE "July"
GROUP BY t1.r_id,t2.r_name
ORDER BY total_order DESC LIMIT 1;

-- Q.5 Find top restaurants in terms of the number of orders for a given month-->>"May"
SELECT t2.r_name,COUNT(*) AS "total_order"
FROM orders t1
JOIN restaurants t2
ON t1.r_id=t2.r_id
WHERE MONTHNAME(date) LIKE "may"
GROUP BY t1.r_id,t2.r_name
ORDER BY total_order DESC LIMIT 1;

-- Q.6 Restaurants with monthly sales > X for
SELECT t2.r_name,SUM(amount) AS "Revenue"
FROM orders t1
JOIN restaurants t2
ON t1.r_id=t2.r_id
WHERE MONTHNAME(date) LIKE "june"
GROUP BY t1.r_id,t2.r_name
HAVING revenue > 500;

-- Q.7 Restaurants with monthly sales > X for july
SELECT t2.r_name,SUM(amount) AS "Revenue"
FROM orders t1
JOIN restaurants t2
ON t1.r_id=t2.r_id
WHERE MONTHNAME(date) LIKE "july"
GROUP BY t1.r_id,t2.r_name
HAVING revenue > 500;

-- Q.8 Show all orders with order details for a particular customer in a particular date range
SELECT order_id,r_name,f_name 
FROM orders t1
JOIN restaurants t2 
ON t1.r_id=t2.r_id
JOIN menu t3
ON t2.r_id=t3.r_id
JOIN food t4
ON t3.f_id=t4.f_id
WHERE  user_id =(SELECT user_id FROM users WHERE name LIKE "Ankit")
AND (date > "2022-06-10" AND date <"2022-07-10");

-- Q.9 Find the most Loyal customers 
SELECT r.r_name,COUNT(*) AS "loyal_customers"
FROM (SELECT r_id,user_id,COUNT(*)  AS "visits" 
		FROM orders
		GROUP BY r_id,user_id
		HAVING visits>1) t
JOIN restaurants r 
ON t.r_id=r.r_id
GROUP BY t.r_id,r.r_name
ORDER BY 'loyal_customers' DESC LIMIT 1 ;

-- Q.10 Month over month growth of zomato

SELECT month,((Revenue-previous_Revenue)/previous_Revenue*100) AS "Revenue_growth" 
FROM (
WITH sales AS (
SELECT MONTHNAME(date) AS "month",
SUM(amount) AS "Revenue" 
FROM orders
GROUP BY MONTHNAME(date)
ORDER BY month DESC
)
SELECT month,Revenue,LAG(Revenue,1) OVER(ORDER BY Revenue) AS "previous_Revenue" FROM sales ) t;


-- Q.11 Customer Faviourate Food

WITH temp AS (
			SELECT t1.user_id,t2.f_id,COUNT(*) 'Frequency' FROM orders t1
			JOIN order_details t2
			ON t1.order_id=t2.order_id
			GROUP BY t1.user_id,t2.f_id
) 
SELECT u.name,f.f_name,t1.frequency 
FROM temp t1 
JOIN users u
ON t1.user_id=u.user_id
JOIN food f
ON f.f_id=t1.f_id
WHERE t1.frequency = (
		SELECT MAX(frequency) 
        FROM temp t2 
        WHERE t2.user_id=t1.user_id
        );
        
-- Mostly Customer Likes CHoco LAVA Cake;






