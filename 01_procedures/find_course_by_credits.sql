
CREATE OR REPLACE PROCEDURE find_course_by_credits (
    p_credits IN NUMBER
)
AS
    v_course_name courses.course_name%TYPE;
BEGIN
    SELECT course_name
    INTO v_course_name
    FROM courses
    WHERE credits = p_credits;

    DBMS_OUTPUT.PUT_LINE('Course: ' || v_course_name);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No course found with those credits.');

    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Multiple courses found with those credits.');
END;
/

SELECT object_name, status
FROM user_objects
WHERE object_name = 'FIND_COURSE_BY_CREDITS'
AND object_type = 'PROCEDURE';