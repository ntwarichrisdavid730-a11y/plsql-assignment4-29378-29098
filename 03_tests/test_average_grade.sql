SELECT
    s.first_name,
    s.last_name,
    calculate_average_grade(s.student_id) AS average_grade
FROM students s
ORDER BY s.last_name;