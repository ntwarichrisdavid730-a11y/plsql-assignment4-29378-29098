SET SERVEROUTPUT ON;

DECLARE
    v_deleted NUMBER;
BEGIN
    remove_enrollment(
        p_student_id => 9999,
        p_course_id => 9999,
        p_rows_deleted => v_deleted
    );

    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || v_deleted);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected test error: ' || SQLERRM);
END;
/