SET SERVEROUTPUT ON;

BEGIN
    update_student_grade(
        p_student_id => 1,
        p_course_id  => 1,
        p_grade      => 110
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/