CREATE OR REPLACE PACKAGE student_collection_pkg AS

    TYPE student_name_list IS TABLE OF VARCHAR2(100);

    FUNCTION get_student_names
    RETURN student_name_list;

END student_collection_pkg;
/

CREATE OR REPLACE PACKAGE BODY student_collection_pkg AS

    FUNCTION get_student_names
    RETURN student_name_list
    AS
        v_names student_name_list;
    BEGIN
        SELECT first_name || ' ' || last_name
        BULK COLLECT INTO v_names
        FROM students
        ORDER BY last_name;

        RETURN v_names;
    END get_student_names;

END student_collection_pkg;
/