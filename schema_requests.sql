-- Получить список автомобилей с ФИО владельца, отсортированный по имени владельца.
SELECT c.id AS car_id, c.brand, c.model, o.full_name
FROM Cars c
INNER JOIN Owners o ON c.owner_id = o.id
ORDER BY o.full_name;

--Показать информацию о всех занятых парковочных местах и автомобилях на них.
SELECT ps.spot_number, ps.spot_type, c.license_plate, o.full_name
FROM Parking_spots ps
JOIN Cars c ON ps.car_id = c.id
JOIN Owners o ON c.owner_id = o.id
WHERE ps.status = 'занято' AND ps.is_current = true;

-- Найти владельцев, у которых более одной машины.
SELECT o.full_name, COUNT(c.id) AS car_count
FROM Owners o
JOIN Cars c ON c.owner_id = o.id
GROUP BY o.full_name
HAVING COUNT(c.id) > 1;

--Найти последний въезд каждого автомобиля.
SELECT *
FROM (
    SELECT l.*, 
           RANK() OVER (PARTITION BY car_id ORDER BY entry_time DESC) as rnk
    FROM Logs l
) ranked
WHERE rnk = 1;

--Найти владельцев, у которых есть хотя бы один просроченный платёж.
SELECT o.full_name, o.phone
FROM Owners o
WHERE EXISTS (
    SELECT 1 
    FROM Payments p 
    WHERE p.owner_id = o.id AND p.status = 'просрочено'
);

-- Все машины, которые не стоят на парковке
SELECT * 
FROM Cars
WHERE id NOT IN (
    SELECT car_id 
    FROM Parking_spots 
    WHERE is_current = true AND status = 'занято'
);

--Среднее и максимальное время стоянки на парковке
SELECT car_id, 
       AVG(exit_time - entry_time) AS avg_duration,
       MAX(exit_time - entry_time) AS max_duration
FROM Logs
WHERE exit_time IS NOT NULL
GROUP BY car_id;

--Самые дорогие платежи с именами владельцев
SELECT o.full_name, p.amount, p.status
FROM Payments p
JOIN Owners o ON p.owner_id = o.id
ORDER BY p.amount DESC
LIMIT 5;

-- Автомобили, которые выезжали более 3 раз
SELECT car_id, COUNT(id) AS trips
FROM Logs
WHERE exit_time IS NOT NULL
GROUP BY car_id
HAVING COUNT(id) > 3;

--Найти автомобили, которые находятся внутри паркинга
SELECT c.id, c.brand, c.model, l.entry_time
FROM Cars c
JOIN Logs l ON c.id = l.car_id
WHERE l.exit_time IS NULL;
