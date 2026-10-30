
CREATE OR REPLACE PROCEDURE update_student_grade (
    p_student_id IN NUMBER,
    p_course_id  IN NUMBER,
    p_new_grade  IN NUMBER
)
AS
BEGIN
    UPDATE enrollments
    SET grade = p_new_grade
    WHERE student_id = p_student_id
      AND course_id = p_course_id;

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Grade updated successfully.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No enrollment found.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Rows affected: ' || SQL%ROWCOUNT);

    COMMIT;
END;
/

SELECT object_name, status
FROM user_objects
WHERE object_name = 'UPDATE_STUDENT_GRADE'
AND object_type = 'PROCEDURE';