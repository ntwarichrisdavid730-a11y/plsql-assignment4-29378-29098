
CREATE OR REPLACE PROCEDURE display_student_record (
    p_student_id IN NUMBER
)
AS
    TYPE student_record_type IS RECORD (
        student_name VARCHAR2(100),
        student_email VARCHAR2(100)
    );

    v_student student_record_type;
BEGIN
    SELECT first_name || ' ' || last_name, email
    INTO v_student.student_name, v_student.student_email
    FROM students
    WHERE student_id = p_student_id;

    DBMS_OUTPUT.PUT_LINE('Student Name: ' || v_student.student_name);
    DBMS_OUTPUT.PUT_LINE('Student Email: ' || v_student.student_email);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Student not found.');
END;
/

SELECT object_name, status
FROM user_objects
WHERE object_name = 'DISPLAY_STUDENT_RECORD'
AND object_type = 'PROCEDURE';