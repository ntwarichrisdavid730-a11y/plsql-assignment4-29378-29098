
CREATE OR REPLACE PROCEDURE display_all_students
AS
    TYPE student_name_table IS TABLE OF VARCHAR2(100);

    v_names student_name_table;
BEGIN
    SELECT first_name || ' ' || last_name
    BULK COLLECT INTO v_names
    FROM students
    ORDER BY last_name;

    FOR i IN 1 .. v_names.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(v_names(i));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total students: ' || v_names.COUNT);
END;
/

SELECT object_name, status
FROM user_objects
WHERE object_name = 'DISPLAY_ALL_STUDENTS'
AND object_type = 'PROCEDURE';