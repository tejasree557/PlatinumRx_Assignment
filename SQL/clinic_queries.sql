-- Q1
SELECT sales_channel, SUM(amount)
FROM clinic_sales
WHERE YEAR(datetime)=2021
GROUP BY sales_channel;

-- Q2
SELECT uid, SUM(amount) total
FROM clinic_sales
WHERE YEAR(datetime)=2021
GROUP BY uid
ORDER BY total DESC
LIMIT 10;

-- Q3
WITH r AS (
 SELECT MONTH(datetime) m, SUM(amount) revenue
 FROM clinic_sales
 WHERE YEAR(datetime)=2021
 GROUP BY m
),
e AS (
 SELECT MONTH(datetime) m, SUM(amount) expense
 FROM expenses
 WHERE YEAR(datetime)=2021
 GROUP BY m
)
SELECT r.m, r.revenue, e.expense,
(r.revenue-e.expense) profit,
CASE WHEN (r.revenue-e.expense)>0 THEN 'profitable'
ELSE 'not-profitable' END
FROM r JOIN e ON r.m=e.m;

-- Q4
WITH t AS (
 SELECT c.city, cs.cid,
 SUM(cs.amount)-COALESCE(SUM(e.amount),0) profit
 FROM clinic_sales cs
 JOIN clinics c ON cs.cid=c.cid
 LEFT JOIN expenses e ON cs.cid=e.cid
 GROUP BY c.city, cs.cid
),
r AS (
 SELECT *, RANK() OVER(PARTITION BY city ORDER BY profit DESC) rk
 FROM t
)
SELECT * FROM r WHERE rk=1;

-- Q5
WITH t AS (
 SELECT c.state, cs.cid,
 SUM(cs.amount)-COALESCE(SUM(e.amount),0) profit
 FROM clinic_sales cs
 JOIN clinics c ON cs.cid=c.cid
 LEFT JOIN expenses e ON cs.cid=e.cid
 GROUP BY c.state, cs.cid
),
r AS (
 SELECT *, RANK() OVER(PARTITION BY state ORDER BY profit ASC) rk
 FROM t
)
SELECT * FROM r WHERE rk=2;
