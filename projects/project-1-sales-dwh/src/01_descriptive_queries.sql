-- Q1 : List all customers who have not placed any orders.

SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;


-- Q2 : Find the top 5 customers by total spendings.
SELECT TOP 5 C.CUSTOMER_ID, C.First_Name, C.Last_Name, Sum(P.payment_amount) AS total_spendings
FROM Customers C
INNER JOIN orders O ON C.CUSTOMER_ID = O.customer_id
INNER JOIN payments P ON O.order_id = P.order_id
GROUP BY 1,2,3
ORDER BY total_spendings DESC
;

--Q3: For each customer, get their MOST RECENT order.
SELECT c.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, O.order_id, O.order_date, O.order_amount
FROM customers C
INNER JOIN orders O ON c.CUSTOMER_ID = O.customer_id
QUALIFY Row_Number() Over (PARTITION BY  O.customer_id ORDER BY O.order_date DESC) = 1
;

-- Q4: Find orders that were paid using more than one payment method.
SELECT O.ORDER_ID, O.customer_id, O.order_date, P.payment_amount, P.payment_method
FROM orders O INNER JOIN payments P ON O.order_id = P.order_id
QUALIFY Row_Number() Over (PARTITION BY O.order_id, P.payment_method ORDER BY O.order_date) > 1
;


-- Q5: Show customers whose total payments DO NOT match their total order amount.
SELECT c.first_name, C.last_name, Sum(O.order_amount) total_order_amount, Sum(P.payment_amount) total_payment_amount
, total_order_amount - total_payment_amount AS diff
FROM Customers c JOIN orders O ON C.customer_id = O.customer_id
INNER JOIN payments P ON O.order_id = P.order_id
GROUP BY 1,2
HAVING total_order_amount <> total_payment_amount
;

-- Q6: Compute 7-day moving average of daily revenue.
SELECT order_date, Sum(order_amount)
,Avg(Sum(O.order_amount)) Over (ORDER BY order_date ROWS BETWEEN 6 Preceding AND CURRENT ROW) AS MOVING_7_DAYS_aVG
FROM orders o
GROUP BY order_date
ORDER BY order_date
;