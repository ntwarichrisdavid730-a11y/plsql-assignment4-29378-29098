SET SERVEROUTPUT ON;

BEGIN
    insert_enrollment(
        p_student_id => 1,
        p_course_id  => 2
    );
END;
/