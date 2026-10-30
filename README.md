# Group Assignment IV: Advanced Oracle PL/SQL Programming
# Student Registration and Grading System (Oracle PL/SQL)

## Group Members

| Name | Student ID |
- Ntwari Chris David 29378
- Kirenga Ngamije Serge 29098

## Application Description

A university registration and grading system. Students register for courses, lecturers assign and adjust grades, and the system reports student information and averages. All business logic lives in PL/SQL stored procedures and functions, with exception handling throughout.

### Requirements

- Store students, courses and enrollments with integrity enforced by constraints
- Register a student for a course and prevent duplicate registration
- Assign a grade to a single enrollment (validated 0-100)
- Adjust all grades of a course in bulk
- Register all students in a course in bulk, reporting individual failures
- Remove an enrollment
- Display student details and list students
- Calculate a student's average grade
- Return meaningful errors for invalid input, never silent failures

## Database Schema

Three tables in a one-to-many-to-one relationship (students and courses are linked through enrollments, a many-to-many relationship).

| Table | Key columns | Constraints |
|-------|-------------|-------------|
| `students` | `student_id` (identity PK), names, `email`, `date_of_birth`, `enrollment_date` | PK, UNIQUE(email), NOT NULL |
| `courses` | `course_id` (identity PK), `course_code`, `course_name`, `credits` | PK, UNIQUE(course_code), CHECK credits 1-6 |
| `enrollments` | `enrollment_id` (identity PK), `student_id`, `course_id`, `grade` | PK, 2 FKs, UNIQUE(student_id, course_id), CHECK grade 0-100 |

```
students 1 ----< enrollments >---- 1 courses
```

Sample data: 3 students, 3 courses, 3 graded enrollments.

## Stored Code

| Object | Type | Concepts demonstrated |
|--------|------|-----------------------|
| `register_student` | Procedure | Implicit INSERT, `DUP_VAL_ON_INDEX`, `WHEN OTHERS` with RAISE |
| `display_student` | Procedure | `%ROWTYPE` record, `NO_DATA_FOUND` |
| `display_student_record` | Procedure | User-defined record |
| `display_all_students` | Procedure | Nested table, `BULK COLLECT` |
| `display_students_cursor` | Procedure | Explicit cursor: OPEN / FETCH / CLOSE |
| `update_student_grade` | Procedure | `SQL%FOUND`, `SQL%ROWCOUNT` |
| `assign_student_grade` | Procedure | User-defined exception, `RAISE_APPLICATION_ERROR` (-20002, -20003) |
| `bulk_adjust_course_grades` | Procedure | `BULK COLLECT` + `FORALL`, validation (-20001) |
| `bulk_register_students` | Procedure | `FORALL ... SAVE EXCEPTIONS`, `SQL%BULK_EXCEPTIONS`, OUT parameters |
| `remove_enrollment` | Procedure | Implicit DELETE, `SQL%NOTFOUND`, OUT parameter (-20004) |
| `get_student_summary` | Procedure | `%ROWTYPE`, cursor FOR loop, OUT parameters (-20005) |
| `find_course_by_credits` | Procedure | `NO_DATA_FOUND`, `TOO_MANY_ROWS` |
| `calculate_average_grade` | Function | Called from SQL and PL/SQL, validates input (-20006) |

## How to Run

Prerequisites: Oracle Database with the pluggable database `ORCLPDB`, and a user with privileges to create users (the setup block is in `00_schema/01_create_tables.sql`).

1. Run `00_schema/01_create_tables.sql` (creates the `assignment4` user and the tables).
2. Run `00_schema/02_insert_sample_data.sql`.
3. Compile every file in `01_procedures/`. Compile `02_functions/calculate_average_grade.sql` first, because `get_student_summary` depends on it.
4. Run `03_tests/test_success_cases.sql`, then `03_tests/test_error_cases.sql`. Run `SET SERVEROUTPUT ON;` first.
5. Compare results with the screenshots in `screenshots/`.

Tests assume a freshly created schema, so identity IDs start at 1.

## Testing

- `test_success_cases.sql`: registrations, record and collection displays, cursor listing, grade updates, bulk adjustment, bulk registration, deletion, function calls.
- `test_error_cases.sql`: duplicate registration, invalid foreign key, grade out of range, missing enrollment, `TOO_MANY_ROWS`, `NO_DATA_FOUND`, unknown student, increment out of range, partial bulk failure.

## Implementation and Performance Notes

See the Implementation notes.

## AI Usage Disclosure
An AI assistant was used to review our code against the assignment requirements, suggest improvements (bulk error handling, OUT parameters, input validation in the function) and help structure this README and the implementation notes. Both members reviewed, tested and can explain all submitted code.
