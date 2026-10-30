CREATE OR REPLACE PROCEDURE update_student_grade (
    p_student_id IN NUMBER,
    p_course_id  IN NUMBER,
    p_grade      IN NUMBER
)
AS
BEGIN
    IF p_grade IS NULL OR p_grade < 0 OR p_grade > 100 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Grade must be between 0 and 100.'
        );
    END IF;

    UPDATE enrollments
    SET grade = p_grade
    WHERE student_id = p_student_id
      AND course_id = p_course_id;

    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'No matching enrollment found.'
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/