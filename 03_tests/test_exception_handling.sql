
SET SERVEROUTPUT ON;

-- Test 1: Valid grade
BEGIN
    assign_student_grade(1, 1, 95);
END;
/

-- Test 2: Invalid grade
BEGIN
    assign_student_grade(1, 1, 105);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/
