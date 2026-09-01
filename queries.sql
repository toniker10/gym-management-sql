DROP TABLE IF EXISTS class_registrations;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS trainers;

CREATE TABLE trainers (
    trainer_id    INT PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    specialty     VARCHAR(50)
);

CREATE TABLE members (
    member_id     INT PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    email         VARCHAR(100) UNIQUE,
    phone         VARCHAR(20),
    join_date     VARCHAR(20)
);

CREATE TABLE memberships (
    membership_id INT PRIMARY KEY,
    member_id     INT,
    plan_type     VARCHAR(30),
    start_date    VARCHAR(20),
    end_date      VARCHAR(20),
    price         DECIMAL(8,2),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE classes (
    class_id      INT PRIMARY KEY,
    class_name    VARCHAR(50) NOT NULL,
    trainer_id    INT,
    class_date    VARCHAR(20),
    start_time    VARCHAR(10),
    max_participants INT DEFAULT 15,
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id)
);

CREATE TABLE class_registrations (
    registration_id INT PRIMARY KEY,
    class_id      INT,
    member_id     INT,
    registration_date VARCHAR(20),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

INSERT INTO trainers VALUES
(1, 'Antonios', 'Kerasiotis', 'Strength'),
(2, 'Maria', 'Papadopoulou', 'Yoga'),
(3, 'Makis', 'Vaiopoulos', 'CrossFit'),
(4, 'Eleni', 'Matsou', 'Pilates');

INSERT INTO members VALUES
(1, 'Nikos', 'Karapiperis', 'nikos.karapiperis@email.com', '6941122334', '2024-03-15'),
(2, 'Chris', 'Kerasiotis', 'chris.kerasiotis@email.com', '6934455667', '2024-06-20'),
(3, 'Makis', 'Liatsis', 'makis.liatsis@email.com', '6978899001', '2025-01-10'),
(4, 'Nikos', 'Papastefanou', 'nikos.papastefanou@email.com', '6982233445', '2024-11-05');

INSERT INTO memberships VALUES
(1, 1, 'Premium', '2025-01-01', '2025-12-31', 450.00),
(2, 2, 'Basic', '2025-03-01', '2025-08-31', 180.00),
(3, 3, 'VIP', '2025-02-01', '2026-01-31', 720.00),
(4, 4, 'Premium', '2025-04-01', '2025-09-30', 280.00);

INSERT INTO classes VALUES
(1, 'Morning Yoga', 2, '2025-08-20', '08:00', 12),
(2, 'Strength Training', 1, '2025-08-20', '18:00', 10),
(3, 'CrossFit WOD', 3, '2025-08-21', '19:00', 15),
(4, 'Pilates Beginner', 4, '2025-08-22', '10:00', 10),
(5, 'Evening Yoga', 2, '2025-08-22', '20:00', 12);

INSERT INTO class_registrations VALUES
(1, 1, 2, '2025-08-18'),
(2, 1, 4, '2025-08-18'),
(3, 2, 1, '2025-08-19'),
(4, 2, 3, '2025-08-19'),
(5, 3, 1, '2025-08-19'),
(6, 3, 4, '2025-08-20'),
(7, 4, 2, '2025-08-20'),
(8, 5, 3, '2025-08-21');

-- ===================== QUERIES =====================

SELECT '1. Classes with their trainer' AS query_title;
SELECT c.class_name,
       CONCAT(t.first_name, ' ', t.last_name) AS trainer,
       c.class_date,
       c.start_time
FROM classes c
JOIN trainers t ON c.trainer_id = t.trainer_id
ORDER BY c.class_date, c.start_time;

SELECT '2. Member registrations for classes' AS query_title;
SELECT CONCAT(m.first_name, ' ', m.last_name) AS member,
       c.class_name,
       c.class_date
FROM class_registrations cr
JOIN members m ON cr.member_id = m.member_id
JOIN classes c ON cr.class_id = c.class_id
ORDER BY c.class_date;

SELECT '3. Number of classes per member' AS query_title;
SELECT CONCAT(m.first_name, ' ', m.last_name) AS member,
       COUNT(*) AS total_classes
FROM class_registrations cr
JOIN members m ON cr.member_id = m.member_id
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY total_classes DESC;

SELECT '4. Trainers and their number of classes' AS query_title;
SELECT CONCAT(t.first_name, ' ', t.last_name) AS trainer,
       COUNT(c.class_id) AS number_of_classes
FROM trainers t
LEFT JOIN classes c ON t.trainer_id = c.trainer_id
GROUP BY t.trainer_id, t.first_name, t.last_name
ORDER BY number_of_classes DESC;

SELECT '5. Members with no registrations' AS query_title;
SELECT CONCAT(m.first_name, ' ', m.last_name) AS member
FROM members m
LEFT JOIN class_registrations cr ON m.member_id = cr.member_id
WHERE cr.registration_id IS NULL;

SELECT '6. Total revenue from memberships' AS query_title;
SELECT SUM(price) AS total_revenue
FROM memberships;

SELECT '7. Members with their membership plan' AS query_title;
SELECT CONCAT(m.first_name, ' ', m.last_name) AS member,
       ms.plan_type,
       ms.price
FROM members m
JOIN memberships ms ON m.member_id = ms.member_id
ORDER BY ms.price DESC;