SET SERVEROUTPUT ON;

DECLARE
    v_inserted NUMBER;
    v_failed   NUMBER;
BEGIN
    bulk_register_students(
        p_course_id => 9999,
        p_inserted  => v_inserted,
        p_failed    => v_failed
    );

    DBMS_OUTPUT.PUT_LINE('Successfully inserted: ' || v_inserted);
    DBMS_OUTPUT.PUT_LINE('Failed registrations: ' || v_failed);
END;
/