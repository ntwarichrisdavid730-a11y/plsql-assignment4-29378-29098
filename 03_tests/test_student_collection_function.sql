SET SERVEROUTPUT ON;

DECLARE
    v_names student_collection_pkg.student_name_list;
BEGIN
    v_names := student_collection_pkg.get_student_names();

    DBMS_OUTPUT.PUT_LINE('Total students: ' || v_names.COUNT);

    FOR i IN 1 .. v_names.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(v_names(i));
    END LOOP;
END;
/