
CREATE OR REPLACE PROCEDURE display_student (
    p_student_id IN NUMBER
)
AS
    v_student students%ROWTYPE;
BEGIN
    SELECT *
    INTO v_student
    FROM students
    WHERE student_id = p_student_id;

    DBMS_OUTPUT.PUT_LINE('Student ID: ' || v_student.student_id);
    DBMS_OUTPUT.PUT_LINE('First Name: ' || v_student.first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name: ' || v_student.last_name);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_student.email);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Student not found.');
END;
/

SELECT object_name, status
FROM user_objects
WHERE object_name = 'DISPLAY_STUDENT'
AND object_type = 'PROCEDURE';