SET SERVEROUTPUT ON;

DECLARE
    v_course_count NUMBER;
    v_average NUMBER;
BEGIN
    get_student_summary(
        p_student_id => 1,
        p_course_count => v_course_count,
        p_average => v_average
    );

    DBMS_OUTPUT.PUT_LINE('Courses: ' || v_course_count);
    DBMS_OUTPUT.PUT_LINE(
        'Average: ' || NVL(TO_CHAR(v_average), 'No grades')
    );
END;
/