CREATE OR REPLACE PROCEDURE insert_enrollment (
    p_student_id IN NUMBER,
    p_course_id  IN NUMBER
)
AS
BEGIN
    INSERT INTO enrollments (student_id, course_id)
    VALUES (p_student_id, p_course_id);

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Enrollment inserted successfully.');
        DBMS_OUTPUT.PUT_LINE('Rows inserted: ' || SQL%ROWCOUNT);
    END IF;

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(
            -20007,
            'This student is already enrolled in this course.'
        );
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/