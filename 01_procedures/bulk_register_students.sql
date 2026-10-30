CREATE OR REPLACE PROCEDURE bulk_register_students (
    p_course_id IN  NUMBER,
    p_inserted  OUT NUMBER,
    p_failed    OUT NUMBER
)
AS
    TYPE id_table IS TABLE OF students.student_id%TYPE;
    v_ids id_table;

    e_bulk_errors EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_bulk_errors, -24381);
BEGIN
    p_inserted := 0;
    p_failed   := 0;

    SELECT student_id
    BULK COLLECT INTO v_ids
    FROM students;

    IF v_ids.COUNT > 0 THEN
        BEGIN
            FORALL i IN 1 .. v_ids.COUNT SAVE EXCEPTIONS
                INSERT INTO enrollments (student_id, course_id)
                VALUES (v_ids(i), p_course_id);

            p_inserted := SQL%ROWCOUNT;

        EXCEPTION
            WHEN e_bulk_errors THEN
                p_inserted := SQL%ROWCOUNT;
                p_failed := SQL%BULK_EXCEPTIONS.COUNT;

                FOR j IN 1 .. SQL%BULK_EXCEPTIONS.COUNT LOOP
                    DBMS_OUTPUT.PUT_LINE(
                        'Student ' ||
                        v_ids(SQL%BULK_EXCEPTIONS(j).ERROR_INDEX) ||
                        ' failed: ' ||
                        SQLERRM(-SQL%BULK_EXCEPTIONS(j).ERROR_CODE)
                    );
                END LOOP;
        END;
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/