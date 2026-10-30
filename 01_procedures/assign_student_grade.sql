
CREATE OR REPLACE PROCEDURE assign_student_grade (
    p_student_id IN NUMBER,
    p_course_id  IN NUMBER,
    p_grade      IN NUMBER
)
AS
    e_invalid_grade EXCEPTION;
BEGIN
    IF p_grade < 0 OR p_grade > 100 THEN
        RAISE e_invalid_grade;
    END IF;

    UPDATE enrollments
    SET grade = p_grade
    WHERE student_id = p_student_id
      AND course_id = p_course_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Enrollment not found.');
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Grade assigned successfully.');

EXCEPTION
    WHEN e_invalid_grade THEN
        RAISE_APPLICATION_ERROR(-20002, 'Grade must be between 0 and 100.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

SELECT object_name, status
FROM user_objects
WHERE object_name = 'ASSIGN_STUDENT_GRADE'
AND object_type = 'PROCEDURE';