
CREATE OR REPLACE PROCEDURE bulk_adjust_course_grades (
    p_course_id IN NUMBER,
    p_increment IN NUMBER
)
AS
    TYPE enrollment_id_table IS TABLE OF enrollments.enrollment_id%TYPE;

    v_enrollment_ids enrollment_id_table;
BEGIN
    IF p_increment < 0 OR p_increment > 10 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Increment must be between 0 and 10.');
    END IF;

    SELECT enrollment_id
    BULK COLLECT INTO v_enrollment_ids
    FROM enrollments
    WHERE course_id = p_course_id
      AND grade IS NOT NULL;

    IF v_enrollment_ids.COUNT > 0 THEN
        FORALL i IN 1 .. v_enrollment_ids.COUNT
            UPDATE enrollments
            SET grade = LEAST(grade + p_increment, 100)
            WHERE enrollment_id = v_enrollment_ids(i);

        DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No graded enrollments found.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Bulk update failed: ' || SQLERRM);
        RAISE;
END;
/


SELECT object_name, status
FROM user_objects
WHERE object_name = 'BULK_ADJUST_COURSE_GRADES'
AND object_type = 'PROCEDURE';