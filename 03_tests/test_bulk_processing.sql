
SET SERVEROUTPUT ON;

BEGIN
    bulk_adjust_course_grades(1, 5);
END;
/

SELECT
    s.first_name,
    s.last_name,
    c.course_code,
    e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_id = 1;
