
SET SERVEROUTPUT ON;

-- Test 1: Two courses have 3 credits
BEGIN
    find_course_by_credits(3);
END;
/

-- Test 2: No course has 6 credits
BEGIN
    find_course_by_credits(6);
END;
/
