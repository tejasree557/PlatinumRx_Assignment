-- Q1
SELECT user_id, room_no
FROM (
    SELECT user_id, room_no,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) rn
    FROM bookings
) t
WHERE rn = 1;

-- Q2
SELECT b.booking_id,
       SUM(bc.item_quantity * i.item_rate) total_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(b.booking_date)=11 AND YEAR(b.booking_date)=2021
GROUP BY b.booking_id;

-- Q3
SELECT bc.bill_id,
       SUM(bc.item_quantity * i.item_rate) bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date)=10 AND YEAR(bc.bill_date)=2021
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

-- Q4
WITH t AS (
 SELECT MONTH(bill_date) m, item_id, SUM(item_quantity) qty
 FROM booking_commercials
 WHERE YEAR(bill_date)=2021
 GROUP BY m,item_id
),
r AS (
 SELECT *, 
 RANK() OVER (PARTITION BY m ORDER BY qty DESC) r1,
 RANK() OVER (PARTITION BY m ORDER BY qty ASC) r2
 FROM t
)
SELECT * FROM r WHERE r1=1 OR r2=1;

-- Q5
WITH t AS (
 SELECT MONTH(bill_date) m, bill_id,
 SUM(item_quantity*i.item_rate) amt
 FROM booking_commercials bc
 JOIN items i ON bc.item_id=i.item_id
 WHERE YEAR(bill_date)=2021
 GROUP BY m,bill_id
),
r AS (
 SELECT *, DENSE_RANK() OVER (PARTITION BY m ORDER BY amt DESC) rk
 FROM t
)
SELECT * FROM r WHERE rk=2;
