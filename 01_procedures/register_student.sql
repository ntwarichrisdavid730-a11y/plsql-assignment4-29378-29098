CREATE OR REPLACE PROCEDURE register_student (
    p_student_id IN NUMBER,
    p_course_id  IN NUMBER
)
AS
BEGIN
    INSERT INTO enrollments (student_id, course_id)
    VALUES (p_student_id, p_course_id);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Student registered successfully.');

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Student is already registered for this course.');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Registration failed: ' || SQLERRM);
        RAISE;
END;
/

SELECT object_name, status
FROM user_objects
WHERE object_name = 'REGISTER_STUDENT'
AND object_type = 'PROCEDURE';