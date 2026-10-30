
CREATE OR REPLACE PROCEDURE display_students_cursor
AS
    CURSOR student_cursor IS
        SELECT first_name, last_name, email
        FROM students
        ORDER BY last_name;

    v_student student_cursor%ROWTYPE;
BEGIN
    OPEN student_cursor;

    LOOP
        FETCH student_cursor INTO v_student;
        EXIT WHEN student_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            v_student.first_name || ' ' ||
            v_student.last_name || ' - ' ||
            v_student.email
        );
    END LOOP;

    CLOSE student_cursor;
END;
/

SELECT object_name, status
FROM user_objects
WHERE object_name = 'DISPLAY_STUDENTS_CURSOR'
AND object_type = 'PROCEDURE';