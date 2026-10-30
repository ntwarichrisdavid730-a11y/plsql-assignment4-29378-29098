# Implementation Notes

## 1. Design Overview

The system models student registration and grading with three normalized tables (`students`, `courses`, `enrollments`). Business rules are enforced twice: by table constraints (the last line of defense) and by PL/SQL validation that returns clear messages before bad data reaches the table.

## 2. Records

- **`%ROWTYPE`:** `display_student` declares `v_student students%ROWTYPE` and fetches an entire row with `SELECT *`. The record adapts automatically if columns change. `display_students_cursor` uses `student_cursor%ROWTYPE`.
- **User-defined record:** `display_student_record` defines `student_record_type` with `student_name` and `student_email`, populated from a concatenated query. Useful when the data does not match a table row.

## 3. Collections

- **Nested table:** `display_all_students` uses `TABLE OF VARCHAR2(100)` filled with `BULK COLLECT`, then iterates with `FOR i IN 1 .. v_names.COUNT`.
- **Nested table of IDs:** `bulk_adjust_course_grades` collects `enrollment_id` values; `bulk_register_students` collects `student_id` values and drives a `FORALL` from them.

## 4. Cursors

**Implicit cursors**

| Statement | Procedure | Attributes |
|-----------|-----------|------------|
| INSERT | `register_student`, `bulk_register_students` | `SQL%ROWCOUNT` |
| UPDATE | `update_student_grade`, `assign_student_grade` | `SQL%FOUND`, `SQL%ROWCOUNT` |
| DELETE | `remove_enrollment` | `SQL%NOTFOUND`, `SQL%ROWCOUNT` |

Attributes are read immediately after the DML, before any other SQL statement can overwrite them.

**Explicit cursors**
- `display_students_cursor`: OPEN, FETCH in a loop, `EXIT WHEN %NOTFOUND`, CLOSE.
- `get_student_summary`: a cursor FOR loop, which opens, fetches and closes automatically.

## 5. Bulk Processing and Performance

`bulk_adjust_course_grades` and `bulk_register_students` use `BULK COLLECT` to read rows into a collection with one SQL call and `FORALL` to send the whole DML batch in one call.

**Why it is faster.** PL/SQL and SQL run in separate engines. A row-by-row `FOR` loop with DML switches between them once per row (a *context switch*), and each switch has a cost. With `FORALL`, the whole collection is sent to the SQL engine in a single switch, so cost grows much more slowly as data grows. For a handful of rows the difference is negligible. For thousands of rows it is typically several times faster.

**Bulk error handling.** `bulk_register_students` uses `FORALL ... SAVE EXCEPTIONS`. Normally the first failing row aborts the statement; with `SAVE EXCEPTIONS`, failing rows are recorded in `SQL%BULK_EXCEPTIONS` (error index and code) and the remaining rows are still processed. The `ORA-24381` exception is trapped, the failures are reported, and the procedure returns the counts of inserted and failed rows through OUT parameters. Example: enrolling every student in a course where one is already registered inserts the rest and reports the duplicate.

**Honest note.** The single-course increment in `bulk_adjust_course_grades` could be written as one UPDATE statement, which would be faster still. It is written with `BULK COLLECT` + `FORALL` here to demonstrate the technique.

## 6. Stored Procedures and Functions

- **Parameters:** IN parameters everywhere; OUT parameters in `bulk_register_students`, `remove_enrollment` and `get_student_summary`.
- **Transaction control:** procedures that change data `COMMIT` on success and `ROLLBACK` before re-raising on failure.
- **Function:** `calculate_average_grade` validates that the student exists (raising -20006 rather than returning a misleading NULL), then returns `AVG(grade)`. It is called from SQL (`SELECT ... calculate_average_grade(s.student_id) FROM students s`) and from `get_student_summary`.

## 7. Exception Handling

| Type | Where |
|------|-------|
| `NO_DATA_FOUND` | `display_student`, `display_student_record`, `get_student_summary`, `find_course_by_credits` |
| `TOO_MANY_ROWS` | `find_course_by_credits` (two courses have 3 credits) |
| `DUP_VAL_ON_INDEX` | `register_student` |
| User-defined (`e_invalid_grade`) | `assign_student_grade` |
| Bulk (`ORA-24381` via `PRAGMA EXCEPTION_INIT`) | `bulk_register_students` |
| `WHEN OTHERS` + `ROLLBACK` + `RAISE` | Data-changing procedures: unexpected errors are never swallowed |

**`RAISE_APPLICATION_ERROR` codes**

| Code | Meaning |
|------|---------|
| -20001 | Grade increment outside 0-10 |
| -20002 | Grade outside 0-100 |
| -20003 | Enrollment not found (update) |
| -20004 | Enrollment not found (delete) |
| -20005 | Student not found (summary) |
| -20006 | Student not found (average function) |

## 8. Testing

Success and error tests are in `03_tests/`, with output screenshots in `screenshots/`. Error tests call procedures inside blocks that catch and print the expected error, so the script continues past each failure.

## 9. Limitations and Possible Improvements

- Grades are numeric 0-100; letter grades or a GPA scale could be added via a lookup table.
- The tests use fixed IDs and assume a fresh schema.
- Bulk procedures operate on whole tables or courses; a production version would take a filter or a collection parameter.
