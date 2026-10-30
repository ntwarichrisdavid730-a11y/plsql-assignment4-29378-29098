CREATE OR REPLACE FUNCTION calculate_average_grade (
    p_student_id IN NUMBER
)
RETURN NUMBER
AS
    v_average NUMBER;
    v_exists  NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_exists
    FROM students
    WHERE student_id = p_student_id;

    IF v_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Student not found.');
    END IF;

    SELECT AVG(grade)
    INTO v_average
    FROM enrollments
    WHERE student_id = p_student_id;

    RETURN v_average;
END;
/
SELECT
    s.first_name,
    s.last_name,
    calculate_average_grade(s.student_id) AS average_grade
FROM students s
ORDER BY s.last_name;