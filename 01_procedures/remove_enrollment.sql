CREATE OR REPLACE PROCEDURE remove_enrollment (
    p_student_id   IN  NUMBER,
    p_course_id    IN  NUMBER,
    p_rows_deleted OUT NUMBER
)
AS
BEGIN
    DELETE FROM enrollments
    WHERE student_id = p_student_id
      AND course_id = p_course_id;

    p_rows_deleted := SQL%ROWCOUNT;

    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(
            -20004,
            'No enrollment found to delete.'
        );
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/