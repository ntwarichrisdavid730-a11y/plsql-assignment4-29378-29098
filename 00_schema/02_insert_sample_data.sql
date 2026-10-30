
INSERT INTO students (first_name, last_name, email, date_of_birth)
VALUES ('Amina', 'Uwase', 'amina.uwase@example.com', DATE '2003-04-12');

INSERT INTO students (first_name, last_name, email, date_of_birth)
VALUES ('Eric', 'Niyonsenga', 'eric.niyonsenga@example.com', DATE '2002-09-25');

INSERT INTO students (first_name, last_name, email, date_of_birth)
VALUES ('Grace', 'Mukamana', 'grace.mukamana@example.com', DATE '2004-01-08');

INSERT INTO courses (course_code, course_name, credits)
VALUES ('INSY8311', 'Advanced Database Programming', 3);

INSERT INTO courses (course_code, course_name, credits)
VALUES ('INSY8321', 'Database Systems', 4);

INSERT INTO courses (course_code, course_name, credits)
VALUES ('INSY8331', 'Systems Analysis', 3);

INSERT INTO enrollments (student_id, course_id, grade)
SELECT s.student_id, c.course_id, 85
FROM students s CROSS JOIN courses c
WHERE s.email = 'amina.uwase@example.com'
  AND c.course_code = 'INSY8311';

INSERT INTO enrollments (student_id, course_id, grade)
SELECT s.student_id, c.course_id, 92
FROM students s CROSS JOIN courses c
WHERE s.email = 'eric.niyonsenga@example.com'
  AND c.course_code = 'INSY8321';

INSERT INTO enrollments (student_id, course_id, grade)
SELECT s.student_id, c.course_id, 78
FROM students s CROSS JOIN courses c
WHERE s.email = 'grace.mukamana@example.com'
  AND c.course_code = 'INSY8331';

COMMIT;

SELECT s.first_name, s.last_name, c.course_code, c.course_name, e.grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
ORDER BY s.last_name;