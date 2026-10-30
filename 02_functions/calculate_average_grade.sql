
CREATE OR REPLACE FUNCTION calculate_average_grade (
    p_student_id IN NUMBER
)
RETURN NUMBER
AS
    v_average NUMBER;
BEGIN
    SELECT AVG(grade)
    INTO v_average
    FROM enrollments
    WHERE student_id = p_student_id;

    RETURN v_average;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

SELECT object_name, status
FROM user_objects
WHERE object_name = 'CALCULATE_AVERAGE_GRADE'
AND object_type = 'FUNCTION';


