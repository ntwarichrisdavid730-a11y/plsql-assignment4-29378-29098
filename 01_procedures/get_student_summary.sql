CREATE OR REPLACE PROCEDURE get_student_summary (
    p_student_id   IN  NUMBER,
    p_course_count OUT NUMBER,
    p_average      OUT NUMBER
)
AS
    v_student students%ROWTYPE;
BEGIN
    SELECT *
    INTO v_student
    FROM students
    WHERE student_id = p_student_id;

    p_course_count := 0;

    FOR r IN (
        SELECT c.course_code, e.grade
        FROM enrollments e
        JOIN courses c ON c.course_id = e.course_id
        WHERE e.student_id = p_student_id
    )
    LOOP
        p_course_count := p_course_count + 1;

        DBMS_OUTPUT.PUT_LINE(
            r.course_code || ': ' ||
            NVL(TO_CHAR(r.grade), 'ungraded')
        );
    END LOOP;

    p_average := calculate_average_grade(p_student_id);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20005, 'Student not found.');
END;
/